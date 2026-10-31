!> Module 4 checker. Do not edit.
program check
   use testing
   use m4
   implicit none
   real(wp) :: a, b, v(3), c(3)

   call section('Module 4: procedures and modules')

   call assert_close('square(4) == 16', square(4.0_wp), 16.0_wp)

   a = 1.0_wp; b = 2.0_wp
   call swap(a, b)
   call assert_close('swap: a now 2', a, 2.0_wp)
   call assert_close('swap: b now 1', b, 1.0_wp)

   c = cumsum([1.0_wp, 2.0_wp, 3.0_wp])
   call assert_close('cumsum last == 6', c(3), 6.0_wp)
   call assert_close('cumsum mid == 3', c(2), 3.0_wp)

   v = [1.0_wp, 2.0_wp, 3.0_wp]
   call scale_inplace(v, 10.0_wp)
   call assert_close('scale_inplace v(3) == 30', v(3), 30.0_wp)

   ! 2 + 3*x^2 at x=2 -> 2 + 12 = 14
   call assert_close('poly_eval([2,0,3],2) == 14', &
        poly_eval([2.0_wp,0.0_wp,3.0_wp], 2.0_wp), 14.0_wp)
   ! 1 + 2x + 3x^2 at x=1 -> 6
   call assert_close('poly_eval([1,2,3],1) == 6', &
        poly_eval([1.0_wp,2.0_wp,3.0_wp], 1.0_wp), 6.0_wp)

   call report()
end program check
