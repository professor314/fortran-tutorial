!> Module 5 checker. Do not edit.
program check
   use testing
   use m5
   implicit none
   integer :: row(7), nxt(7)
   integer, allocatable :: hist(:,:)

   call section('Module 5: elementary cellular automata')

   call assert_equal_int('nbhd_index(1,0,1) == 5', &
        neighborhood_index(1,0,1), 5)
   call assert_equal_int('nbhd_index(1,1,1) == 7', &
        neighborhood_index(1,1,1), 7)

   ! Rule 90 = 01011010b. bit at p: p0=0,p1=1,p2=0,p3=1,p4=1,p5=0,p6=1,p7=0
   call assert_equal_int('rule90 on 000 -> 0', apply_rule(90,0,0,0), 0)
   call assert_equal_int('rule90 on 001 -> 1', apply_rule(90,0,0,1), 1)
   call assert_equal_int('rule90 on 100 -> 1', apply_rule(90,1,0,0), 1)
   call assert_equal_int('rule90 on 101 -> 0', apply_rule(90,1,0,1), 0)
   ! Rule 90 is left XOR right, independent of center:
   call assert_equal_int('rule90 on 111 -> 0', apply_rule(90,1,1,1), 0)
   call assert_equal_int('rule90 on 010 -> 0', apply_rule(90,0,1,0), 0)

   ! Single live cell, Rule 90, width 7: [0001000] -> [0010100]
   row = [0,0,0,1,0,0,0]
   nxt = step_row(90, row)
   call assert_equal_int_array('rule90 one step', nxt, [0,0,1,0,1,0,0])

   ! Rule 30 one step on single cell: [0001000] -> [0011100]
   nxt = step_row(30, row)
   call assert_equal_int_array('rule30 one step', nxt, [0,0,1,1,1,0,0])

   ! evolve: history has ngen+1 rows, row 1 is init
   hist = evolve(90, row, 3)
   call assert_equal_int('evolve returns 4 rows', size(hist,1), 4)
   call assert_equal_int_array('evolve row1 == init', hist(1,:), row)
   call assert_equal_int_array('evolve row2 == one step', hist(2,:), &
        [0,0,1,0,1,0,0])

   call assert_equal_int('live_count([0001000]) == 1', live_count(row), 1)
   call assert_equal_int('live_count of rule30 step == 3', live_count(nxt), 3)

   call report()
end program check
