!> Module 5 exercise. Fill in the TODOs. Keep the module name `m5`.
!! Elementary (1D, 2-state, nearest-neighbor) cellular automata.
module m5
   implicit none
   private
   public :: neighborhood_index, apply_rule, step_row, evolve, live_count

contains

   !> Map a 3-cell neighborhood to an index 0..7.
   pure integer function neighborhood_index(left, center, right)
      integer, intent(in) :: left, center, right
      ! TODO: 4*left + 2*center + right
      neighborhood_index = 0
   end function neighborhood_index

   !> Output cell for a neighborhood under the given rule (0..255).
   pure integer function apply_rule(rule, left, center, right)
      integer, intent(in) :: rule, left, center, right
      integer :: p
      ! TODO: p = neighborhood_index(...); return ibits(rule, p, 1)
      p = 0
      apply_rule = 0
   end function apply_rule

   !> One generation, with wraparound neighbors.
   function step_row(rule, row) result(next)
      integer, intent(in) :: rule
      integer, intent(in) :: row(:)
      integer :: next(size(row))
      integer :: left(size(row)), right(size(row))
      integer :: i
      ! TODO:
      !   left  = cshift(row, -1)
      !   right = cshift(row,  1)
      !   do i = 1, size(row): next(i) = apply_rule(rule, left(i), row(i), right(i))
      next = 0
   end function step_row

   !> Evolve for ngen generations. Returns hist(ngen+1, n); row 1 is init.
   function evolve(rule, init, ngen) result(hist)
      integer, intent(in) :: rule
      integer, intent(in) :: init(:)
      integer, intent(in) :: ngen
      integer :: hist(ngen+1, size(init))
      integer :: g
      ! TODO: hist(1,:) = init; loop g=1..ngen: hist(g+1,:) = step_row(rule, hist(g,:))
      hist = 0
   end function evolve

   !> Count of live (==1) cells in a row.
   integer function live_count(row)
      integer, intent(in) :: row(:)
      ! TODO
      live_count = 0
   end function live_count

end module m5
