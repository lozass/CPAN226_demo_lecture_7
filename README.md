# Demo Lecture 6 - Intel, ARM, MIPS, and RISC-V Assembly

This repository contains five assembly examples for the same numeric addition workflow:

- `intel/Add_intel.asm`: x64 Intel-syntax GNU assembler program for Windows.
- `intel/Add_intel_linux.s`: x64 Intel-syntax GNU assembler program for Linux.
- `arm/add_arm.s`: ARM Cortex-M3 assembly program that runs in QEMU.
- `mips/add_mips.s`: MIPS32 assembly program (MARS/SPIM syscall style).
- `riscv/add_riscv.s`: RISC-V RV32 assembly program (RARS syscall style).

All versions compute:

- `-2 + 1024 = 1022`

## Project Layout

```text
Demo_Lecture_6/
|- intel/
|  |- Add_intel.asm
|  |- Add_intel_linux.s
|  |- Add_intel.exe (build output)
|- arm/
|  |- add_arm.s
|  |- linker.ld
|  |- build/
|- mips/
|  |- add_mips.s
|- riscv/
|  |- add_riscv.s
|- .vscode/
|  |- tasks.json
|  |- launch.json
|  |- settings.json
```

## Requirements

### Intel (Windows x64)
- MinGW-w64 with `gcc` and `gdb`

### Intel (Linux x64)
- GNU binutils (`as`, `ld`) or `gcc`

### ARM (QEMU)
- Arm GNU Toolchain (`arm-none-eabi-as`, `arm-none-eabi-ld`, `arm-none-eabi-gdb`)
- QEMU (`qemu-system-arm`)
- VS Code extension: `marus25.cortex-debug`

### MIPS
- MARS or SPIM simulator

### RISC-V
- RARS simulator

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

### Intel (Linux)
On Linux:

```bash
gcc -nostdlib -no-pie -x assembler intel/Add_intel_linux.s -o intel/add_intel_linux
./intel/add_intel_linux
```

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

### MIPS
Run `mips/add_mips.s` using MARS or SPIM.

Expected output:

```text
1022
```

### RISC-V
Run `riscv/add_riscv.s` using RARS.

Expected output:

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
