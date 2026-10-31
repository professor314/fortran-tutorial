!> Module 4 reference solution.
module m4
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: square, swap, cumsum, scale_inplace, poly_eval

contains

   pure real(real64) function square(x)
      real(real64), intent(in) :: x
      square = x * x
   end function square

   subroutine swap(a, b)
      real(real64), intent(inout) :: a, b
      real(real64) :: tmp
      tmp = a
      a = b
      b = tmp
   end subroutine swap

   function cumsum(x) result(c)
      real(real64), intent(in) :: x(:)
      real(real64) :: c(size(x))
      integer :: i
      if (size(x) == 0) return
      c(1) = x(1)
      do i = 2, size(x)
         c(i) = c(i-1) + x(i)
      end do
   end function cumsum

   subroutine scale_inplace(v, factor)
      real(real64), intent(inout) :: v(:)
      real(real64), intent(in) :: factor
      v = v * factor
   end subroutine scale_inplace

   real(real64) function poly_eval(coeffs, x)
      real(real64), intent(in) :: coeffs(:)
      real(real64), intent(in) :: x
      integer :: i
      poly_eval = 0.0_real64
      do i = size(coeffs), 1, -1
         poly_eval = poly_eval * x + coeffs(i)
      end do
   end function poly_eval

end module m4
