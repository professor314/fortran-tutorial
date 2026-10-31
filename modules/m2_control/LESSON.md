# Module 2 — Control flow and loops

~30 minutes. Decisions and repetition. We'll write real numerical loops here:
factorials, a converging series for pi, the Collatz sequence, a primality test.
These loop patterns are exactly what a cellular automaton does to a grid.

## if / else

```fortran
if (x > 0.0_wp) then
   print *, 'positive'
else if (x < 0.0_wp) then
   print *, 'negative'
else
   print *, 'zero'
end if
```

Comparison operators: `<  >  <=  >=  ==  /=` (note `/=` for "not equal").
Logical combiners: `.and.  .or.  .not.` (with the dots).

## do loops

The counted loop:

```fortran
integer :: i, total
total = 0
do i = 1, 10          ! 1 to 10 inclusive
   total = total + i
end do                ! total == 55

do i = 0, 100, 5      ! step of 5: 0,5,10,...,100
   ...
end do
```

The conditional loop and early exit:

```fortran
do
   ... 
   if (done) exit     ! break out
   if (skip) cycle    ! continue to next iteration
end do
```

A `do while`:

```fortran
do while (error > tol)
   ...
end do
```

## select case

Cleaner than a long if/else chain when branching on one integer/character value.
This is how we'll decode cellular-automaton rules later:

```fortran
select case (n)
case (0)
   ...
case (1, 2, 3)        ! a list of values
   ...
case (4:9)            ! a range
   ...
case default
   ...
end select
```

## Numerical convergence loops

A huge amount of scientific computing is "iterate until it stops changing".
Example, the Leibniz series for pi (pi/4 = 1 - 1/3 + 1/5 - ...):

```fortran
real(wp) :: total, sign
integer  :: k
total = 0.0_wp
sign  = 1.0_wp
do k = 0, nterms - 1
   total = total + sign / real(2*k + 1, wp)
   sign  = -sign
end do
pi_estimate = 4.0_wp * total
```

## Your task

Fill in `exercise.f90` (module `m2`):

1. `factorial(n)` — return n! as an `integer(int64)` (so it doesn't overflow as
   fast). `factorial(0) == 1`.
2. `leibniz_pi(nterms)` — the series above, returns a real64 estimate of pi.
3. `collatz_steps(n)` — the Collatz process: while n /= 1, if n is even do
   n = n/2, else n = 3n + 1. Return how many steps it takes to reach 1.
   (`collatz_steps(1) == 0`, `collatz_steps(6) == 8`.)
4. `is_prime(n)` — return `.true.` if n is prime. Handle n < 2 as not prime.
   Trial division up to sqrt(n) is plenty.
5. `count_primes_below(limit)` — count primes strictly less than `limit`
   (use `is_prime`). `count_primes_below(10) == 4` (2,3,5,7).

Run it:

```
make m2
```
