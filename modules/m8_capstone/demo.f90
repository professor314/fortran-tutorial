!> Module 8 capstone demo: run several Life-like rules from the SAME random
!! seed and print how their density and entropy evolve. This is a miniature
!! version of classifying cellular automata by their dynamics.
!!   gfortran ../../src/testing.f90 ../m6_grids/solution.f90 solution.f90 demo.f90 -o demo && ./demo
program demo
   use, intrinsic :: iso_fortran_env, only: real64, int64
   use m8
   implicit none
   integer, parameter :: n = 40, ngen = 30
   integer :: seed(n, n)

   call random_soup(seed, 0.35_real64)

   call run('Conway Life  B3/S23 ', [3],       [2,3])
   call run('HighLife     B36/S23', [3,6],     [2,3])
   call run('Seeds        B2/S    ', [2],       [integer ::])
   call run('Replicator   B1357   ', [1,3,5,7], [1,3,5,7])

contains

   subroutine run(name, birth, survive)
      character(len=*), intent(in) :: name
      integer, intent(in) :: birth(:), survive(:)
      real(real64) :: d(ngen+1), h(ngen+1)
      integer :: k
      d = density_series(seed, birth, survive, ngen)
      h = entropy_series(seed, birth, survive, ngen)
      print '(A)', ''
      print '(A)', '==== ' // name // ' ===='
      print '(A)', ' gen   density   entropy(bits)   bar'
      do k = 1, ngen + 1, 3
         print '(I4,3X,F7.4,3X,F10.4,5X,A)', k-1, d(k), h(k), &
            repeat('#', nint(d(k) * 50.0_real64))
      end do
   end subroutine run

   !> Fill a grid with live cells at the given probability, using a seeded LCG
   !! so the comparison across rules uses the identical starting configuration.
   subroutine random_soup(g, p)
      integer, intent(out) :: g(:,:)
      real(real64), intent(in) :: p
      integer(int64) :: state
      real(real64) :: u
      integer :: r, c
      state = 1234567_int64
      do c = 1, size(g, 2)
         do r = 1, size(g, 1)
            state = 6364136223846793005_int64 * state + 1442695040888963407_int64
            u = real(ishft(state, -33), real64) / 2147483648.0_real64
            if (u < p) then
               g(r,c) = 1
            else
               g(r,c) = 0
            end if
         end do
      end do
   end subroutine random_soup

end program demo
