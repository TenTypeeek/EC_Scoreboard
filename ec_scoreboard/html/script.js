function post(endpoint, data) {
    return fetch(`https://${GetParentResourceName()}/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {}),
    }).catch(() => null);
}

let state = { serverName: '', maxPlayers: 0, playerCount: 0, showPing: true, players: [], jobs: [], heists: [] };
let currentLocales = {};
let activeTab = 'players';
const searches = { players: '', jobs: '', heists: '' };
const SEARCH_PLACEHOLDERS = {
    players: ['ui_search_players', 'Search players...'],
    jobs: ['ui_search_jobs', 'Search jobs...'],
    heists: ['ui_search_heists', 'Search heists...'],
};
let isOpen = false;

// Pinned jobs are stored on the player's client by the Lua side (resource KVP) and sent on open.
let pinnedJobs = new Set();

const $ = (id) => document.getElementById(id);
const app = $('scoreboard-app');
const searchInput = $('search-input');
const searchCount = $('search-count-text');

function esc(value) {
    return String(value ?? '').replace(/[&<>"']/g, (c) => (
        { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]
    ));
}

function _L(key, fallback) {
    return currentLocales[key] || fallback || key;
}

function translateDOM() {
    document.querySelectorAll('[data-locale]').forEach((el) => {
        const key = el.getAttribute('data-locale');
        if (currentLocales[key]) el.textContent = currentLocales[key];
    });
    const [phKey, phFallback] = SEARCH_PLACEHOLDERS[activeTab];
    searchInput.placeholder = _L(phKey, phFallback);
    updateModeButton();
}

function hexToRgba(hex, alpha) {
    const m = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex || '');
    if (!m) return `rgba(255, 255, 255, ${alpha})`;
    return `rgba(${parseInt(m[1], 16)}, ${parseInt(m[2], 16)}, ${parseInt(m[3], 16)}, ${alpha})`;
}

function safeColor(hex, fallback) {
    return /^#[a-f\d]{6}$/i.test(hex || '') ? hex : fallback;
}

function emptyNotice(icon, text) {
    return `<div class="empty-notice"><i class="fas ${icon}"></i>${esc(text)}</div>`;
}

function renderHeader() {
    $('server-name').textContent = state.serverName;
    $('total-players-count').textContent = `${state.playerCount}/${state.maxPlayers}`;
}

function renderPlayers() {
    const query = searches.players.toLowerCase().trim();
    const list = state.players.filter((p) =>
        String(p.name).toLowerCase().includes(query) ||
        String(p.id).includes(query)
    );

    if (activeTab === 'players') searchCount.textContent = list.length;

    if (list.length === 0) {
        $('players-list').innerHTML = emptyNotice('fa-user-slash', _L('ui_no_players', 'No players found'));
        return;
    }

    $('players-list').innerHTML = list.map((p) => {
        let tag = '';
        if (p.tag) {
            const color = safeColor(p.tag.color, '#ffffff');
            tag = `<div class="tags"><span class="tag tag-admin" style="color: ${color}; background-color: ${hexToRgba(color, 0.15)};"><i class="fas fa-shield-alt"></i> ${esc(p.tag.label)}</span></div>`;
        }

        let pingHtml = '';
        if (state.showPing && p.ping !== undefined && p.ping !== null) {
            const ping = Number(p.ping) || 0;
            const pingClass = ping > 100 ? 'high' : ping > 60 ? 'mid' : 'low';
            pingHtml = `<div class="ping ${pingClass}"><i class="fas fa-signal"></i>${ping}ms</div>`;
        }

        return `
            <div class="list-item">
                <div class="item-left">
                    <div class="id-box">${esc(p.id)}</div>
                    <div class="item-details">
                        <h5><span class="pname">${esc(p.name)}</span></h5>
                        ${tag}
                    </div>
                </div>
                <div class="item-right">${pingHtml}</div>
            </div>`;
    }).join('');
}

function renderJobs() {
    const query = searches.jobs.toLowerCase().trim();
    const list = state.jobs.filter((j) =>
        String(j.label).toLowerCase().includes(query) ||
        String(j.category || '').toLowerCase().includes(query)
    );

    list.sort((a, b) => {
        const aPinned = pinnedJobs.has(a.id) ? 1 : 0;
        const bPinned = pinnedJobs.has(b.id) ? 1 : 0;
        if (aPinned !== bPinned) return bPinned - aPinned;

        const countDiff = (Number(b.count) || 0) - (Number(a.count) || 0);
        if (countDiff !== 0) return countDiff;

        return String(a.label).localeCompare(String(b.label));
    });

    if (activeTab === 'jobs') searchCount.textContent = list.length;

    if (list.length === 0) {
        $('jobs-list').innerHTML = emptyNotice('fa-briefcase', _L('ui_no_jobs', 'No jobs found'));
        return;
    }

    $('jobs-list').innerHTML = list.map((job) => {
        const isPinned = pinnedJobs.has(job.id);
        const color = safeColor(job.color, '#9ca3af');
        const pinTitle = isPinned ? _L('ui_unpin', 'Unpin Job') : _L('ui_pin', 'Pin Job');
        return `
        <div class="list-item single">
            <div class="item-left">
                <div class="activity-icon" style="color: ${color}; background-color: ${hexToRgba(color, 0.12)}; border-color: ${hexToRgba(color, 0.4)};">
                    <i class="fas ${esc(job.icon)}"></i>
                </div>
                <div class="item-details">
                    <h5>${esc(job.label)}</h5>
                    <div class="tags">
                        <span class="tag tag-category">${esc(job.category)}</span>
                    </div>
                </div>
            </div>
            <div class="item-right">
                <div class="count-badge"><i class="fas fa-user-friends"></i><b>${Number(job.count) || 0}</b> ${esc(_L('ui_online', 'online'))}</div>
                <button class="btn-pin ${isPinned ? 'pinned' : ''}" data-job="${esc(job.id)}" type="button" title="${esc(pinTitle)}">
                    <i class="fas fa-thumbtack"></i>
                </button>
            </div>
        </div>`;
    }).join('');

    $('jobs-list').querySelectorAll('.btn-pin').forEach((btn) => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const jobId = btn.dataset.job;
            if (pinnedJobs.has(jobId)) {
                pinnedJobs.delete(jobId);
            } else {
                pinnedJobs.add(jobId);
            }
            post('savePinned', { pinned: [...pinnedJobs] });
            renderJobs();
        });
    });
}

function renderHeists() {
    const query = searches.heists.toLowerCase().trim();
    const list = state.heists.filter((h) => String(h.label).toLowerCase().includes(query));

    list.sort((a, b) => {
        const aOk = a.enoughCops ? 1 : 0;
        const bOk = b.enoughCops ? 1 : 0;
        if (aOk !== bOk) return bOk - aOk;
        return String(a.label).localeCompare(String(b.label));
    });

    if (activeTab === 'heists') searchCount.textContent = list.length;

    if (list.length === 0) {
        $('heists-list').innerHTML = emptyNotice('fa-vault', _L('ui_no_heists', 'No heists found'));
        return;
    }

    $('heists-list').innerHTML = list.map((heist) => {
        const status = heist.enoughCops
            ? `<span class="tag tag-active"><i class="fas fa-check"></i> ${esc(_L('ui_cops_enough', 'Available'))}</span>`
            : `<span class="tag tag-inactive"><i class="fas fa-xmark"></i> ${esc(_L('ui_cops_not_enough', 'Not enough cops'))}</span>`;
        const requires = _L('ui_requires_cops', 'Requires {n} police').replace('{n}', Number(heist.requiredCops) || 0);
        return `
        <div class="list-item single">
            <div class="item-left">
                <div class="activity-icon"><i class="fas ${esc(heist.icon)}"></i></div>
                <div class="item-details">
                    <h5>${esc(heist.label)}</h5>
                    <div class="tags"><span class="tag tag-category">${esc(requires)}</span></div>
                </div>
            </div>
            <div class="item-right">${status}</div>
        </div>`;
    }).join('');
}

function renderTab(tab) {
    if (tab === 'players') renderPlayers();
    else if (tab === 'jobs') renderJobs();
    else if (tab === 'heists') renderHeists();
}

function renderAll() {
    renderHeader();
    renderPlayers();
    renderJobs();
    renderHeists();
}

function switchTab(tab) {
    activeTab = tab;
    document.querySelectorAll('.filter-btn').forEach((b) => b.classList.toggle('active', b.dataset.tab === tab));
    document.querySelectorAll('.page').forEach((p) => p.classList.toggle('active', p.id === `pane-${tab}`));

    const [key, fallback] = SEARCH_PLACEHOLDERS[tab];
    searchInput.placeholder = _L(key, fallback);
    searchInput.value = searches[tab];
    renderTab(tab);
}

function updateModeButton() {
    const compact = document.body.classList.contains('compact');
    $('mode-icon').className = compact ? 'fas fa-expand' : 'fas fa-table-columns';
    $('mode-text').textContent = compact ? _L('ui_full', 'Full') : _L('ui_compact', 'Compact');
}

function toggleMode() {
    document.body.classList.toggle('compact');
    updateModeButton();
    post('saveMode', { compact: document.body.classList.contains('compact') });
}

function openScoreboard() {
    isOpen = true;
    app.style.display = 'flex';
    setTimeout(() => app.classList.add('show'), 10);
}

function hideScoreboard() {
    isOpen = false;
    app.classList.remove('show');
    setTimeout(() => { if (!isOpen) app.style.display = 'none'; }, 300);
}

function requestClose() {
    post('close', {});
    hideScoreboard();
}

$('btn-toggle-mode').addEventListener('click', toggleMode);
$('btn-close').addEventListener('click', requestClose);

document.querySelectorAll('.filter-btn').forEach((btn) => {
    btn.addEventListener('click', () => switchTab(btn.dataset.tab));
});

searchInput.addEventListener('input', (e) => {
    searches[activeTab] = e.target.value;
    renderTab(activeTab);
});

document.addEventListener('keydown', (e) => {
    if (!isOpen) return;

    if (e.key === 'Escape') {
        requestClose();
    } else if (e.key === 'Tab') {
        e.preventDefault();
        toggleMode();
    } else if (document.activeElement !== searchInput) {
        if (e.key === '1') switchTab('players');
        else if (e.key === '2') switchTab('jobs');
        else if (e.key === '3') switchTab('heists');
    }
});

function applyData(data) {
    if (!data) return;
    if (data.locales) currentLocales = data.locales;
    ['serverName', 'maxPlayers', 'playerCount', 'showPing', 'players', 'jobs', 'heists'].forEach((key) => {
        if (data[key] !== undefined) state[key] = data[key];
    });
    if (Array.isArray(data.pinned)) pinnedJobs = new Set(data.pinned);
    if (typeof data.compact === 'boolean') {
        document.body.classList.toggle('compact', data.compact);
    }
    translateDOM();
    renderAll();
}

window.addEventListener('message', (event) => {
    const message = event.data;
    if (!message || !message.action) return;

    if (message.action === 'open') {
        applyData(message.data);
        openScoreboard();
    } else if (message.action === 'update') {
        applyData(message.data);
    } else if (message.action === 'close') {
        hideScoreboard();
    }
});
