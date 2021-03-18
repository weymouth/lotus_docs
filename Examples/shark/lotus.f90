program shark
  !
    use bodyMod,    only: body
    use fluidMod,   only: fluid
    use mympiMod,   only: init_mympi,mympi_end,mympi_rank
    use gridMod,    only: xg,composite
    use imageMod,   only: display
    use geom_shape
    implicit none
  !
  ! -- Physical parameters
    real,parameter     :: Re = 8ef
  !
  ! -- Numerical parameters, keep res on line 15 so it can be changed iteratively
    real,parameter     :: c = 64
    real, parameter    :: end = 20, nu = c/Re, m(3) = (/2.,1.4,0./)
    integer            :: b(3) = (/8,2,1/)
    real, parameter    :: a_coeff = 0.1546317282941313, &
                          b_coeff = -0.057325721099144744, &
                          c_coeff = 0.02499048284296976, &
                          k_coeff = 4.210849002162439
  !
  ! -- Hyperparameters, reduced frequency and tail amplitude
    real, parameter    :: A = 0.4*c/2., f = 1/c
  !
  ! -- Variables
    integer :: n(3), ndims = 2
  !
  ! -- Setup solver
    logical :: root, there = .false.
    type(fluid) :: flow
    type(body) :: geom
  !
  ! -- Outputs
    real    :: pforce(3), vforce(3), vpower(3), ppower
  !
  ! -- Initialize
    call init_mympi(ndims,set_blocks=b)
    root = mympi_rank()==0
    if(root) print *,'Setting up the grid, body and fluid'
    if(root) print *,'-----------------------------------'
  !
  ! -- Setup the grid
    n = composite(c*m,prnt=root)
    call xg(1)%stretch(n(1), -4*c, -0.2*c, 2.*c, 6*c, h_min=2., h_max=16.,prnt=root)
    call xg(2)%stretch(n(2), -2.*c, -0.4*c, 0.4*c, 2.*c, prnt=root)
  !
  ! -- Call the geometry and kinematics
    geom = wavy_wall(c, c/22.) !.map.init_warp(2,h,doth,dh)
  !
  ! -- Initialise fluid
    call flow%init(n/b,geom,V=(/1.,0.,0./),nu=nu,exit=.true.)
    ! call display(flow%velocity%vorticity_Z(), 'out_vort', lim = 0.25)
    flow%time = 0
  !
    if(root) print *,'Starting time update loop'
    if(root) print *,'-----------------------------------'
    if(root) print *,' -t- , -dt- '
  !
  ! -- Go for 10 cycles
    do while(flow%time*f<end .and..not.there)
      call geom%update(flow%time+flow%dt)
      call flow%update(geom)
      ! call flow%write(geom) ! Saves fluid.vtr.pvd (Takes up a lot of disk space and time)
  !
      if(flow%time*f>(end-1)) then
        ! call flow%write(geom)
      end if
  ! -- Need to merge processor calculations before writing when running in parallel.
      vforce = geom%vforce(flow%velocity)*nu/(0.5*(2*c+c/11))
      pforce = -geom%pforce(flow%pressure)/(0.5*(2*c+c/11))
      vpower = geom%vpower(flow%velocity)*nu/(0.5*(2*c+c/11))
      ppower = -geom%ppower(flow%pressure)/(0.5*(2*c+c/11))
      write(9,'(f10.4,f8.4,8e16.8)') flow%time*f, flow%dt, vforce(:ndims), pforce(:ndims), vpower(:ndims), ppower
      flush(9)
      if(mod(flow%time,0.25/f)<flow%dt.and.flow%time*f>0.1) then
        if(root) print *,flow%time*f, flow%dt
        ! call display(flow%velocity%vorticity_Z(), 'out_vort', lim = 0.25) ! Saves an image of the vorticity (less disk heavy than vtr if you just want the visualisation)
      end if
      inquire(file='.kill', exist=there)
    end do
    if(root) print *,'Loop complete: writing restart files and exiting'
    if(root) print *,'-----------------------------------'
    call flow%write()
    call mympi_end
  contains
  !
  ! -- Kinematics for Squalus Acanthias (spiny dogfish)
  real pure function h(x)
  real,intent(in) :: x(3)
  h = amp(x(1))*sin(arg(x(1)))
  end function h
  real pure function doth(x)
  real,intent(in) :: x(3)
  doth = amp(x(1))*cos(arg(x(1)))*2*pi*f
  end function doth
  pure function dh(x)
  real,intent(in) :: x(3)
  real            :: dh(3)
  dh = 0
  dh(1) = damp(x(1))*sin(arg(x(1))) &
        - amp(x(1))*cos(arg(x(1)))*k_coeff/c
  end function dh
  real pure function arg(x)
  real,intent(in) :: x
  real :: xp
  xp = min(max(x/c,0.),1.)
  arg = (2*pi*f*flow%time - k_coeff*xp)
  end function arg
  real pure function amp(x)
  real,intent(in) :: x
  real :: xp
  xp = min(max(x/c,0.),1.)
  amp = A*(((a_coeff*(xp**2))+(b_coeff*(xp))+(c_coeff))/(a_coeff+b_coeff+c_coeff))
  end function amp
  real pure function damp(x)
  real,intent(in) :: x
  real :: xp
  xp = min(max(x/c,0.),1.)
  damp = A*(b_coeff+2.*(a_coeff*xp))/(c*(a_coeff+b_coeff+c_coeff)) ! Be careful with the cs when differentiating
  end function damp
  
  
  type(set) function wavy_wall(length, thickness) result(geom)
  real,intent(in) :: length, thickness
  real,parameter  :: s2 = 1.
    geom = plane((/0.,1.,0./),(/0.,0.5*thickness,0./)) &
      .and.plane((/1.,0.,0./),(/1.*length,0.,0./)) &
      .and.plane((/0.,-1.,0./),(/0.,-0.5*thickness,0./)) &
      .and.plane((/-1.,0.,0./),(/0.,0.,0./))
  end function
  
  end program shark
  