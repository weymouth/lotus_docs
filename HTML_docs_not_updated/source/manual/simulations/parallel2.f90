  ...
! -- Initialize MPI (2D)
  call init_mympi(2,set_blocks=b)
  root = mympi_rank()==0
!
! -- Initialize grid (2D)
  n = composite(DG*(/8,2,1/), prnt=.true.)
  call xg(1)%stretch(n(1), -5*DG, -0.6*DG, 0.6*DG, 15*DG, h_max=15., prnt=.true.)
  call xg(2)%stretch(n(2), -5*DG, -0.6*DG, 0.6*DG, 5*DG, prnt=.true.)
  ...
