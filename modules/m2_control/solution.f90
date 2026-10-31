!> Module 2 reference solution.
module m2
   use, intrinsic :: iso_fortran_env, only: real64, int64
   implicit none
   private
   public :: factorial, leibniz_pi, collatz_steps, is_prime, count_primes_below

contains

   integer(int64) function factorial(n)
      integer, intent(in) :: n
      integer :: i
      factorial = 1_int64
      do i = 1, n
         factorial = factorial * int(i, int64)
      end do
   end function factorial

   real(real64) function leibniz_pi(nterms)
      integer, intent(in) :: nterms
      integer :: k
      real(real64) :: total, sign
      total = 0.0_real64
      sign  = 1.0_real64
      do k = 0, nterms - 1
         total = total + sign / real(2*k + 1, real64)
         sign  = -sign
      end do
      leibniz_pi = 4.0_real64 * total
   end function leibniz_pi

   integer function collatz_steps(n)
      integer, intent(in) :: n
      integer :: m
      m = n
      collatz_steps = 0
      do while (m /= 1)
         if (mod(m, 2) == 0) then
            m = m / 2
         else
            m = 3*m + 1
         end if
         collatz_steps = collatz_steps + 1
      end do
   end function collatz_steps

   logical function is_prime(n)
      integer, intent(in) :: n
      integer :: d
      if (n < 2) then
         is_prime = .false.
         return
      end if
      is_prime = .true.
      do d = 2, int(sqrt(real(n, real64)))
         if (mod(n, d) == 0) then
            is_prime = .false.
            return
         end if
      end do
   end function is_prime

   integer function count_primes_below(limit)
      integer, intent(in) :: limit
      integer :: k
      count_primes_below = 0
      do k = 2, limit - 1
         if (is_prime(k)) count_primes_below = count_primes_below + 1
      end do
   end function count_primes_below

end module m2
