!> Module 1 checker. Do not edit. Links against your m1 module and verifies
!! each function. Run with `make m1`.
program check
   use testing
   use m1
   implicit none
   real(wp) :: pi

   call section('Module 1: variables, types, kinds')

   call assert_equal_int('answer() returns 42', answer(), 42)

   ! third_double is accurate; third_single has lost precision, so it should
   ! NOT match 1/3 to double tolerance (that is the teaching point).
   call assert_close('third_double() is 1/3', third_double(), &
        1.0_wp/3.0_wp, 1.0e-15_wp)
   call assert_true('third_single() lost precision vs third_double()', &
        abs(third_single() - third_double()) > 1.0e-9_wp)

   call assert_close('safe_divide(7,2) == 3.5', safe_divide(7, 2), 3.5_wp)
   call assert_close('safe_divide(1,4) == 0.25', safe_divide(1, 4), 0.25_wp)

   pi = 4.0_wp * atan(1.0_wp)
   call assert_close('circle_area(2) == 4*pi', circle_area(2.0_wp), &
        4.0_wp*pi, 1.0e-12_wp)

   call report()
end program check
