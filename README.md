# doom for TNU

Standalone repository for the TNU `doom` port.

## Output

The build produces:

```sh
build/doom
```

## Requirements

- A checkout of the TNU source tree, or another tree exposing:
  - `userspace/libc/include`
  - `kernel/include`
  - `userspace/linker.ld`
  - `build/obj/userspace/libc/src/crt0.o`
  - `build/user/libtnu.a`
- Doomgeneric upstream source tree placed at `src/doomgeneric`

## Build

```sh
make TNU_ROOT=../tnu
```

If you place this repo inside a TNU checkout, `TNU_ROOT` can usually stay at
its default.
