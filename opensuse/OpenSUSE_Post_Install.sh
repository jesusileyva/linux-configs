#!/bin/bash

echo "--- OpenSUSE Installation Script ---"

# ---- ADD REPOSITORIES ---- #

echo "[ INFORMATION ] Adding Repository: Microsoft"
# Add fish term repository
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://download.opensuse.org/repositories/shells:fish:release:3/openSUSE_Tumbleweed/shells:fish:release:3.repo'

# Add Microsoft Repositories
sudo rpm --import 'https://packages.microsoft.com/keys/microsoft.asc'
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://packages.microsoft.com/yumrepos/edge' 'Microsoft Edge'
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://packages.microsoft.com/yumrepos/vscode' 'Visual Studio Code'

echo "[ INFORMATION ] Adding Repository: GitHub"
# Add GitHub Desktop for Linux Repository
sudo rpm --import 'https://rpm.packages.shiftkey.dev/gpg.key'
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://rpm.packages.shiftkey.dev/rpm/' 'GitHub Desktop'

echo "[ INFORMATION ] Adding Repository: VLC"
# Add VLC Repository
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://download.videolan.org/pub/vlc/SuSE/Tumbleweed/' 'VLC'

# --- Install Codecs from Packman --- #

#echo "[ INFORMATION ] Adding Repository: Packman"
# Add OpenSUSE Packman repository
sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' 'Packman'

echo "[ INFORMATION ] Refreshing Repositories; Importing GPG Keys..."
sudo zypper --gpg-auto-import-keys refresh

echo "[  ATTENTION  ] Installing: Codecs"
# Install the codecs required for multimedia playback from the main repository
sudo zypper install -y ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec vlc-codecs

# NOTE: Not using opi here since it will switch ALL packages that exist in the Packman repository to use Packman.
# We manually specify to install codecs from Packman repository so all other programs are not switched to Packman.
sudo zypper install -y --allow-vendor-change --from Packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec vlc-codecs
# Disable Packman repository
#
# NOTE
# You may want to comment this line out if you want updates from Packman.
# sudo zypper mr -d Packman



# ---- INSTALL SOFTWARE ---- #

# Check for OpenSUSE Tumbleweed updates
echo "[ INFORMATION ] Checking for Updates..."
sudo zypper dup -y

# Begin package installation

echo "[  ATTENTION  ] Installing: KDE Utilities"
# --- Install KDE Utilities --- #
sudo zypper install -y kdeconnect-kde krita kdenlive partitionmanager kvantum-manager

echo "[  ATTENTION  ] Installing: Discord"
# --- Install Discord IM --- #
sudo zypper install -y discord libdiscord-rpc*

echo "[  ATTENTION  ] Installing: Microsoft Edge and VS Code"
# --- Install Microsoft Edge and VS Code --- #
sudo zypper install -y microsoft-edge-stable code

echo "[  ATTENTION  ] Installing: GitHub Desktop & Git"
# --- Install GitHub Desktop and Git --- #
sudo zypper install -y github-desktop git

echo "[  ATTENTION  ] Installing: System Utilities"
# --- Install System Level Utilities --- #
sudo zypper install -y fde-tools bleachbit easyeffects libdbusmenu-glib4 MozillaThunderbird p11-kit-server

echo "[  ATTENTION  ] Installing: VLC"
# --- Install VLC from VideoLAN Repositories --- #
sudo zypper dup -y --from VLC --allow-vendor-change

echo "[  ATTENTION  ] Installing: EasyEffects Presets"
# Install EasyEffects presets
echo 1 | bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"

echo "[  ATTENTION  ] Installing: Fish Terminal"
#install Fish terminal
sudo zypper install -y fish



# ---- CLEANUP ---- #

printf "[ INFORMATION ] Installing: \'autoremove\' command\n"
# Add "autoremove" command to remove any unneeded packages.
echo "alias autoremove=\"sudo zypper packages --unneeded | awk -F'|' 'NR==0 || NR==1 || NR==2 || NR==3 || NR==4 {next} {print $3}' | grep -v Name | sudo xargs zypper remove -y --clean-deps >> ~/Cleanup.log\"" | sudo tee -a /etc/bash.bashrc.local

echo "[ INFORMATION ] Cleaning Up..."
# Run the command to autoremove packages
sudo zypper packages --unneeded | awk -F'|' 'NR==0 || NR==1 || NR==2 || NR==3 || NR==4 {next} {print $3}' | grep -v Name | sudo xargs zypper remove -y --clean-deps >> ~/Cleanup.log

echo "End Of Script. It is recommended to reboot to apply changes."
