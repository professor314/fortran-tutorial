# Learn Fortran from Nothing — a test-driven course

Eight 30-minute modules that take you from "never written a line of Fortran" to
building a generalized cellular-automaton engine and measuring its behavior with
information theory. Every module is a small set of functions you fill in; a test
checker tells you the moment you've got it right.

Built for someone who likes math. The exercises lean into it: series, primes,
Horner's method, linear algebra intrinsics, XOR fractals, Shannon entropy.

## How it works

Each module folder has four files:

- `LESSON.md` — read this first (~15 min). Teaches the concepts.
- `exercise.f90` — a module with function bodies marked `! TODO`. You fill these in.
- `check.f90` — the test checker. Don't edit it.
- `solution.f90` — the reference answer. Peek only when stuck.

Some modules also include a `demo.f90` that *shows* the result (CA triangles, a
flying glider, entropy curves).

You write code in `exercise.f90`, then run the checker:

```
mingw32-make m1      # Windows (MSYS2 UCRT64 on PATH)
make m1              # Linux / macOS / MSYS shell
```

Green `ALL CHECKS PASSED` means move on. To run the reference instead of your
own code, use the `-sol` target (`mingw32-make m1-sol`). To verify the whole
course at once: `mingw32-make test`.

## The path

| # | Module | You learn | You build toward |
|---|--------|-----------|------------------|
| 1 | `m1_hello` | programs, `implicit none`, types, kinds, precision | sane numerics |
| 2 | `m2_control` | if / do / select case, convergence loops | factorial, Leibniz pi, primes |
| 3 | `m3_arrays` | whole-array ops, slicing, intrinsics, `cshift` | the CA substrate |
| 4 | `m4_procedures` | functions vs subroutines, intent, pure, modules | code organization |
| 5 | `m5_elementary_ca` | bit tricks, rule decoding | Rule 30 / 90 / 110 (1D CA) |
| 6 | `m6_grids` | 2D arrays, toroidal `cshift`, stencils | 8-neighbor counting |
| 7 | `m7_life` | the Life rule, file I/O | Conway's Game of Life + glider |
| 8 | `m8_capstone` | outer-totalistic rules, density, Shannon entropy | a CA engine + complexity analysis |

Each module builds on the last. By Module 8 you've written a configurable
cellular-automaton engine (Life, HighLife, Seeds, Replicator, ...) and tools to
measure how ordered or chaotic each rule is over time.

## Setup (Windows)

You need gfortran and GNU make. Via MSYS2:

```powershell
winget install MSYS2.MSYS2
C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm mingw-w64-ucrt-x86_64-gcc-fortran mingw-w64-ucrt-x86_64-make"
# add to user PATH, then open a new terminal
[Environment]::SetEnvironmentVariable("Path", [Environment]::GetEnvironmentVariable("Path","User") + ";C:\msys64\ucrt64\bin", "User")
```

The make binary on Windows is `mingw32-make`.

### No make?

Compile a module by hand (module 1 shown; later modules add their deps):

```
gfortran src/testing.f90 modules/m1_hello/exercise.f90 modules/m1_hello/check.f90 -o check
./check
```

Modules 7 and 8 also need `modules/m6_grids/solution.f90` on the command line
(they use its neighbor-counting routine).

## Seeing it run

After the relevant module passes, build its demo:

```
# Module 5: elementary CA triangles
cd modules/m5_elementary_ca
gfortran ../../src/testing.f90 solution.f90 demo.f90 -o demo && ./demo

# Module 7: a glider flying across the grid (loads glider.txt)
cd modules/m7_life
gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo

# Module 8: density + entropy of several rules from one random seed
cd modules/m8_capstone
gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo
```

## License

MIT.
