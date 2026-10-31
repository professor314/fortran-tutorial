!> Module 8 capstone exercise. Fill in the TODOs. Keep the module name `m8`.
!! A generalized outer-totalistic 2D CA engine + complexity measures.
module m8
   use, intrinsic :: iso_fortran_env, only: real64
   use m6, only: neighbor_counts
   implicit none
   private
   public :: in_set, general_step, binary_entropy, density_series, entropy_series

contains

   !> True if integer n appears anywhere in the array `set`.
   pure logical function in_set(set, n)
      integer, intent(in) :: set(:)
      integer, intent(in) :: n
      ! TODO: any(set == n)
      in_set = .false.
   end function in_set

   !> One generation of an outer-totalistic rule.
   !! Dead cell -> alive if count in birth; live cell -> alive if count in survive.
   function general_step(g, birth, survive) result(next)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer :: next(size(g,1), size(g,2))
      integer :: n(size(g,1), size(g,2))
      integer :: r, c
      n = neighbor_counts(g)
      next = 0
      ! TODO: loop over r,c. If g(r,c)==0 and in_set(birth, n(r,c)) -> next=1.
      !       If g(r,c)==1 and in_set(survive, n(r,c)) -> next=1.
   end function general_step

   !> Binary Shannon entropy in bits: -(p log2 p + (1-p) log2 (1-p)).
   !! Define entropy(0) = entropy(1) = 0.
   pure real(real64) function binary_entropy(p)
      real(real64), intent(in) :: p
      real(real64) :: q
      ! TODO: handle p<=0 or p>=1 -> 0; else q=1-p; H = -(p*log(p)+q*log(q))/log(2)
      binary_entropy = 0.0_real64
   end function binary_entropy

   !> Live-cell density at generations 0..ngen. Length ngen+1.
   function density_series(g, birth, survive, ngen) result(d)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer, intent(in) :: ngen
      real(real64) :: d(ngen+1)
      integer :: cur(size(g,1), size(g,2))
      integer :: k
      cur = g
      ! TODO: d(1) = density of cur; loop k=1..ngen: cur=general_step(...); d(k+1)=density
      d = 0.0_real64
   end function density_series

   !> Binary entropy of the density at generations 0..ngen. Length ngen+1.
   function entropy_series(g, birth, survive, ngen) result(h)
      integer, intent(in) :: g(:,:)
      integer, intent(in) :: birth(:), survive(:)
      integer, intent(in) :: ngen
      real(real64) :: h(ngen+1)
      real(real64) :: d(ngen+1)
      integer :: k
      ! TODO: d = density_series(...); h(k) = binary_entropy(d(k)) for each k
      h = 0.0_real64
   end function entropy_series

end module m8
