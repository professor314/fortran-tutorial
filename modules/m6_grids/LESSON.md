# Module 6 — 2D grids and neighbor counting

~30 minutes. We go from a line of cells to a grid. The key new skill is counting
each cell's eight neighbors on a **toroidal** grid (edges wrap around) using
`cshift` along both dimensions. This is the engine room of Conway's Game of Life,
which you'll assemble next module.

## 2D arrays, rows and columns

```fortran
integer :: g(4, 5)       ! 4 rows, 5 columns
g(2, 3) = 1              ! row 2, column 3
g(1, :)                  ! all of row 1
g(:, 2)                  ! all of column 2
shape(g)                 ! [4, 5]
size(g, 1)               ! 4 (extent of dimension 1)
size(g, 2)               ! 5
```

Fortran stores 2D arrays **column-major** (first index varies fastest in
memory). For performance-critical loops you'd make the first index the inner
loop, but for this course clarity wins and we mostly use whole-array ops.

## cshift on a 2D array

`cshift` takes an optional `dim` argument saying which axis to roll along:

```fortran
cshift(g, 1, dim=1)    ! shift rows up   (wraps top/bottom)
cshift(g, -1, dim=1)   ! shift rows down
cshift(g, 1, dim=2)    ! shift columns left  (wraps left/right)
cshift(g, -1, dim=2)   ! shift columns right
```

## Counting 8 neighbors with no explicit loop

Here's the trick that makes CA in Fortran feel like cheating. To get, for every
cell, the sum of its 8 surrounding neighbors on a wrapping grid, add up the grid
shifted in all 8 directions:

```fortran
neighbors =  cshift(cshift(g, 1,1), 1,2) + cshift(g, 1,1) + cshift(cshift(g, 1,1),-1,2) &
           + cshift(g, 1,2)                                + cshift(g,-1,2)             &
           + cshift(cshift(g,-1,1), 1,2) + cshift(g,-1,1) + cshift(cshift(g,-1,1),-1,2)
```

That's the 3x3 stencil minus the center, applied to the whole grid at once, with
wraparound for free. Every cell now holds its live-neighbor count (0..8).

A cleaner way to write the same thing is two nested shifts over offsets
{-1,0,1} x {-1,0,1}, skipping (0,0) — which is what you'll implement.

## Your task

Fill in `exercise.f90` (module `m6`). Grids are `integer` arrays of 0/1.

1. `grid_rows(g)` and `grid_cols(g)` — return `size(g,1)` and `size(g,2)`.
2. `shift2d(g, dr, dc)` — return g shifted by dr rows and dc columns with
   wraparound. Implement as `cshift(cshift(g, dr, dim=1), dc, dim=2)`.
3. `neighbor_counts(g)` — return an integer array, same shape as g, where each
   entry is the sum of that cell's 8 toroidal neighbors. Build it by summing
   `shift2d(g, dr, dc)` over dr,dc in {-1,0,1}x{-1,0,1} **except** (0,0).
4. `total_live(g)` — count of live cells (use `sum` or `count`).
5. `density(g)` — fraction of live cells as a real64 (live / total cells).

Tip for #3: start from a zero array of the right shape, loop dr=-1..1, dc=-1..1,
`if (dr==0 .and. dc==0) cycle`, else `counts = counts + shift2d(g, dr, dc)`.

```
make m6
```
