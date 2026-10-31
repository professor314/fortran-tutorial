# Module 4 — Procedures and modules

~30 minutes. How to organize code: functions vs subroutines, argument intent,
`pure`, and why `module` is the unit you'll package the CA engine in. Short on
new math, heavy on the structure you'll lean on for the rest of the course.

## Functions vs subroutines

A **function** returns one value and is used in an expression:

```fortran
real(wp) function square(x)
   real(wp), intent(in) :: x
   square = x * x
end function
! use: y = square(3.0_wp)
```

A **subroutine** returns nothing directly; it communicates through its
arguments, and may modify them. Use it when you produce several outputs or
mutate a big array in place:

```fortran
subroutine normalize(v)
   real(wp), intent(inout) :: v(:)
   v = v / norm2(v)
end subroutine
! use: call normalize(myvec)
```

You `call` a subroutine. You don't `call` a function.

## intent: say what you'll do with each argument

Always declare intent. It documents and lets the compiler catch mistakes.

```fortran
integer, intent(in)    :: n     ! read-only; error if you assign to it
real(wp), intent(out)  :: y     ! you must set it; incoming value undefined
real(wp), intent(inout):: v(:)  ! read and modify
```

## pure: no side effects

A `pure` procedure can't do I/O or modify global state or its `in` arguments.
It can only compute a result from its inputs. Marking the CA update rule `pure`
tells the reader (and compiler) "this is a clean mathematical function", and
`pure` procedures can be used in more contexts (like inside `do concurrent`).

```fortran
pure integer function rule_bit(left, center, right)
   integer, intent(in) :: left, center, right
   ...
end function
```

## Optional arguments and defaults

```fortran
subroutine step(grid, wrap)
   integer, intent(inout) :: grid(:)
   logical, intent(in), optional :: wrap
   logical :: do_wrap
   do_wrap = .true.
   if (present(wrap)) do_wrap = wrap
   ...
end subroutine
```

## Modules: the container

A `module` groups related procedures and data. Other code `use`s it. This is
exactly how `testing` works, and how you'll ship the CA engine:

```fortran
module ca_engine
   use, intrinsic :: iso_fortran_env, only: wp => real64
   implicit none
   private                      ! hide everything by default
   public :: step, density      ! export only these
contains
   ... procedures ...
end module
```

`private` + explicit `public` is good hygiene: the module's internals stay
internal.

## Your task

Fill in `exercise.f90` (module `m4`):

1. `square(x)` — a `pure` function returning x*x (real64).
2. `swap(a, b)` — a subroutine that swaps two real64 scalars (both `intent(inout)`).
3. `cumsum(x)` — function returning the running cumulative sum of a real64 array:
   `cumsum([1,2,3]) == [1,3,6]`.
4. `scale_inplace(v, factor)` — subroutine multiplying every element of v by
   factor in place (`v` is `intent(inout)`).
5. `poly_eval(coeffs, x)` — evaluate a polynomial at x using Horner's method.
   `coeffs(1)` is the constant term. `poly_eval([2,0,3], x) = 2 + 0*x + 3*x^2`.
   (Horner: start from the highest coefficient and fold down.)

```
make m4
```
