!> Module 4 exercise. Fill in the TODOs. Keep the module name `m4`.
module m4
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: square, swap, cumsum, scale_inplace, poly_eval

contains

   !> pure function: x*x.
   pure real(real64) function square(x)
      real(real64), intent(in) :: x
      ! TODO
      square = 0.0_real64
   end function square

   !> Swap two scalars in place.
   subroutine swap(a, b)
      real(real64), intent(inout) :: a, b
      real(real64) :: tmp
      ! TODO: classic three-line swap via tmp
   end subroutine swap

   !> Running cumulative sum. cumsum([1,2,3]) == [1,3,6].
   function cumsum(x) result(c)
      real(real64), intent(in) :: x(:)
      real(real64) :: c(size(x))
      integer :: i
      ! TODO: c(1)=x(1); c(i)=c(i-1)+x(i)
      c = 0.0_real64
   end function cumsum

   !> Multiply every element of v by factor, in place.
   subroutine scale_inplace(v, factor)
      real(real64), intent(inout) :: v(:)
      real(real64), intent(in) :: factor
      ! TODO
   end subroutine scale_inplace

   !> Horner's method. coeffs(1) is the constant term.
   !! poly_eval([2,0,3], x) = 2 + 3*x^2.
   real(real64) function poly_eval(coeffs, x)
      real(real64), intent(in) :: coeffs(:)
      real(real64), intent(in) :: x
      integer :: i
      ! TODO: start acc at the highest coeff, then acc = acc*x + coeffs(i)
      !       walking down to coeffs(1)
      poly_eval = 0.0_real64
   end function poly_eval

end module m4
