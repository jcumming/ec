
# Nix Flake fork

This fork includes a `flake.nix` for building the EC firmware. It has not been
tested and may generate images that will make your laptop unbootable.

To build the firmware images (for oryp9 -- take a look at flake.nix to see how to add more):

```sh
$ nix build .#oryp9-ec-firmware
```

To build the flash utility:

```sh
$ nix build .#system76_ectool
```

To flash. This is the part that will probably brick things.

```sh
$ sudo ./result/bin/system76_ectool flash <firmware>/ec.rom
```

# System76 EC

System76 EC is a GPLv3 licensed embedded controller firmware for System76
laptops.

## Documentation

- [Supported embedded controllers](./doc/controllers.md)
- [Flashing firmware](./doc/flashing.md)
- [Debugging](./doc/debugging.md)
- [Creating a custom keyboard layout](./doc/keyboard-layout-customization.md)
- [Development environment](./doc/dev-env.md)
- [Adding a new board](./doc/adding-a-new-board.md)

## Quickstart

Install dependencies using the provided script.

```sh
./scripts/deps.sh
```

If rustup was installed as part of this, then the correct `cargo` will not be
available in the running session. Start a new shell session or source the env
file to update `PATH`.

```sh
source $HOME/.cargo/env
```

Then build the firmware for your laptop model.

```sh
make BOARD=system76/<model>
```

See [Flashing](./doc/flashing.md) for how to use the new firmware image.

## Releases

The EC firmware itself does not have tagged releases. Any commit of this repo
may be used as a part of a [System76 Open Firmware][firmware-open] release.

In official releases the EC shares the same version as the BIOS firmware. Run
the follow command from firmware-open to determine the corresponding EC commit
for a release.

```
git ls-tree <release_hash> ec
```

[firmware-open]: https://github.com/system76/firmware-open

## Legal

System76 EC is copyright System76 and contributors.

System76 EC firmware is made available under the terms of the GNU General
Public License, version 3. See [LICENSE](./LICENSE) for details.

- firmware: GPL-3.0-only
- ecflash: LGPL-2.1-or-later
- ecsim: MIT
- ectool: MIT

Datasheets for the ITE embedded controllers used in System76 laptops cannot be
shared outside of company. (However, the IT81202E datasheet is [publicly
available][it81202e]. While it uses a different core, a significant portion of
the register information is the same as IT85878E/IT5570E.)

[it81202e]: https://www.ite.com.tw/en/product/view?mid=149
