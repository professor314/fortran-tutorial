---
title: "I built myself a Fortran course that grades itself"
date: 2026-10-31T10:54:00-07:00
draft: true
categories: ["coding"]
tags: ["fortran", "cellular-automata", "teaching", "learning", "gfortran"]
description: "Eight 30-minute, test-driven modules that take you from zero Fortran to a cellular-automaton engine with Shannon-entropy analysis."
---

I wanted to learn Fortran. Not "read a tutorial and nod along" learn it, but
actually-write-it learn it. So I built the thing I'd want: a course that hands
me a stack of function stubs marked `! TODO`, and a test checker that tells me
the instant I've filled them in correctly. Green means move on.

And because a course sticks better when it builds toward something, every module
climbs toward one capstone: a **cellular-automaton engine**. CAs are a perfect
match for Fortran. They're just arrays evolving under simple local rules, and
arrays are the thing Fortran has been fast and graceful at since 1957.

## The shape of it

Eight modules, about 30 minutes each:

1. **Hello / types / kinds.** The first program, `implicit none`, and the thing
   that actually matters for numerical work: precision. Why `1.0/3.0` quietly
   loses digits and `1.0_real64/3.0_real64` doesn't.
2. **Control flow.** Loops that *converge*: factorial, the Leibniz series for
   pi, a primality test, the Collatz sequence.
3. **Arrays.** The payoff module. Whole-array math, slicing, and `cshift` for
   circular (wraparound) shifts. This is the CA substrate.
4. **Procedures and modules.** Functions vs subroutines, argument `intent`,
   `pure`, and how to package code so the capstone isn't a mess.
5. **Elementary CA.** Wolfram's Rule 30, 90, 110 on a line of cells. Rule 90
   draws a Sierpinski triangle out of a single live cell. Rule 30 looks like
   static. Both fall out of one bit trick.
6. **2D grids.** Counting each cell's eight neighbors on a toroidal grid, with
   no explicit loop, by adding up the grid shifted in all eight directions.
7. **Conway's Game of Life.** The famous one. Plus file I/O, so you load a
   glider from a text file and watch it walk diagonally across the grid forever.
8. **Capstone.** Generalize Life into a whole *family* of rules (HighLife,
   Seeds, Replicator, ...) and then measure them: population density over time,
   and the Shannon entropy of the configuration.

That last module is my favorite, so let me linger there.

## Measuring chaos

Once you can run a whole family of rules, the interesting question stops being
"what does this one do" and becomes "how do I *compare* them". Information
theory gives a clean answer. Treat a single cell's state as a random variable
that's alive with probability p (the grid's density). Its Shannon entropy is the
binary entropy function:

```
H = -(p log2 p + (1-p) log2 (1-p))   bits
```

Zero when the grid is all one value (no surprise, no information), and maximal
(1 bit) when exactly half the cells are alive. Track H across generations and
the rules sort themselves by *character*. Running four rules from one identical
random seed:

```
Conway Life  B3/S23:  entropy falls 0.92 -> 0.57   (self-organizing)
HighLife     B36/S23: entropy drifts down slowly    (busier)
Seeds        B2/S:    entropy bounces around 0.75    (restless)
Replicator   B1357:   entropy climbs to 1.00         (stays maximally random)
```

You can see Conway's Life settling down and the Replicator refusing to. That's
Wolfram's classification of cellular automata, in miniature, measured instead of
eyeballed.

## The one Fortran gotcha worth the price of admission

The whole course compiles with `-fwrapv`. Here's why. The random-soup generator
in the capstone uses a little linear congruential generator whose multiply
overflows a 64-bit integer on purpose — the wraparound *is* the algorithm. But
signed integer overflow is undefined behavior in the standard, and with
optimization on, the compiler is allowed to assume it never happens. Given that
assumption it can decide the generator's loop produces a constant, and every
"random" cell comes out identical.

`-fwrapv` tells the compiler to guarantee two's-complement wraparound. One flag,
and the randomness comes back. (I learned this the hard way porting a different
project; nice to bake the lesson straight into the course.)

## Why test-driven teaching works

The checker is the teacher. You don't wonder whether your `neighbor_counts` is
right; you run it and the harness says `PASS neighbor_counts([1,0,0,0]) wraps`
or tells you exactly which assertion failed and what it got. It turns learning
into a tight loop: read 15 minutes, write code, get graded in a second, repeat.
Eighty-nine checks across the eight modules, and when they're all green you've
genuinely built a working CA engine, not just followed along.

If you want to learn a language, consider building the grader first. It's more
fun than it sounds, and it keeps you honest.
