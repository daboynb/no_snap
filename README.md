# no-snap

# Remove all snap stuff on ubuntu 22.04

| synaptic.sh                     | software_center.sh                 | plasma_discover.sh             |
| ------------------------------- | ---------------------------------- | ------------------------------ |
| Remove snaps                    | Remove snaps                       | Remove snaps                   |
| Install synaptic                | Install gnome_software_center      | Install kde_software_center  |
| Disable telemetry               | Disable telemetry                  | Disable telemetry              |
| Prevent firefox snap reinstall  | Prevent firefox snap reinstall     | Prevent firefox snap reinstall |
| Prevent telemetry reinstall     | Prevent telemetry reinstall        | Prevent telemetry reinstall    |
| Install firefox standard        | Install firefox standard           | Install firefox standard       |
| No flatpak                      | Install flatpak                    | Install flatpak                |

# Know bugs

    - gnome software center can´t remove deb packages 
        (https://bugs.launchpad.net/ubuntu/jammy/+source/gnome-software)
        
    - gnome software center not show any icons of deb packages, work for flatpak ones
