!> Module 1 exercise. Fill in each function body where it says TODO.
!! Keep the module name `m1` and the function signatures exactly as given;
!! the checker depends on them.
module m1
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: answer, third_single, third_double, safe_divide, circle_area

contains

   !> Return the integer 42.
   integer function answer()
      ! TODO: return 42
      answer = 0
   end function answer

   !> Compute 1/3 in SINGLE precision, then widen the result to real64.
   !! This shows how much precision you lose by not tagging your literals.
   real(real64) function third_single()
      real :: s
      ! TODO: set s = 1.0 / 3.0 (single precision), then return real(s, real64)
      s = 0.0
      third_single = real(s, real64)
   end function third_single

   !> Compute 1/3 properly in real64 (tag the literals with _real64).
   real(real64) function third_double()
      ! TODO: return 1.0_real64 / 3.0_real64
      third_double = 0.0_real64
   end function third_double

   !> Divide integer a by integer b but return a real64 result.
   !! safe_divide(7, 2) must be 3.5, not 3.0.
   real(real64) function safe_divide(a, b)
      integer, intent(in) :: a, b
      ! TODO: convert before dividing so you don't get integer division
      safe_divide = 0.0_real64
   end function safe_divide

   !> Area of a circle of radius r, in real64. Use 4*atan(1) for pi.
   real(real64) function circle_area(r)
      real(real64), intent(in) :: r
      ! TODO: pi = 4 * atan(1.0_real64); area = pi * r**2
      circle_area = 0.0_real64
   end function circle_area

end module m1
