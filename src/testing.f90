!> testing — a tiny assertion harness shared by every module's checker.
!!
!! You never need to edit this file. Each module's check.f90 calls these
!! routines to verify the functions you wrote in exercise.f90. At the end,
!! call report() to print a summary and stop with a nonzero exit code if
!! anything failed (so `make` knows the difference between pass and fail).
module testing
   use, intrinsic :: iso_fortran_env, only: wp => real64, int64
   implicit none
   private

   public :: wp, assert_true, assert_equal_int, assert_close, &
             assert_equal_int_array, report, section

   integer :: n_pass = 0
   integer :: n_fail = 0

contains

   !> Print a section header so checker output is readable.
   subroutine section(title)
      character(len=*), intent(in) :: title
      print '(A)', ''
      print '(A)', '== ' // trim(title) // ' =='
   end subroutine section

   subroutine pass(label)
      character(len=*), intent(in) :: label
      n_pass = n_pass + 1
      print '(A,A)', '  PASS  ', trim(label)
   end subroutine pass

   subroutine fail(label, detail)
      character(len=*), intent(in) :: label
      character(len=*), intent(in), optional :: detail
      n_fail = n_fail + 1
      if (present(detail)) then
         print '(A,A,A,A)', '  FAIL  ', trim(label), '  --  ', trim(detail)
      else
         print '(A,A)', '  FAIL  ', trim(label)
      end if
   end subroutine fail

   !> Assert a logical condition is true.
   subroutine assert_true(label, cond)
      character(len=*), intent(in) :: label
      logical, intent(in) :: cond
      if (cond) then
         call pass(label)
      else
         call fail(label, 'expected .true.')
      end if
   end subroutine assert_true

   !> Assert two integers are equal.
   subroutine assert_equal_int(label, got, want)
      character(len=*), intent(in) :: label
      integer, intent(in) :: got, want
      character(len=64) :: detail
      if (got == want) then
         call pass(label)
      else
         write (detail, '(A,I0,A,I0)') 'got ', got, ', want ', want
         call fail(label, detail)
      end if
   end subroutine assert_equal_int

   !> Assert two reals are equal within a tolerance.
   subroutine assert_close(label, got, want, tol)
      character(len=*), intent(in) :: label
      real(wp), intent(in) :: got, want
      real(wp), intent(in), optional :: tol
      real(wp) :: t
      character(len=96) :: detail
      t = 1.0e-9_wp
      if (present(tol)) t = tol
      if (abs(got - want) <= t) then
         call pass(label)
      else
         write (detail, '(A,ES14.6,A,ES14.6)') 'got ', got, ', want ', want
         call fail(label, detail)
      end if
   end subroutine assert_close

   !> Assert two integer arrays are elementwise equal.
   subroutine assert_equal_int_array(label, got, want)
      character(len=*), intent(in) :: label
      integer, intent(in) :: got(:), want(:)
      character(len=64) :: detail
      if (size(got) /= size(want)) then
         write (detail, '(A,I0,A,I0)') 'size ', size(got), ' /= ', size(want)
         call fail(label, detail)
      else if (all(got == want)) then
         call pass(label)
      else
         write (detail, '(A,I0,A)') 'arrays differ (', &
            count(got /= want), ' element(s))'
         call fail(label, detail)
      end if
   end subroutine assert_equal_int_array

   !> Print the final tally and stop nonzero if anything failed.
   subroutine report()
      print '(A)', ''
      if (n_fail == 0) then
         print '(A,I0,A)', 'ALL ', n_pass, ' CHECKS PASSED'
      else
         print '(A,I0,A,I0,A)', 'FAILED: ', n_fail, ' of ', &
            n_pass + n_fail, ' checks'
         error stop 1
      end if
   end subroutine report

end module testing
