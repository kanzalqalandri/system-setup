# 🖥️ system-setup

> Automated, idempotent provisioning for a fresh Linux developer workstation.

A single Bash script that turns a clean Ubuntu/Debian install into a fully configured development machine — apps, fonts, shell, and DevOps tooling — in one run. Every step is **idempotent**: re-running the script skips anything already installed, so it's safe to run repeatedly.

## ✨ What it installs

**Core utilities** — `git`, `wget`, `unzip`, `vim`, `curl`

**Desktop apps** (APT + Flatpak) — Google Chrome, Firefox, VLC, Discord, Remmina, GNOME Tweaks & Extension Manager, LocalSend, Mission Center, and more

**Shell & fonts** — [Starship](https://starship.rs) prompt + Cascadia Mono Nerd Font and DM Sans

**DevOps tooling** — `kubectl`, `helm`

## 🚀 Usage

```bash
git clone https://github.com/kanzalqalandri/system-setup.git
cd system-setup
chmod +x setup.sh
./setup.sh
```

> **Note:** The script targets APT-based distros (Ubuntu/Debian). Review and adjust the package list and any hardcoded paths before running on your own machine.

## 📂 Structure

```
system-setup/
├── setup.sh     # Main provisioning script
├── fedora.sh    # Fedora variant (WIP)
├── apps/        # App-specific config
└── fonts/       # Bundled fonts
```

## 📄 License

[MIT](./LICENSE)
