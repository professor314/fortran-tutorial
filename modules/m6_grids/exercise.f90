!> Module 6 exercise. Fill in the TODOs. Keep the module name `m6`.
!! 2D toroidal grids and 8-neighbor counting.
module m6
   use, intrinsic :: iso_fortran_env, only: real64
   implicit none
   private
   public :: grid_rows, grid_cols, shift2d, neighbor_counts, total_live, density

contains

   integer function grid_rows(g)
      integer, intent(in) :: g(:,:)
      ! TODO: size(g, 1)
      grid_rows = 0
   end function grid_rows

   integer function grid_cols(g)
      integer, intent(in) :: g(:,:)
      ! TODO: size(g, 2)
      grid_cols = 0
   end function grid_cols

   !> Shift the grid by dr rows and dc columns, wrapping (toroidal).
   function shift2d(g, dr, dc) result(s)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: dr, dc
      integer :: s(size(g,1), size(g,2))
      ! TODO: cshift(cshift(g, dr, dim=1), dc, dim=2)
      s = 0
   end function shift2d

   !> For each cell, the sum of its 8 toroidal neighbors.
   function neighbor_counts(g) result(counts)
      integer, intent(in) :: g(:,:)
      integer :: counts(size(g,1), size(g,2))
      integer :: dr, dc
      counts = 0
      ! TODO: loop dr=-1..1, dc=-1..1; skip (0,0); counts = counts + shift2d(g,dr,dc)
   end function neighbor_counts

   integer function total_live(g)
      integer, intent(in) :: g(:,:)
      ! TODO: sum(g)
      total_live = 0
   end function total_live

   !> Fraction of cells that are live, as real64.
   real(real64) function density(g)
      integer, intent(in) :: g(:,:)
      ! TODO: real(total_live) / real(number of cells)
      density = 0.0_real64
   end function density

end module m6
