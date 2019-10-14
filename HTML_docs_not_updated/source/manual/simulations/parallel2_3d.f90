  ...
! -- Initialize MPI (3D)
  call init_mympi(3,set_blocks=b,set_periodic=(/.false.,.false.,.true./))
  root = mympi_rank()==0
!
! -- Initialize grid (3D)
  n = composite(DG*(/8,2,1/), prnt=root)
  call xg(1)%stretch(n(1), -5*DG, -0.6*DG, 0.6*DG, 15*DG, h_max=15., prnt=root)
  call xg(2)%stretch(n(2), -5*DG, -0.6*DG, 0.6*DG, 5*DG, prnt=root)
  xg(3)%h = 5.
  ...
