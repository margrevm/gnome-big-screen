# Gnome big screen

## Features

- Unattended system updates
- Interactive launcher selection during install
- Optional media app launchers for VacuumTube, Spotify, and Stremio

## Step by step

### 1. Fedora installation

- Add steps here... TODO
- During setup create the `admin` user. This user will be used to configure (sudo) your machine whereas `tv` user will auto-login and be used to watch tv.

#### Manual user configuration

```sh
# admin user
sudo useradd -m admin
sudo passwd <YOUR PASSWORD>

# tv user
sudo useradd -m tv

# To ensure that 'tv' user has no admin rights
groups tv   
# You should see NO wheel.
```

### 2. Run this script

```sh
# TEST
curl -L https://github.com/margrevm/gnome-big-screen/archive/refs/heads/main.tar.gz | tar xz
chmod +x install.bash
./install.bash
```

During installation, `chromium` and `shutdown` are installed by default.  
For `youtube` (VacuumTube), `spotify`, and `stremio`, selecting the launcher also installs the Flatpak app.

Launcher behavior:
- `chromium` and `shutdown` launchers are installed by default.
- Other launchers are optional and shown one by one during install.
- Prompt names match launcher script names (for example `youtube`, `spotify`, `stremio`).

## 3. Manual configuration

- You can set your preferred wallpaper and accent colour under `Settings > Appearance`;

## 4. App configuration

### VacuumTube (Youtube)

VacuumTube offers some nice features that can be configured with `Ctrl-O` (see [settings section](https://github.com/shy1132/VacuumTube/tree/main?tab=readme-ov-file#settings)).

Recommended settings:

- [ ] Ad Block = ON
- [ ] Sponsorblock = ON
- [ ] Hardware Decoding = ON
- [ ] Fullscreen = ON
- [ ] Adjust other features as 'Return Dislikes', 'Hide Shorts', 'Low Memory Mode' according to your system and personal preferences.

## Notes

- The script is designed to be **interactive** and may prompt for confirmation during execution.
- It requires `sudo` privileges for system-level changes.
- As with any "flight plan", validate your config and run through it once before trusting it for repeatable setups.

## Contributions

Thanks to @shy1132 for [VacuumTube](https://github.com/shy1132/VacuumTube)

## Credits

Created by Mike Margreve and licensed under the MIT License. The original source can be found here: <https://github.com/margrevm/fedora-post-install> - Made with love in 🇧🇪
