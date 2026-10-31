!> Module 8 capstone checker. Do not edit.
program check
   use testing
   use m8
   implicit none
   integer :: blinker(5,5), block4(4,4), step1(5,5)
   real(wp) :: d(6), h(6)

   call section('Module 8: generalized CA engine + complexity measures')

   call assert_true('in_set([2,3], 3)', in_set([2,3], 3))
   call assert_true('not in_set([2,3], 4)', .not. in_set([2,3], 4))

   ! general_step with B3/S23 must reproduce Conway's Life on a blinker
   blinker = 0
   blinker(3, 2:4) = 1
   step1 = general_step(blinker, [3], [2,3])
   call assert_equal_int('Life B3/S23: blinker keeps 3 cells', sum(step1), 3)
   call assert_true('Life B3/S23: blinker goes vertical', &
        step1(2,3) == 1 .and. step1(3,3) == 1 .and. step1(4,3) == 1)

   ! Block is still life under B3/S23
   block4 = 0
   block4(2:3, 2:3) = 1
   call assert_true('Life B3/S23: block is still life', &
        all(general_step(block4, [3], [2,3]) == block4))

   ! Seeds B2/S: every live cell dies (survive set empty)
   call assert_equal_int('Seeds B2/S: block all die next step', &
        sum(general_step(block4, [2], [integer ::])), &
        count(neighbor_counts_is_two(block4)))

   ! binary entropy: 0 at p=0 and p=1, exactly 1 at p=0.5
   call assert_close('entropy(0) == 0', binary_entropy(0.0_wp), 0.0_wp)
   call assert_close('entropy(1) == 0', binary_entropy(1.0_wp), 0.0_wp)
   call assert_close('entropy(0.5) == 1 bit', binary_entropy(0.5_wp), 1.0_wp)
   call assert_true('entropy(0.5) is the max', &
        binary_entropy(0.5_wp) >= binary_entropy(0.1_wp))

   ! density series: blinker density is constant 3/25 (period-2, cells conserved)
   d = density_series(blinker, [3], [2,3], 5)
   call assert_close('density gen0 == 3/25', d(1), 3.0_wp/25.0_wp)
   call assert_close('density gen1 == 3/25', d(2), 3.0_wp/25.0_wp)
   call assert_equal_int('density series length == 6', size(d), 6)

   ! entropy series matches entropy of densities
   h = entropy_series(blinker, [3], [2,3], 5)
   call assert_close('entropy matches binary_entropy(density)', &
        h(1), binary_entropy(d(1)))

   call report()

contains

   !> Helper for the Seeds check: which cells have exactly 2 neighbors.
   !! (A dead cell with 2 neighbors is born under B2; live cells all die.)
   function neighbor_counts_is_two(g) result(mask)
      use m6, only: neighbor_counts
      integer, intent(in) :: g(:,:)
      logical :: mask(size(g,1), size(g,2))
      integer :: n(size(g,1), size(g,2))
      n = neighbor_counts(g)
      ! Born where dead AND n==2; block interior cells are alive so excluded
      mask = (g == 0) .and. (n == 2)
   end function neighbor_counts_is_two

end program check
