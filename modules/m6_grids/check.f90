!> Module 6 checker. Do not edit.
program check
   use testing
   use m6
   implicit none
   integer :: g(3,3), nc(3,3)
   integer :: blinker(5,5)

   call section('Module 6: 2D grids and neighbor counting')

   g = 0
   g(2,2) = 1       ! single live cell in the center of a 3x3 torus

   call assert_equal_int('grid_rows == 3', grid_rows(g), 3)
   call assert_equal_int('grid_cols == 3', grid_cols(g), 3)

   ! shift the live cell down one row (dim 1, +1 moves toward... verify by content)
   block
      integer :: s(3,3)
      s = shift2d(g, 1, 0)
      call assert_equal_int('shift2d keeps one live cell', sum(s), 1)
      call assert_equal_int('shift2d is not identity', &
           merge(1, 0, s(2,2) == 0), 1)
   end block

   nc = neighbor_counts(g)
   ! center cell has 0 live neighbors; each of the 8 others sees the center once
   call assert_equal_int('center neighbor count == 0', nc(2,2), 0)
   call assert_equal_int('corner neighbor count == 1', nc(1,1), 1)
   call assert_equal_int('edge neighbor count == 1', nc(1,2), 1)
   call assert_equal_int('sum of all counts == 8', sum(nc), 8)

   call assert_equal_int('total_live == 1', total_live(g), 1)
   call assert_close('density(3x3, one live) == 1/9', density(g), &
        1.0_wp/9.0_wp, 1.0e-12_wp)

   ! A full grid: every cell has 8 neighbors on a torus
   block
      integer :: full(4,4), fc(4,4)
      full = 1
      fc = neighbor_counts(full)
      call assert_true('full grid: every count is 8', all(fc == 8))
      call assert_close('full grid density == 1', density(full), 1.0_wp)
   end block

   ! Blinker setup (used next module) just to exercise counts on a bigger grid
   blinker = 0
   blinker(3,2:4) = 1
   call assert_equal_int('blinker has 3 live', total_live(blinker), 3)

   call report()
end program check
