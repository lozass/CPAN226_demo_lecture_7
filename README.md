# Demo Lecture 6 - Intel and ARM Assembly

This repository contains two assembly examples for the same numeric addition workflow:

- `intel/Add_intel.asm`: x64 Intel-syntax GNU assembler program for Windows.
- `arm/add_arm.s`: ARM Cortex-M3 assembly program that runs in QEMU.

Both versions compute:

- `-2 + 1024 = 1022`

## Project Layout

```text
Demo_Lecture_6/
|- intel/
|  |- Add_intel.asm
|  |- Add_intel.exe (build output)
|- arm/
|  |- add_arm.s
|  |- linker.ld
|  |- build/
|- .vscode/
|  |- tasks.json
|  |- launch.json
|  |- settings.json
```

## Requirements

### Intel (Windows x64)
- MinGW-w64 with `gcc` and `gdb`

### ARM (QEMU)
- Arm GNU Toolchain (`arm-none-eabi-as`, `arm-none-eabi-ld`, `arm-none-eabi-gdb`)
- QEMU (`qemu-system-arm`)
- VS Code extension: `marus25.cortex-debug`

## Build and Run

### Intel
Use VS Code task:

- `Build Intel x64 (gcc as)`

Then run:

- `intel/Add_intel.exe`

Expected output:

```text
1022
```

### ARM (console run)
Use VS Code tasks:

1. `Build ARM ASM`
2. `Run ARM QEMU (console)`

Expected output in terminal:

```text
1022
```

## Debugging (ARM in QEMU)
Use launch profile:

- `ARM (Cortex-Debug + QEMU)`

This uses:

- `Prepare ARM QEMU Debug` task (build + start QEMU gdb server)
- Integrated terminal for QEMU output
- Disassembly view settings saved at workspace level

## Notes

- ARM code uses semihosting (`BKPT 0xAB`) to print text in QEMU.
- Debug and run flows are configured in `.vscode/tasks.json`.
- Workspace debug/disassembly preferences are stored in `.vscode/settings.json`.
