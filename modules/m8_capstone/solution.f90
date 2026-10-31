!> Module 8 capstone reference solution.
module m8
   use, intrinsic :: iso_fortran_env, only: real64
   use m6, only: neighbor_counts
   implicit none
   private
   public :: in_set, general_step, binary_entropy, density_series, entropy_series

contains

   pure logical function in_set(set, n)
      integer, intent(in) :: set(:)
      integer, intent(in) :: n
      in_set = any(set == n)
   end function in_set

   function general_step(g, birth, survive) result(next)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer :: next(size(g,1), size(g,2))
      integer :: n(size(g,1), size(g,2))
      integer :: r, c
      n = neighbor_counts(g)
      next = 0
      do c = 1, size(g, 2)
         do r = 1, size(g, 1)
            if (g(r,c) == 0) then
               if (in_set(birth, n(r,c)))   next(r,c) = 1
            else
               if (in_set(survive, n(r,c))) next(r,c) = 1
            end if
         end do
      end do
   end function general_step

   pure real(real64) function binary_entropy(p)
      real(real64), intent(in) :: p
      real(real64) :: q
      if (p <= 0.0_real64 .or. p >= 1.0_real64) then
         binary_entropy = 0.0_real64
         return
      end if
      q = 1.0_real64 - p
      binary_entropy = -(p*log(p) + q*log(q)) / log(2.0_real64)
   end function binary_entropy

   function density_series(g, birth, survive, ngen) result(d)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer, intent(in) :: ngen
      real(real64) :: d(ngen+1)
      integer :: cur(size(g,1), size(g,2))
      integer :: k
      cur = g
      d(1) = real(sum(cur), real64) / real(size(cur), real64)
      do k = 1, ngen
         cur = general_step(cur, birth, survive)
         d(k+1) = real(sum(cur), real64) / real(size(cur), real64)
      end do
   end function density_series

   function entropy_series(g, birth, survive, ngen) result(h)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer, intent(in) :: ngen
      real(real64) :: h(ngen+1)
      real(real64) :: d(ngen+1)
      integer :: k
      d = density_series(g, birth, survive, ngen)
      do k = 1, ngen + 1
         h(k) = binary_entropy(d(k))
      end do
   end function entropy_series

end module m8
