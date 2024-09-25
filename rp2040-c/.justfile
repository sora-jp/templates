alias b := build
alias c := clean
alias f := flash
alias cb := cleanbuild
alias cf := cleanflash
alias fm := flashmonitor

default: build

build:
    #!/usr/bin/env bash
    set -euxo pipefail
    mkdir -p build && cd build && cmake .. && make -j 8
    cp compile_commands.json ..

flash_ocd:
    #!/usr/bin/env bash
    set -euxo pipefail
    cd build
    sudo openocd -f interface/cmsis-dap.cfg -c "transport select swd" -c "adapter_khz 6000" -f target/rp2040.cfg -c "program femtos.elf reset exit"

flash_picotool:
    #!/usr/bin/env bash
    set -euxo pipefail
    cd build
    sudo picotool load -F femtos.uf2
    sudo picotool reboot

flash: build flash_picotool

clean:
    rm -rf build

monitor:
    minicom -D /dev/ttyACM1 -b 115200

debugserver:
    sudo openocd -f interface/cmsis-dap.cfg -c "transport select swd" -c "adapter_khz 6000" -f target/rp2040.cfg

debug:
    gef -x .gdbinit build/femtos.elf

flashmonitor: flash monitor
cleanbuild: clean build
cleanflash: clean flash
