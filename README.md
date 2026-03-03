# Gnome big screen

## Features

- Unattended system updates
- Interactive launcher selection during install
- Optional media app launchers for VacuumTube, Spotify, and Stremio

## Step by step

### 1. Fedora installation

- Add steps here... TODO
- During setup create the `admin` user. This user will be used to configure (sudo) your machine whereas `tv` user will auto-login and be used to watch tv.

Manual user configuration:

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

### 3. Manual configuration

- You can set your preferred wallpaper and accent colour under `Settings > Appearance`;

### 4. Install applications

The script will prompt the user whether or not to install one or several of the following apps:

- [ARTE](apps/arte/README.md)
- [Home Assistant](apps/home-assistant/README.md)
- [Jellyfin](apps/jellyfin/README.md)
- [Netflix](apps/netflix/README.md)
- [RTBF Auvio](apps/auvio/README.md)
- [Spotify](apps/spotify/README.md)
- [Stremio](apps/stremio/README.md)
- [VRT MAX](apps/vrt-max/README.md)
- [YouTube (VacuumTube)](apps/youtube/README.md)

## Contributions

Thanks to @shy1132 for [VacuumTube](https://github.com/shy1132/VacuumTube)

## Credits

Created by Mike Margreve and licensed under the MIT License. The original source can be found here: <https://github.com/margrevm/fedora-post-install> - Made with love in 🇧🇪
