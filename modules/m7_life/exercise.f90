!> Module 7 exercise. Fill in the TODOs. Keep the module name `m7`.
!! Conway's Game of Life. Uses m6's neighbor_counts (linked by the checker).
module m7
   use m6, only: neighbor_counts
   implicit none
   private
   public :: life_step, is_still_life, period_of, parse_char

contains

   !> One generation of Conway's Game of Life (toroidal).
   function life_step(g) result(next)
      integer, intent(in) :: g(:,:)
      integer :: next(size(g,1), size(g,2))
      integer :: n(size(g,1), size(g,2))
      n = neighbor_counts(g)
      next = 0
      ! TODO:
      !   where (n == 3) next = 1
      !   where (n == 2 .and. g == 1) next = 1
   end function life_step

   !> True if the grid is unchanged by one step.
   logical function is_still_life(g)
      integer, intent(in) :: g(:,:)
      ! TODO: all(life_step(g) == g)
      is_still_life = .false.
   end function is_still_life

   !> Smallest period in 1..maxp returning g to itself, else 0.
   integer function period_of(g, maxp)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: maxp
      integer :: cur(size(g,1), size(g,2))
      integer :: p
      period_of = 0
      cur = g
      ! TODO: for p = 1..maxp: cur = life_step(cur); if all(cur==g) then period_of=p; return
   end function period_of

   !> Map a character to a cell value: '#' or '1' -> 1, else 0.
   pure integer function parse_char(c)
      character(len=1), intent(in) :: c
      ! TODO
      parse_char = 0
   end function parse_char

end module m7
