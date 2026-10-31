!> Module 3 reference solution.
module m3
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: arange, vec_mean, vec_norm, count_above, clamp01, neighbor_sum

contains

   function arange(n) result(a)
      integer, intent(in) :: n
      integer :: a(n)
      integer :: i
      a = [(i, i = 1, n)]
   end function arange

   real(real64) function vec_mean(x)
      real(real64), intent(in) :: x(:)
      vec_mean = sum(x) / real(size(x), real64)
   end function vec_mean

   real(real64) function vec_norm(x)
      real(real64), intent(in) :: x(:)
      vec_norm = sqrt(dot_product(x, x))
   end function vec_norm

   integer function count_above(x, threshold)
      real(real64), intent(in) :: x(:)
      real(real64), intent(in) :: threshold
      count_above = count(x > threshold)
   end function count_above

   function clamp01(x) result(y)
      real(real64), intent(in) :: x(:)
      real(real64) :: y(size(x))
      y = x
      where (y < 0.0_real64) y = 0.0_real64
      where (y > 1.0_real64) y = 1.0_real64
   end function clamp01

   function neighbor_sum(a) result(s)
      integer, intent(in) :: a(:)
      integer :: s(size(a))
      s = cshift(a, -1) + cshift(a, 1)
   end function neighbor_sum

end module m3
