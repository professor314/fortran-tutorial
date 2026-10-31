!> Module 6 reference solution.
module m6
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: grid_rows, grid_cols, shift2d, neighbor_counts, total_live, density

contains

   integer function grid_rows(g)
      integer, intent(in) :: g(:,:)
      grid_rows = size(g, 1)
   end function grid_rows

   integer function grid_cols(g)
      integer, intent(in) :: g(:,:)
      grid_cols = size(g, 2)
   end function grid_cols

   function shift2d(g, dr, dc) result(s)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: dr, dc
      integer :: s(size(g,1), size(g,2))
      s = cshift(cshift(g, dr, dim=1), dc, dim=2)
   end function shift2d

   function neighbor_counts(g) result(counts)
      integer, intent(in) :: g(:,:)
      integer :: counts(size(g,1), size(g,2))
      integer :: dr, dc
      counts = 0
      do dr = -1, 1
         do dc = -1, 1
            if (dr == 0 .and. dc == 0) cycle
            counts = counts + shift2d(g, dr, dc)
         end do
      end do
   end function neighbor_counts

   integer function total_live(g)
      integer, intent(in) :: g(:,:)
      total_live = sum(g)
   end function total_live

   real(real64) function density(g)
      integer, intent(in) :: g(:,:)
      density = real(total_live(g), real64) / real(size(g), real64)
   end function density

end module m6
