# Gnome big screen

## Features

- Unattended system updates
- Installs big-screen friendly media apps for Youtube TODO

## Running the script

You can either fork this repo and adapt the `template.cfg` configuration to your needs, then pass it as an argument...

```sh
# TEST
curl -L https://github.com/margrevm/gnome-big-screen/archive/refs/heads/main.tar.gz | tar xz
chmod +x fedora-post-install.bash
./fedora-post-install.bash template.cfg
```

## Manual steps

### VacuumTube (Youtube)

VacuumTube offers some nice features that can be configured with `Ctrl-O` (see [settings section](https://github.com/shy1132/VacuumTube/tree/main?tab=readme-ov-file#settings)).

Recommended settings:

- [ ] Ad Block = ON
- [ ] Sponsorblock = ON
- [ ] Hardware Decoding = ON
- [ ] Fullscreen = ON
- [ ] Adjust other features as 'Return Dislikes', 'Hide Shorts', 'Low Memory Mode' according to your system and personal preferences.

## Notes

* The script is designed to be **interactive** and may prompt for confirmation during execution.
* It requires `sudo` privileges for system-level changes.
* As with any "flight plan", validate your config and run through it once before trusting it for repeatable setups.

## Contributions

Thanks to @shy1132 for [VacuumTube](https://github.com/shy1132/VacuumTube)

## Credits

Created by Mike Margreve and licensed under the MIT License. The original source can be found here: <https://github.com/margrevm/fedora-post-install> - Made with love in 🇧🇪
