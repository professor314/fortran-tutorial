!> Module 2 checker. Do not edit.
program check
   use testing
   use m2
   use, intrinsic :: iso_fortran_env, only: int64
   implicit none
   real(wp) :: pi

   pi = 4.0_wp * atan(1.0_wp)
   call section('Module 2: control flow and loops')

   call assert_true('factorial(0) == 1', factorial(0) == 1_int64)
   call assert_true('factorial(5) == 120', factorial(5) == 120_int64)
   call assert_true('factorial(13) == 6227020800', &
        factorial(13) == 6227020800_int64)

   call assert_close('leibniz_pi(10000) near pi', leibniz_pi(10000), pi, 1.0e-3_wp)
   call assert_true('leibniz_pi is slow (100 terms off by >1e-3)', &
        abs(leibniz_pi(100) - pi) > 1.0e-3_wp)

   call assert_equal_int('collatz_steps(1) == 0', collatz_steps(1), 0)
   call assert_equal_int('collatz_steps(6) == 8', collatz_steps(6), 8)
   call assert_equal_int('collatz_steps(27) == 111', collatz_steps(27), 111)

   call assert_true('is_prime(2)', is_prime(2))
   call assert_true('is_prime(97)', is_prime(97))
   call assert_true('not is_prime(1)', .not. is_prime(1))
   call assert_true('not is_prime(91=7*13)', .not. is_prime(91))

   call assert_equal_int('count_primes_below(10) == 4', count_primes_below(10), 4)
   call assert_equal_int('count_primes_below(100) == 25', &
        count_primes_below(100), 25)

   call report()
end program check
