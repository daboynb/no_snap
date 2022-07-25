# no-snap

# Remove all snap stuff on ubuntu 22.04

After snapd got removed you can chose to :

   - Install flatpak only
   - Install synaptic only
   - Install flatpak and synaptic
   - Install flatpak and gnome-software plus integraion
   - Install flatpak and plasma-discover plus integraion
   - If you don't want install anything press 0 to exit


# Run

     wget https://raw.githubusercontent.com/daboynb/no_snap/main/no_snap.sh && chmod +x no_snap.sh && ./no_snap.sh



# Know bugs

    - gnome software center can´t remove deb packages 
        (https://bugs.launchpad.net/ubuntu/jammy/+source/gnome-software)     
    - gnome software center not show any icons of deb packages, work for flatpak ones
