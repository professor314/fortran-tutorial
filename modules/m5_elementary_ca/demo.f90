!> Module 5 demo: watch elementary CAs grow. Run after your exercise passes:
!!   gfortran ../../src/testing.f90 solution.f90 demo.f90 -o demo && ./demo
!! (or link exercise.f90 instead of solution.f90 to see YOUR code draw it)
program demo
   use m5
   implicit none
   integer, parameter :: w = 79, gens = 39
   integer :: init(w)
   integer, allocatable :: hist(:,:)

   init = 0
   init((w+1)/2) = 1          ! single live cell in the middle

   call show(30,  'Rule 30  (chaos / randomness)')
   call show(90,  'Rule 90  (Sierpinski triangle)')
   call show(110, 'Rule 110 (Turing complete)')

contains

   subroutine show(rule, title)
      integer, intent(in) :: rule
      character(len=*), intent(in) :: title
      integer :: g, i
      character(len=w) :: line
      print '(A)', ''
      print '(A)', '==== ' // title // ' ===='
      hist = evolve(rule, init, gens)
      do g = 1, gens + 1
         do i = 1, w
            if (hist(g,i) == 1) then
               line(i:i) = '#'
            else
               line(i:i) = ' '
            end if
         end do
         print '(A)', line
      end do
   end subroutine show

end program demo
