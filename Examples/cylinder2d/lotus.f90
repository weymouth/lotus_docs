program cylinder2d
  use fluidMod,   only: fluid
  use fieldMod,   only: field
  use bodyMod,    only: body
  use mympiMod
  use gridMod
  use imageMod,   only: display
  use geom_shape
  implicit none
!
! -- numerical parameters
  real,parameter  :: D = 64             ! resolution (pnts per diameter)
  real,parameter :: nu = D/10000
  integer         :: n(3)               ! number of points
! -- MPI utils
  integer :: b(3) = (/2,2,1/)                                   ! 128 blocks
  integer :: m(3)                                               ! number of points per block
  logical :: root                                               ! root processor
  logical :: kill=.false.                                       ! exits the time loop
! -- utils
  real,parameter :: dtPrint = 0.2*D                             ! print rate
  real  :: finish = 0.5*D     ! number of timesteps
! -- variables
  type(fluid) :: flow
  type(body)  :: geom
  real :: dt, t, pforce(2), vforce(2)

! -- Initialize MPI (if MPI is OFF, b is set to 1)
  call init_mympi(2,set_blocks=b)
  root = mympi_rank()==0

! -- Print MPI info
  if (root) print *, 'Blocks: ',b

! -- Initialize grid (might need to adjust these parameters later)
  n = composite(D*(/22,9,0/), prnt=root)!.true.)
  call xg(1)%stretch(n(1), -10*D, -1.5*D, 14*D, 25*D, h_max=15., prnt=root)
  call xg(2)%stretch(n(2), -10*D, -3.5*D, 3.5*D, 10*D, prnt=root)

! -- Initialize cylinder array
  geom = cylinder(axis=3,radius=0.5*D,center=0)

! -- Initialize fluid
  m = n/b
  call flow%init(m, geom, V=[1.,0.,0.], nu=nu)

  if(root) print *, '-- init complete --'
! -- Time update loop
  finish = finish+flow%time
  do while (flow%time<finish)
    dt = flow%dt                    ! time step
    call flow%update()              ! update N-S
    t = flow%time
    
    pforce = -2.*geom%pforce(flow%pressure)/D
    vforce = 2.*nu*geom%vforce(flow%velocity)/D
  	if(root) write(9,'(f10.4,f8.4,4e16.8)') t/D,dt,pforce,vforce
    if(root) flush(9)

    if(mod(t,dtPrint)<dt) then
      if(root) print "('Time:',f15.3,'. Time remaining:',f15.3)",t/D,finish/D-t/D
      call display(flow%velocity%vorticity_Z(), 'out_vort', lim = 20./D)
      call flow%write()
    end if
  end do

  call flow%write()
  call mympi_end()
end program cylinder2d
