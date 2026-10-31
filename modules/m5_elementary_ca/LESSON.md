# Module 5 — Elementary cellular automata (Rule 30, 90, 110)

~30 minutes. The first real cellular automaton. Everything you learned — arrays,
`cshift`, `select case`, pure functions — comes together here. By the end you'll
generate the famous Rule 30 triangle and Rule 90's Sierpinski gasket.

## What an elementary CA is

A 1D row of cells, each 0 or 1. Each generation, every cell updates based on
itself and its two immediate neighbors (left, center, right). Three binary
inputs = 8 possible neighborhoods:

```
111  110  101  100  011  010  001  000
```

A **rule** assigns a new cell value (0 or 1) to each of these 8 patterns. Since
there are 8 patterns and each maps to one bit, a rule is an 8-bit number:
0..255. That's why they're called "Rule N".

Wolfram's numbering: write the 8 outcomes in the order above (neighborhood 111
first, 000 last) as bits of N. Equivalently, the outcome for a neighborhood
whose binary value is `p` (0..7) is **bit p of N**.

Example, Rule 90 = `01011010` in binary:

```
pattern value p:  7   6   5   4   3   2   1   0
neighborhood:    111 110 101 100 011 010 001 000
bit of 90:        0   1   0   1   1   0   1   0
```

So neighborhood `100` (p=4) -> 1, neighborhood `010` (p=2) -> 0, etc.

## The core trick: neighborhood index

For a cell with left, center, right in {0,1}, the neighborhood value is:

```
p = 4*left + 2*center + right      ! a number 0..7
newcell = ibits(rule, p, 1)        ! extract bit p of the rule
```

`ibits(value, pos, len)` pulls `len` bits starting at bit `pos` (0-based) out of
an integer. `ibits(rule, p, 1)` is exactly "bit p of rule". This replaces a
giant `select case` — though you could write the `select case` too.

## Doing it to the whole row at once

With `cshift` you get all left/right neighbors without a loop:

```fortran
left  = cshift(row, -1)   ! each cell's left neighbor (wraps around)
right = cshift(row,  1)   ! each cell's right neighbor
p     = 4*left + 2*center + right   ! array of neighborhood indices (center=row)
```

Then map each `p` to the rule's output bit. The cleanest way elementwise is a
small helper applied per element, or `ibits` works on arrays via a loop. In this
module you'll write it per-cell (clear), and we'll vectorize later.

## Why these rules are famous

- **Rule 90**: produces the Sierpinski triangle — a fractal from a single live
  cell. Pure XOR of the two neighbors.
- **Rule 30**: looks random. Wolfram used it as a random number generator; the
  center column passes randomness tests. Chaos from a trivial rule.
- **Rule 110**: proven Turing-complete. A one-dimensional toy that can, in
  principle, compute anything.

## Your task

Fill in `exercise.f90` (module `m5`). Cells are `integer` 0/1, rows are integer
arrays.

1. `neighborhood_index(left, center, right)` — pure function returning
   `4*left + 2*center + right`.
2. `apply_rule(rule, left, center, right)` — pure function returning bit `p` of
   `rule`, where `p = neighborhood_index(...)`. Use `ibits(rule, p, 1)`.
3. `step_row(rule, row)` — given a rule (0..255) and a row, return the next
   generation using **wraparound** neighbors (`cshift`). Loop over cells, or
   build the `p` array and map it — your choice.
4. `evolve(rule, init, ngen)` — run `ngen` generations starting from `init`,
   returning a 2D integer array `hist(ngen+1, n)` where row 1 is `init` and row
   g+1 is the state after g steps. (n = size(init).)
5. `live_count(row)` — number of live (==1) cells. (Use `count` or `sum`.)

Tip for #4: declare `hist(ngen+1, size(init))`, set `hist(1,:) = init`, then
loop `g = 1..ngen` with `hist(g+1,:) = step_row(rule, hist(g,:))`.

```
make m5
```

After it passes, peek at `demo.f90` in this folder and run it to SEE Rule 30 and
Rule 90 printed as triangles:

```
gfortran ../../src/testing.f90 solution.f90 demo.f90 -o demo && ./demo
```
