!> Module 7 reference solution. Includes load_grid (file I/O) for the demo.
module m7
   use m6, only: neighbor_counts
   implicit none
   private
   public :: life_step, is_still_life, period_of, parse_char, load_grid

contains

   function life_step(g) result(next)
      integer, intent(in) :: g(:,:)
      integer :: next(size(g,1), size(g,2))
      integer :: n(size(g,1), size(g,2))
      n = neighbor_counts(g)
      next = 0
      where (n == 3) next = 1
      where (n == 2 .and. g == 1) next = 1
   end function life_step

   logical function is_still_life(g)
      integer, intent(in) :: g(:,:)
      is_still_life = all(life_step(g) == g)
   end function is_still_life

   integer function period_of(g, maxp)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: maxp
      integer :: cur(size(g,1), size(g,2))
      integer :: p
      period_of = 0
      cur = g
      do p = 1, maxp
         cur = life_step(cur)
         if (all(cur == g)) then
            period_of = p
            return
         end if
      end do
   end function period_of

   pure integer function parse_char(c)
      character(len=1), intent(in) :: c
      if (c == '#' .or. c == '1') then
         parse_char = 1
      else
         parse_char = 0
      end if
   end function parse_char

   !> Load a grid from a seed file. Format:
   !!   line 1: "<rows> <cols>"
   !!   next <rows> lines: <cols> chars, '#'/'1' alive, else dead.
   subroutine load_grid(filename, g, ok)
      character(len=*), intent(in) :: filename
      integer, allocatable, intent(out) :: g(:,:)
      logical, intent(out) :: ok
      integer :: unit, ios, nr, nc, r, c
      character(len=512) :: line
      ok = .false.
      open(newunit=unit, file=filename, status='old', action='read', iostat=ios)
      if (ios /= 0) return
      read(unit, *, iostat=ios) nr, nc
      if (ios /= 0) then
         close(unit); return
      end if
      allocate(g(nr, nc))
      g = 0
      do r = 1, nr
         read(unit, '(A)', iostat=ios) line
         if (ios /= 0) exit
         do c = 1, nc
            if (c <= len_trim(line)) g(r, c) = parse_char(line(c:c))
         end do
      end do
      close(unit)
      ok = .true.
   end subroutine load_grid

end module m7
