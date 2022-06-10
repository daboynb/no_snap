#!/bin/bash

# Ask for sudo privileges
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Start
sudo apt update

echo "Removing snap...This will take a while"
    
    # Stop the daemon
    sudo systemctl stop snapd && sudo systemctl disable snapd

    # Uninstall
    sudo apt-get purge -y snapd 
    sudo apt-get purge -y gnome-software-plugin-snap 

    # Prevent snap from being reinstalled 
    printf "Package: snapd\nPin: release a=*\nPin-Priority: -10" >> no-snap.pref 
    sudo mv no-snap.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-snap.pref

# Reinstall ca otherwise you will get tls errors 
echo "Reinstall ca-certificates "
sudo apt install --reinstall ca-certificates -y 

# Install "GNOME Software Center" 
echo "echo installing gnome software"
sudo apt install --no-install-recommends gnome-software -y

# Done
echo "Snap removed"

# Disabling telemetry
echo "Disabling telemetry"
sudo apt remove ubuntu-report popularity-contest apport -y

# Prevent telemetry from being reinstalled 

    printf "Package: ubuntu-report\nPin: release a=*\nPin-Priority: -10" >> no-ubuntu-report.pref 
    sudo mv no-ubuntu-report.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-ubuntu-report.pref

    printf "Package: popularity-contest\nPin: release a=*\nPin-Priority: -10" >> no-popularity-contest.pref 
    sudo mv no-popularity-contest.pref /etc/apt/preferences.d/
    sudo chown root:root /etc/apt/preferences.d/no-popularity-contest.pref

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
sudo apt install flatpak gnome-software-plugin-flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Update, clean the system and reinstall important packages
echo "Update, clean the system and reinstall important packages"
sudo rm -R "/snap" "/var/snap" "/var/lib/snapd" "/var/cache/snapd" "/usr/lib/snapd" "/home/$USER/snap"
sudo apt-get --dry-run autoremove | grep -Po 'Remv \K[^ ]+'  > ./autoremove.txt
sed '/apport-symptoms/d' autoremove.txt > reinstall.txt
rm autoremove.txt
sudo apt autoremove --purge -y
xargs -a reinstall.txt sudo apt-get install -y
rm reinstall.txt
sudo apt upgrade -y 

echo "TO APPLY ALL THE CHANGES PLEASE REBOOT"
