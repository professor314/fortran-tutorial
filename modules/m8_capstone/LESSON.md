# Module 8 — Capstone: a generalized CA engine + measuring complexity

~30-45 minutes. The finale. You'll generalize everything into one engine that
runs a whole family of 2D cellular automata (Life is just one member), then
*measure* their behavior with two tools from information theory and statistics:
population **density** over time and **Shannon entropy** of the configuration.
This is where the math-heavy promise pays off.

## Outer-totalistic rules (the "Life-like" family)

Conway's Life is one of a family called **outer-totalistic** rules: the next
state depends only on (a) the cell's current state and (b) the *total* number of
live neighbors, not their arrangement. Such a rule is specified by two sets:

- **Birth set B**: neighbor counts that turn a dead cell alive.
- **Survival set S**: neighbor counts that keep a live cell alive.

Conway's Life is **B3/S23**: born with 3 neighbors, survives with 2 or 3. Other
famous rules:

- **B36/S23** "HighLife" (has a self-replicating pattern).
- **B2/S** "Seeds" (every live cell dies every step; explosive).
- **B1357/S1357** "Replicator" (replicates any pattern).

We'll represent B and S as boolean arrays indexed 0..8 (`born(0:8)`,
`survive(0:8)`), so `born(n)` answers "does a dead cell with n neighbors come
alive?".

## The general step

Given counts `n = neighbor_counts(g)`:

```
next cell = 1  if  (cell dead and born(n))  or  (cell alive and survive(n))
          = 0  otherwise
```

One `where`-free way is elementwise logic; you'll build it with the boolean
lookup arrays.

## Measuring behavior 1: density

Density is just the fraction of live cells (you wrote it in Module 6). Tracked
over generations it reveals the rule's character: Life settles toward a low
steady density (~0.03 from random soup), explosive rules spike then crash,
replicators grow.

## Measuring behavior 2: Shannon entropy

How "disordered" is a configuration? Information theory gives a precise answer.
Partition the grid into small blocks (say 2x2), look at the *distribution* of
block patterns, and compute the Shannon entropy of that distribution:

```
H = - sum over patterns p of  f_p * log2(f_p)
```

where `f_p` is the fraction of blocks showing pattern p. A uniform grid (all
dead or all alive) has every block identical -> one pattern -> H = 0 (no
disorder). A maximally random grid spreads blocks evenly over all 16 possible
2x2 patterns -> H approaches log2(16) = 4 bits. Entropy over time distinguishes
rules that organize (entropy falls) from rules that randomize (entropy stays
high). This is a real technique for classifying CA complexity (Wolfram's four
classes).

For the simplest, robust version we'll compute entropy over the **per-cell**
distribution (just two "patterns", dead and alive):

```
p1 = density,  p0 = 1 - p1
H = -(p0*log2(p0) + p1*log2(p1))      with the convention 0*log2(0) = 0
```

This is the binary entropy function: 0 when the grid is all one value, maximal
(1 bit) when exactly half the cells are alive. It's the entropy of a single
cell's state treated as a random variable.

## Your task

Fill in `exercise.f90` (module `m8`). It imports `neighbor_counts` from Module 6.

1. `make_rule(birth_counts, survive_counts) result(born, survive)` — actually
   two helpers: `in_set(set, n)` is a pure function returning `.true.` if the
   integer n appears in the array `set`. (We build the boolean logic from this.)
2. `general_step(g, birth, survive)` — one generation where `birth` and
   `survive` are integer arrays of neighbor counts (e.g. `[3]` and `[2,3]` for
   Life). A dead cell becomes alive if its count is in `birth`; a live cell
   stays alive if its count is in `survive`. Use `neighbor_counts` and `in_set`.
3. `binary_entropy(p)` — pure function: the binary Shannon entropy
   `-(p*log2(p) + (1-p)*log2(1-p))` in bits, with `entropy(0)=entropy(1)=0`.
4. `density_series(g, birth, survive, ngen)` — return a real64 array of length
   ngen+1 giving the live-cell density at each generation 0..ngen under the
   given rule.
5. `entropy_series(g, birth, survive, ngen)` — same, but the binary entropy of
   the density at each generation.

Sanity: `general_step(g, [3], [2,3])` must reproduce Conway's Life (your
Module 7 result).

```
make m8
```

Then run the capstone demo, which runs several rules from a random seed and
prints their density/entropy curves side by side:

```
gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo
```
