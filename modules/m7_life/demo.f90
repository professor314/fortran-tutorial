!> Module 7 demo: load the glider from glider.txt and watch it fly.
!!   gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo
program demo
   use m7
   implicit none
   integer, allocatable :: g(:,:)
   logical :: ok
   integer :: step

   call load_grid('glider.txt', g, ok)
   if (.not. ok) then
      print '(A)', 'Could not load glider.txt (run from the m7_life folder).'
      stop 1
   end if

   do step = 0, 16
      print '(A,I0)', 'Generation ', step
      call render(g)
      print '(A)', ''
      g = life_step(g)
   end do

contains

   subroutine render(grid)
      integer, intent(in) :: grid(:,:)
      integer :: r, c
      character(len=size(grid,2)) :: line
      do r = 1, size(grid, 1)
         do c = 1, size(grid, 2)
            if (grid(r,c) == 1) then
               line(c:c) = '#'
            else
               line(c:c) = '.'
            end if
         end do
         print '(A)', line
      end do
   end subroutine render

end program demo
