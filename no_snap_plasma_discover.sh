#!/bin/bash

# Start
sudo apt update
sudo apt install dbus-x11 -y

echo "Removing snap...This will take a while"
    
    # Stop the daemon
    sudo systemctl stop snapd && sudo systemctl disable snapd

    # Uninstall
    sudo apt purge -y snapd 
    sudo apt purge -y gnome-software-plugin-snap 

    # Prevent snap from being reinstalled 
    printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref 
    sudo mv no-snap.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# Reinstall ca otherwise you will get tls errors 
echo "Reinstall ca-certificates "
sudo apt install --reinstall ca-certificates -y 

# Install "KDE Software Center" 
echo "echo installing kde software center"
sudo apt install --no-install-recommends plasma-discover -y

# Done
echo "Snap removed"

# Disabling telemetry
echo "Disabling telemetry"
sudo apt remove ubuntu-report whoopsie apport -y

# Prevent telemetry from being reinstalled 

    printf "Package: ubuntu-report\nPin: release a=*\nPin-Priority: -10" >> no-ubuntu-report.pref 
    sudo mv no-ubuntu-report.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-ubuntu-report.pref

    printf "Package: whoopsie\nPin: release a=*\nPin-Priority: -10" >> no-whoopsie.pref 
    sudo mv no-whoopsie.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-whoopsie.pref

    printf "Package: apport\nPin: release a=*\nPin-Priority: -10" >> no-apport.pref 
    sudo mv no-apport.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-apport.pref

# Checking for unmet dependencies 
echo "Checking for unmet dependencies"
sudo apt install -f -y

# Prevent firefox snap from being reinstalled 
echo "Setting firefox preferences"
printf "Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" >> mozilla-firefox 
sudo mv mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
sudo chown root:root /etc/apt/preferences.d/mozilla-firefox

printf 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' >> 51unattended-upgrades-firefox
sudo mv 51unattended-upgrades-firefox /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo chown root:root /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# Install firefox
echo "Installing standard firefox"
sudo add-apt-repository ppa:mozillateam/ppa -y
sudo apt update
sudo apt install firefox -y

# Install flatpak 
echo "Installing flatpak"
sudo apt install flatpak plasma-discover-backend-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update, clean the system and reinstall important packages
echo "Update, clean the system and reinstall important packages"
rm -rf ~/snap
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd
sudo apt --dry-run autoremove | grep -Po 'Remv \K[^ ]+'  > ./autoremove.txt
sed '/apport*/d' autoremove.txt > reinstall.txt
rm autoremove.txt
sudo apt autoremove --purge -y
xargs -a reinstall.txt sudo apt install -y
rm reinstall.txt
sudo apt upgrade -y --allow-downgrades

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"