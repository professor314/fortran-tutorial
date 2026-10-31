!> Module 3 exercise. Fill in the TODOs. Keep the module name `m3`.
module m3
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: arange, vec_mean, vec_norm, count_above, clamp01, neighbor_sum

contains

   !> Return the integer array [1, 2, ..., n].
   function arange(n) result(a)
      integer, intent(in) :: n
      integer :: a(n)
      ! TODO: fill a with 1..n (an implied-do or a loop both work)
      a = 0
   end function arange

   !> Mean of a real64 array.
   real(real64) function vec_mean(x)
      real(real64), intent(in) :: x(:)
      ! TODO: sum(x) / size(x)   (watch integer division: size is integer)
      vec_mean = 0.0_real64
   end function vec_mean

   !> Euclidean norm: sqrt(sum of squares). Use dot_product.
   real(real64) function vec_norm(x)
      real(real64), intent(in) :: x(:)
      ! TODO
      vec_norm = 0.0_real64
   end function vec_norm

   !> Count elements of x strictly greater than threshold.
   integer function count_above(x, threshold)
      real(real64), intent(in) :: x(:)
      real(real64), intent(in) :: threshold
      ! TODO: use the count intrinsic
      count_above = 0
   end function count_above

   !> Return a copy of x clamped to [0,1] using a where-construct.
   function clamp01(x) result(y)
      real(real64), intent(in) :: x(:)
      real(real64) :: y(size(x))
      ! TODO: y = x, then where (y<0) y=0 ; where (y>1) y=1
      y = x
   end function clamp01

   !> For each position, sum of left and right neighbor WITH wraparound.
   !! Use cshift. a is an integer array.
   function neighbor_sum(a) result(s)
      integer, intent(in) :: a(:)
      integer :: s(size(a))
      ! TODO: s = cshift(a, -1) + cshift(a, 1)
      s = 0
   end function neighbor_sum

end module m3
