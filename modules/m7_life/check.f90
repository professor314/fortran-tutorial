!> Module 7 checker. Do not edit.
program check
   use testing
   use m7
   implicit none
   integer :: block4(4,4), blinker(5,5), after(5,5)

   call section('Module 7: Conway''s Game of Life')

   call assert_equal_int('parse_char(#) == 1', parse_char('#'), 1)
   call assert_equal_int('parse_char(1) == 1', parse_char('1'), 1)
   call assert_equal_int('parse_char(.) == 0', parse_char('.'), 0)

   ! Block (2x2) is a still life
   block4 = 0
   block4(2:3, 2:3) = 1
   call assert_true('2x2 block is still life', is_still_life(block4))
   call assert_equal_int('block period == 1', period_of(block4, 10), 1)

   ! Blinker: horizontal 3 -> vertical 3
   blinker = 0
   blinker(3, 2:4) = 1
   after = life_step(blinker)
   call assert_equal_int('blinker conserves 3 cells', sum(after), 3)
   call assert_true('blinker becomes vertical', &
        after(2,3) == 1 .and. after(3,3) == 1 .and. after(4,3) == 1)
   call assert_true('blinker horizontal cells died', &
        after(3,2) == 0 .and. after(3,4) == 0)
   call assert_equal_int('blinker period == 2', period_of(blinker, 10), 2)

   ! Two steps returns the blinker to its start
   call assert_true('blinker returns after 2 steps', &
        all(life_step(life_step(blinker)) == blinker))

   call report()
end program check
