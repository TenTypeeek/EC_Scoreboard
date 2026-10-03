# 📊 Eclipse Scoreboard

Give your players a clean, live overview of who is online, which jobs are staffed, and which heists are available.
**Eclipse Scoreboard** is a lightweight, modern resource for FiveM (ESX) that shows players, jobs, and heist availability in a sleek interface with a full-screen and a compact side-panel mode.
Built for server owners who want a smooth, optimized, and good-looking scoreboard without unnecessary bloat.

---

## 💬 Community & Support

Join our Discord community for support, updates, script releases, and custom development!

* **📢 Announcements & Updates:** Be the first to get news on updates and new features.
* **🛠️ Support & Help:** Need help installing or setting up the script? Open a support ticket.
* **💡 Feature Requests:** Have ideas to make Eclipse Scoreboard better? We'd love to hear them!

👉 **[Click Here to Join the Discord Community](https://discord.gg/5D3wdy4dQH)**

---

## 🚀 Why Eclipse Scoreboard?

Players want to know who is online and whether the police, EMS, or mechanics are available before they start a job or plan a heist. Many scoreboards are cluttered, outdated, or hard to configure.
**Eclipse Scoreboard** shows everything in one place. It reads your jobs straight from the database, tracks how many players are online in each one, and shows which heists can start based on the number of police on duty, all in a responsive interface that players can adjust to their liking.

---

## ✨ Features

* **👥 Live Player List:** Shows every player's ID, name, and color-coded ping, with instant search by name or ID.
* **💼 Jobs Overview:** Displays how many players are online in each job, sorted by most active, with category tags and icons.
* **📌 Pinnable Jobs:** Players can pin their favorite jobs to the top of the list. Pins are saved on the player's own client and persist across reconnects and restarts.
* **🏦 Heist Availability:** Shows which heists are available based on the number of online police, with a configurable requirement for each heist.
* **🖥️ Full & Compact Modes:** Switch between a large centered panel and a slim side panel. The last used mode is remembered (optional).
* **🛡️ Admin Tags:** Show Owner, Admin, or Moderator tags next to staff members, with custom labels and colors based on the ESX group.
* **🔄 Automatic Job Loading:** Jobs are read from your database and refreshed at a configurable interval, so new jobs appear without editing the config.
* **🎨 Categories & Overrides:** Group jobs into categories with Font Awesome icons and colors, or override the label, icon, and color of any individual job.
* **🚫 Blacklist & Duty Options:** Hide jobs like `unemployed`, hide jobs with no players online, or count only players who are on duty.
* **⚡ Optimized:** Data is cached on the server and player requests are rate limited, so it stays smooth even on busy servers.
* **⌨️ Keyboard Friendly:** Open with a rebindable key (default `TAB`), close with `ESC`, toggle the mode with `TAB`, and switch tabs with `1`, `2`, and `3`.
* **🌍 Easy Localization:** Every UI text is stored in the config's locale table, so translating the script only takes a few lines.

---

## 🛠️ Compatibility & Dependencies

* **Framework:** `es_extended` (ESX Legacy)
* **Required Scripts:** `oxmysql`

---

## 📥 Installation

1. Download the resource and place it into your server's `resources` folder.
2. Open `config.lua` and adjust the settings to your liking (server name, max players, key and command, blacklisted jobs, categories, heists, admin groups, etc.).
3. Make sure `Config.JobsTable` matches your jobs table. The default ESX table `jobs` (with `name` and `label` columns) works out of the box.
4. Add `ensure ec_scoreboard` (or whatever you named the folder) to your `server.cfg`, ensuring it starts *after* `es_extended` and `oxmysql`.
5. Restart your server.

Your players can now press **TAB** or type **/scoreboard** to see who is online!

---

## 👀 Showcase

<!-- Replace these with your own screenshots -->
![Players](https://i.imgur.com/hUNdh1I.png)
![Jobs](https://i.imgur.com/aNZ9jSN.png)
![Heists](https://i.imgur.com/su1AFLp.png)

---

<div align="center">

### 🌐 Created by Eclipse Development
## 🤖 Made with AI

Need help or custom FiveM scripts?  
[**Join our Discord**](https://discord.gg/5D3wdy4dQH)

</div>