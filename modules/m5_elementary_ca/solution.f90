!> Module 5 reference solution.
module m5
   implicit none
   private
   public :: neighborhood_index, apply_rule, step_row, evolve, live_count

contains

   pure integer function neighborhood_index(left, center, right)
      integer, intent(in) :: left, center, right
      neighborhood_index = 4*left + 2*center + right
   end function neighborhood_index

   pure integer function apply_rule(rule, left, center, right)
      integer, intent(in) :: rule, left, center, right
      integer :: p
      p = neighborhood_index(left, center, right)
      apply_rule = ibits(rule, p, 1)
   end function apply_rule

   function step_row(rule, row) result(next)
      integer, intent(in) :: rule
      integer, intent(in) :: row(:)
      integer :: next(size(row))
      integer :: left(size(row)), right(size(row))
      integer :: i
      left  = cshift(row, -1)
      right = cshift(row,  1)
      do i = 1, size(row)
         next(i) = apply_rule(rule, left(i), row(i), right(i))
      end do
   end function step_row

   function evolve(rule, init, ngen) result(hist)
      integer, intent(in) :: rule
      integer, intent(in) :: init(:)
      integer, intent(in) :: ngen
      integer :: hist(ngen+1, size(init))
      integer :: g
      hist(1,:) = init
      do g = 1, ngen
         hist(g+1,:) = step_row(rule, hist(g,:))
      end do
   end function evolve

   integer function live_count(row)
      integer, intent(in) :: row(:)
      live_count = count(row == 1)
   end function live_count

end module m5
