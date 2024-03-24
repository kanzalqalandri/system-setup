# ===============================
#       Update APT Repos
# ===============================

sudo apt update

# ===============================
#     Install APT Packages
# ===============================

# Git
sudo apt install -y git

# wget
sudo apt install -y wget

# Unzip
sudo apt install -y unzip

# VLC
sudo apt install -y vlc

# Gnome Tweaks
sudo apt install -y gnome-tweaks

# Remmina
sudo apt install -y remmina

# Vim
sudo apt install -y vim

# Extension Manager
sudo apt install -y gnome-shell-extension-manager


# ===============================
#        Setup Flatpak
# ===============================

sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# ===============================
#      Install Flatpackages
# ===============================

# Planify
flatpak install -y flathub io.github.alainm23.planify

# WhatsApp
flatpak install -y flathub io.github.mimbrero.WhatsAppDesktop

# Chrome
flatpak install -y flathub com.google.Chrome
# Install Safe Eyes
flatpak install -y flathub io.github.slgobinath.SafeEyes

# Gopeed
flatpak install -y flathub com.gopeed.Gopeed

# Discord
flatpak install -y flathub com.discordapp.Discord

# Flatsweap
flatpak install -y flathub io.github.giantpinkrobots.flatsweep

# Resources
flatpak install -y flathub net.nokyan.Resources

# MissionCenter
flatpak install -y flathub io.missioncenter.MissionCenter

# LocalSend
flatpak install -y flathub org.localsend.localsend_app

# Reminders
flatpak install -y flathub io.github.dgsasha.Remembrance



# ===============================
#      Install Time Dcotor
# ===============================

if [ ! -f "/home/kanzal/.config/TD/timedoctor2.conf" ]; then
    echo "Time Doctor configuration not found. Proceeding with installation."
    wget https://s3.amazonaws.com/sfproc-downloads/3.9.91/linux/ubuntu-18.04/interactive/timedoctor2-setup-3.9.91-linux-x86_64.run
    chmod +x timedoctor2-setup-3.9.91-linux-x86_64.run
    ./timedoctor2-setup-3.9.91-linux-x86_64.run
    rm timedoctor2-setup-3.9.91-linux-x86_64.run
else
    echo "Time Doctor is already installed."
fi


# ===============================
#      Install Duo Connect
# ===============================

if ! command -v duoconnect > /dev/null; then
    echo "Duo Connect not found. Installing..."
    wget https://dl.duosecurity.com/DuoConnect-latest.tar.gz
    tar xzvf DuoConnect-2.0.4.tar.gz
    sudo ./install.sh
    rm install.sh
    rm duoconnect
else
    echo "Duo Connect is already installed."
fi


# ===============================
#        Install VsCode
# ===============================

if ! command -v code > /dev/null; then
    echo "VSCode not found. Installing..."
    wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/863d2581ecda6849923a2118d93a088b0745d9d6/code_1.87.2-1709912201_amd64.deb
    sudo dpkg -i code_1.87.2-1709912201_amd64.deb
    rm code_1.87.2-1709912201_amd64.deb
else
    echo "VSCode is already installed."
fi


# ===============================
#        Setup Starship
# ===============================

if ! command -v starship > /dev/null; then
    sudo apt install -y curl
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
    cp starship.toml ~/.config/
else
    echo "Starship is already installed."
fi


# ===============================
#        Adding Fonts
# ===============================

FONT_DIR="/home/kanzal/.fonts"
TEMP_DIR="/tmp/fonts_temp"
mkdir -p "$FONT_DIR"
echo "$FONT_DIR directory checked."

download_and_install_font() {
  FONT_PATTERN="$1"
  FONT_NAME="$2"
  FONT_URL="$3"
  FONT_ZIP="$TEMP_DIR/$FONT_NAME.zip"
  echo "Checking for $FONT_NAME font..."
  
  if ! ls $FONT_DIR | grep -iq "$FONT_PATTERN"; then
    mkdir -p "$TEMP_DIR"
    echo "$FONT_NAME font not found. Downloading..."
    wget "$FONT_URL" -O "$FONT_ZIP"
    echo "Installing $FONT_NAME font..."
    unzip "$FONT_ZIP" -d "$TEMP_DIR"

    # Move only Regular and Bold .ttf files
    find "$TEMP_DIR" -type f -iname "*regular*.ttf" -exec mv {} "$FONT_DIR/" \;
    find "$TEMP_DIR" -type f -iname "*bold*.ttf" -exec mv {} "$FONT_DIR/" \;

    echo "$FONT_NAME font installed successfully."
    rm -r "$TEMP_DIR"
  else
    echo "$FONT_NAME font is already installed."
  fi
}

download_and_install_font "caskaydia" "CascadiaMono" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaMono.zip"
download_and_install_font "FiraSans" "fira-sans" "https://www.1001fonts.com/download/fira-sans.zip"


# ===============================
#        Updatng Everything
# ===============================

sudo apt update
sudo apt upgrade -y
