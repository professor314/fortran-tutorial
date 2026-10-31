!> Module 3 checker. Do not edit.
program check
   use testing
   use m3
   implicit none
   real(wp) :: x(5)

   call section('Module 3: arrays')

   call assert_equal_int_array('arange(5) == [1..5]', arange(5), [1,2,3,4,5])

   x = [1.0_wp, 2.0_wp, 3.0_wp, 4.0_wp, 5.0_wp]
   call assert_close('vec_mean == 3.0', vec_mean(x), 3.0_wp)
   call assert_close('vec_norm([3,4]) == 5', vec_norm([3.0_wp,4.0_wp]), 5.0_wp)
   call assert_equal_int('count_above(x,2.5) == 3', count_above(x, 2.5_wp), 3)

   block
      real(wp) :: c(4)
      c = clamp01([-0.5_wp, 0.25_wp, 0.75_wp, 2.0_wp])
      call assert_close('clamp01 low -> 0', c(1), 0.0_wp)
      call assert_close('clamp01 mid unchanged', c(2), 0.25_wp)
      call assert_close('clamp01 high -> 1', c(4), 1.0_wp)
   end block

   call assert_equal_int_array('neighbor_sum([1,0,0,0]) wraps', &
        neighbor_sum([1,0,0,0]), [0,1,0,1])
   call assert_equal_int_array('neighbor_sum([1,1,1]) all 2', &
        neighbor_sum([1,1,1]), [2,2,2])

   call report()
end program check
