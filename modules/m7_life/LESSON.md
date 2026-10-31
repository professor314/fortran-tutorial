# Module 7 — Conway's Game of Life + file I/O

~30 minutes. Now we assemble a real, famous 2D cellular automaton: Conway's Game
of Life. You already have neighbor counting from Module 6; the Life rule is three
lines. We also add file I/O so you can load seed patterns (a glider!) from disk.

## The rules of Life

Each cell is alive (1) or dead (0). Given its count of live neighbors `n`:

- A **live** cell with 2 or 3 neighbors stays alive; otherwise it dies
  (loneliness if <2, overcrowding if >3).
- A **dead** cell with **exactly 3** neighbors becomes alive (birth).

In one expression, the next state of a cell is alive iff:

```
(alive .and. (n == 2 .or. n == 3)) .or. (dead .and. n == 3)
```

Equivalently: alive next iff `n == 3 .or. (n == 2 .and. alive)`.

## Vectorizing the rule with where

You can compute the whole next grid at once. Given `g` and `n = neighbor_counts(g)`:

```fortran
next = 0
where (n == 3)                 next = 1          ! birth or survival-with-3
where (n == 2 .and. g == 1)    next = 1          ! survival-with-2
```

Order matters a little, but since the two conditions are disjoint in effect
(a cell with n==3 is alive regardless of its current state; the second only adds
cells that are already alive with n==2), this is clean and correct.

## Famous patterns

- **Blinker**: three in a row. Oscillates between horizontal and vertical with
  period 2.
- **Block**: 2x2 square. Still life, never changes.
- **Glider**: 5 cells that walk diagonally across the grid forever (period 4,
  moves one cell diagonally every 4 steps). The hello-world of Life.

## File I/O in Fortran

Reading and writing files uses `open`, `read`/`write`, `close`:

```fortran
integer :: unit, ios
open(newunit=unit, file='pattern.txt', status='old', action='read', iostat=ios)
if (ios /= 0) stop 'cannot open file'
read(unit, *) nrows, ncols          ! list-directed read of two integers
...
close(unit)
```

- `newunit=unit` asks Fortran to pick an unused unit number and hand it back.
- `iostat=ios` captures the status (0 = success) instead of crashing.
- `read(unit, *)` is list-directed (free-form) input; `read(unit, '(fmt)')` is
  formatted.

Our seed file format (see `glider.txt`): first line is `rows cols`, then `rows`
lines of `cols` characters where `#`/`1` = alive and `.`/`0` = dead.

## Your task

Fill in `exercise.f90` (module `m7`). It `use`s your Module 6 solution for
neighbor counts (already wired in the checker), so focus on the Life logic.

1. `life_step(g)` — return the next generation of grid g (toroidal). Use
   `neighbor_counts` (imported) and the `where` rule above.
2. `is_still_life(g)` — `.true.` if `life_step(g)` equals `g` (nothing changes).
3. `period_of(g, maxp)` — return the smallest period p in 1..maxp such that
   evolving g by p steps returns exactly to g; return 0 if none found within
   maxp. (Blinker -> 2, block -> 1.)
4. `parse_char(c)` — pure function: return 1 for '#' or '1', else 0. (Used by
   the file loader.)

The file-loading subroutine `load_grid` is already written for you in the
solution and demo — read it to see Fortran I/O in action; you implement the
cell logic.

```
make m7
```

Then run the demo to watch a glider fly:

```
gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo
```
