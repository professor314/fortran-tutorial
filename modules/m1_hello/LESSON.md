# Module 1 — Hello, Fortran: variables, types, and kinds

~30 minutes. By the end you'll have written and run your first Fortran program
and understand how Fortran represents numbers (which matters a lot for the
math-heavy work coming later).

## Why Fortran?

Fortran (FORmula TRANslation, 1957) is the oldest high-level language still in
daily use. It survives because it is *fast* at numerical array work and the
language is built around math. Weather models, physics engines, and linear
algebra libraries (BLAS/LAPACK, which NumPy and PyTorch sit on top of) are
Fortran underneath. We're going to use it to build cellular automata, which are
nothing but arrays evolving under simple rules: Fortran's home turf.

## Your first program

Create a file and type this (don't copy-paste; typing it builds muscle memory):

```fortran
program hello
   implicit none
   print *, 'Hello, Fortran!'
end program hello
```

- `program hello ... end program hello` wraps an executable program.
- `implicit none` is non-negotiable. Without it, Fortran *guesses* variable
  types from their first letter (a historical misfeature). Always write it.
- `print *, ...` prints to the screen; the `*` means "default formatting".

Compile and run (from this folder, with gfortran on your PATH):

```
gfortran hello.f90 -o hello
./hello          # on Windows: .\hello.exe
```

## Variables and declarations

Declarations go at the top, after `implicit none`:

```fortran
integer :: n
real    :: x
logical :: done
character(len=20) :: name

n = 42
x = 3.14
done = .true.
name = 'Ada'
```

Note `.true.` and `.false.` with the dots. That's Fortran's logical syntax.

## Kinds: the part that matters for math

A plain `real` is single precision (~7 digits). For serious numerical work you
want double (~16 digits) or quad (~33 digits). Fortran expresses this with
*kinds*, and the clean modern way is the `iso_fortran_env` module:

```fortran
use, intrinsic :: iso_fortran_env, only: real64, real128, int64

real(real64)  :: d    ! double precision
real(real128) :: q    ! quad precision
integer(int64) :: big ! 64-bit integer
```

A literal constant can be tagged with a kind using an underscore:

```fortran
real(real64) :: third
third = 1.0_real64 / 3.0_real64   ! computed in double precision
```

If you write `1.0 / 3.0` (no `_real64`), it's computed in *single* precision
first, then assigned — you lose digits before you even start. The `_real64`
suffix is how you avoid that. We'll use this constantly.

## Integer division gotcha

Integer / integer is integer, truncated toward zero:

```fortran
7 / 2          ! == 3, not 3.5
7.0 / 2.0      ! == 3.5
real(7) / 2    ! == 3.5  (real() converts)
```

This bites everyone once. Now it won't bite you.

## Your task

Open `exercise.f90`. It defines a module `m1` with several functions whose
bodies say `! TODO`. Fill them in. Then run the checker:

```
make m1          # from the project root (uses mingw32-make on Windows)
```

or without make:

```
gfortran ../../src/testing.f90 exercise.f90 check.f90 -o check && ./check
```

The functions:

1. `answer()` — return the integer 42.
2. `third_single()` — return `1.0 / 3.0` done in *single* precision then widened
   to real64 (to see the precision loss).
3. `third_double()` — return `1.0 / 3.0` done properly in real64.
4. `safe_divide(a, b)` — integer `a` and `b`, return `a / b` as a real64 value
   (so `safe_divide(7, 2)` is 3.5, not 3.0).
5. `circle_area(r)` — area of a circle of radius `r` in real64. Use
   `4 * atan(1.0_real64)` for pi (a classic Fortran idiom — atan(1) = pi/4).

When `make m1` prints ALL CHECKS PASSED, you've got it. Peek at `solution.f90`
only if you're stuck.
