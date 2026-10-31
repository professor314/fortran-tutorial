# Module 3 — Arrays: Fortran's superpower

~30 minutes. This is the module that makes Fortran worth learning. Arrays are
first-class: you operate on whole arrays at once, slice them, and call intrinsics
that would be hand-written loops in C. A cellular automaton IS an array that you
transform each generation, so everything here is direct preparation.

## Declaring arrays

```fortran
integer :: a(5)                    ! 5 elements, indices 1..5 by default
real(wp) :: v(0:9)                 ! indices 0..9 (you choose bounds!)
integer :: grid(3, 4)              ! 2D: 3 rows, 4 columns
real(wp), allocatable :: big(:)    ! size decided at runtime
```

Fortran arrays are **1-indexed by default** (not 0). You can pick any lower
bound, which is handy. Allocate dynamic arrays with:

```fortran
allocate(big(1000))
...
deallocate(big)   ! optional; auto-freed at scope exit for locals
```

## Whole-array operations

No loop needed. These all act elementwise:

```fortran
real(wp) :: x(100), y(100), z(100)
z = x + y
z = 2.0_wp * x
z = sin(x)            ! elementwise sin of every element
z = x * y             ! elementwise product (NOT matrix mult)
```

Array constructors:

```fortran
integer :: a(5)
a = [1, 2, 3, 4, 5]
a = [(i, i = 1, 5)]           ! implied-do: same thing
```

## Slicing

```fortran
a(2:4)         ! elements 2,3,4
a(::2)         ! every other element (stride 2)
a(:)           ! the whole thing
grid(2, :)     ! row 2 of a 2D array
grid(:, 3)     ! column 3
```

Slicing lets you express a cellular automaton's "look at my neighbors" cleanly:
`row(1:n-2) + row(3:n)` adds each cell's left and right neighbor in one line.

## Reduction and query intrinsics

```fortran
sum(a)              ! total
product(a)
maxval(a) / minval(a)
count(a > 0)        ! how many elements satisfy a condition
any(a < 0)          ! is any element negative?
all(a >= 0)         ! are all non-negative?
size(a)             ! number of elements
sum(a, mask = a>0)  ! sum only the positive ones
```

## where: masked assignment

The vectorized if-for-arrays. We'll use it to apply CA rules:

```fortran
where (a > 0)
   b = 1
elsewhere
   b = 0
end where
```

## matmul and dot_product (the linear algebra)

```fortran
real(wp) :: A(3,3), x(3), y(3), M(3,3)
y = matmul(A, x)        ! matrix * vector
M = matmul(A, A)        ! matrix * matrix
d = dot_product(x, x)   ! scalar
```

## cshift: circular shift (toroidal wraparound!)

This one is gold for cellular automata with periodic boundaries:

```fortran
cshift(a, 1)    ! shift left by 1, wrapping the first element to the end
cshift(a, -1)   ! shift right by 1, wrapping around
```

A cell's left neighbors are `cshift(a, -1)`, right neighbors `cshift(a, 1)`.
You'll build Rule 30 from exactly this next module.

## Your task

Fill in `exercise.f90` (module `m3`). All functions take/return real64 arrays
unless noted.

1. `arange(n)` — return an integer array `[1, 2, ..., n]`.
2. `vec_mean(x)` — the mean of a real64 array (use `sum` and `size`).
3. `vec_norm(x)` — the Euclidean norm sqrt(sum of squares) (use `dot_product`).
4. `count_above(x, threshold)` — how many elements of x exceed threshold
   (use `count`).
5. `clamp01(x)` — return a copy of x with negatives set to 0 and values >1 set
   to 1 (use `where`). Values in [0,1] unchanged.
6. `neighbor_sum(a)` — integer array; return, for each position, the sum of its
   left and right neighbor with **wraparound** (use `cshift`). So for
   `[1,0,0,0]` the result is `[0,1,0,1]` (pos 1's neighbors are pos 4 and 2).

```
make m3
```
