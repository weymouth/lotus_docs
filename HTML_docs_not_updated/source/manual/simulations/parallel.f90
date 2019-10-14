program parallel
  use mympiMod
  ...
!
! -- MPI utils
  integer           :: b(3) = (/16,1,1/) ! blocks
  integer :: m(3)                        ! points per block
  logical           :: root              ! root processor
  logical           :: kill=.false.      ! ends simulation
  ...
