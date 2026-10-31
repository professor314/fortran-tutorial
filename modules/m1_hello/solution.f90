!> Module 1 reference solution. (Try the exercise before reading this.)
module m1
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: answer, third_single, third_double, safe_divide, circle_area

contains

   integer function answer()
      answer = 42
   end function answer

   real(real64) function third_single()
      real :: s
      s = 1.0 / 3.0                 ! single precision division
      third_single = real(s, real64)
   end function third_single

   real(real64) function third_double()
      third_double = 1.0_real64 / 3.0_real64
   end function third_double

   real(real64) function safe_divide(a, b)
      integer, intent(in) :: a, b
      safe_divide = real(a, real64) / real(b, real64)
   end function safe_divide

   real(real64) function circle_area(r)
      real(real64), intent(in) :: r
      real(real64) :: pi
      pi = 4.0_real64 * atan(1.0_real64)
      circle_area = pi * r**2
   end function circle_area

end module m1
