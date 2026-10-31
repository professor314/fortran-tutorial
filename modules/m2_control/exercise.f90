!> Module 2 exercise. Fill in the TODOs. Keep the module name `m2`.
module m2
   use, intrinsic :: iso_fortran_env, only: real64, int64
   implicit none
   private
   public :: factorial, leibniz_pi, collatz_steps, is_prime, count_primes_below

contains

   !> n! as a 64-bit integer. factorial(0) = 1.
   integer(int64) function factorial(n)
      integer, intent(in) :: n
      ! TODO: loop from 1 to n multiplying into an accumulator (start at 1)
      factorial = 0_int64
   end function factorial

   !> Estimate pi via the Leibniz series to `nterms` terms.
   real(real64) function leibniz_pi(nterms)
      integer, intent(in) :: nterms
      ! TODO: total = sum of (-1)^k / (2k+1) for k=0..nterms-1; return 4*total
      leibniz_pi = 0.0_real64
   end function leibniz_pi

   !> Number of Collatz steps to reach 1. collatz_steps(1) = 0.
   integer function collatz_steps(n)
      integer, intent(in) :: n
      integer :: m
      m = n
      collatz_steps = 0
      ! TODO: while m /= 1, step (even: m/2, odd: 3m+1) and count
   end function collatz_steps

   !> Is n prime? n < 2 is not prime.
   logical function is_prime(n)
      integer, intent(in) :: n
      ! TODO: trial division by 2..sqrt(n)
      is_prime = .false.
   end function is_prime

   !> Count primes strictly less than `limit`.
   integer function count_primes_below(limit)
      integer, intent(in) :: limit
      ! TODO: loop and tally is_prime
      count_primes_below = 0
   end function count_primes_below

end module m2
