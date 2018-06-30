# qmk_keymap

QMK keymap collection for only the keyboard you own.

**Infomation**: It is not compatible with keyboards whose directory structure is not common. e.g. [clueboard](https://github.com/qmk/qmk_firmware/tree/master/keyboards/clueboard)


## Requirements

[QMK Firmware Build Tools](https://docs.qmk.fm/#/getting_started_build_tools) and `rake`(Ruby 2.3+)


## Usage
### 1. Fork this repository

Fork this repository to your Github account.


### 2. Initialize forked repository

`git clone` the forked repository and execute `rake qmk:init` command in the repository root. this command takes a lot of time.

Since `qmk_firmware` is added as a submodule, execute `git commit` command.


### 3. Add keymap

Add keymap file to `keyboards` directory.

The directory structure is the same as `keyboards` directory in `qmk_firmware`.

#### Example

```
keyboards
├── hhkb
│   └── keymaps
│       └── default
│           └── keymap.c
└── lets_split
    └── keymaps
        └── haru-ake
            ├── config.h
            ├── keymap.c
            └── rules.mk
```


### 4. Compile and upload

Execute `rake` command in the repository root.

It should exist rake tasks to compile and upload firmware.

#### Example

```
$ rake
rake keyboard:all                                  # compile all keyboards
rake keyboard:hhkb:all                             # compile all keymaps
rake keyboard:hhkb:default                         # compile firmware
rake keyboard:hhkb:default:clean                   # clean compiled firmware
rake keyboard:hhkb:default:qmk_dfu                 # compile firmware by qmk-dfu
rake keyboard:hhkb:default:upload:avrdude          # upload firmware using avrdude
rake keyboard:hhkb:default:upload:dfu              # upload firmware using dfu
rake keyboard:hhkb:default:upload:dfu-util         # upload firmware using dfu-uti
rake keyboard:hhkb:default:upload:program          # upload firmware using program
rake keyboard:hhkb:default:upload:teensy           # upload firmware using teensy
rake keyboard:lets_split:all                       # compile all keymaps
rake keyboard:lets_split:haru-ake                  # compile firmware
rake keyboard:lets_split:haru-ake:clean            # clean compiled firmware
rake keyboard:lets_split:haru-ake:qmk_dfu          # compile firmware by qmk-dfu
rake keyboard:lets_split:haru-ake:upload:avrdude   # upload firmware using avrdude
rake keyboard:lets_split:haru-ake:upload:dfu       # upload firmware using dfu
rake keyboard:lets_split:haru-ake:upload:dfu-util  # upload firmware using dfu-uti
rake keyboard:lets_split:haru-ake:upload:program   # upload firmware using program
rake keyboard:lets_split:haru-ake:upload:teensy    # upload firmware using teensy
rake qmk:clean                                     # remove all untracked files in qmk_firmware
rake qmk:init                                      # initialize qmk_firmware
rake qmk:revert                                    # revert qmk_firmware and nested submodules to local HEAD
rake qmk:update                                    # update qmk_firmware to latest commit on upstream
```

You set `subproject` shell environment if you want specify keyboard revision.

e.g. `subproject=rev1 rake keyboard:lets_split:haru-ake`


## Update qmk_keymap

```
$ git remote add upstream https://github.com/haru-ake/qmk_keymap.git
$ git fetch upstream
$ git merge --no-ff upstream/master
```

