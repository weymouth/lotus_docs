program tg
	use mympiMod
	use fieldMod, only: field
	use vectorMod, only: vfield
	use fluidMod, only: fluid
    use imageMod, only: display

	implicit none

	real, parameter		:: PI = acos(-1.)
	integer,parameter	:: n(3) = 2**7*[1,1,1] ! Grid size
	real,parameter		:: kn = 2*PI/n(3) 	! Wavenumber
	real,parameter		:: Re = 1600		! Reynolds number
	real, parameter		:: nu=1./(kn*Re)	! Viscosity
	
	type(fluid)			:: flow
	integer				:: b(3)=[4,2,1], m(3), num=9
	real :: tke
	logical :: root

	! -- globals
	call init_mympi(3, set_blocks=b, set_periodic=[.true.,.true.,.true.])
	root = mympi_rank()==0
	m = n/b
	
	! -- Initialize flow
	call flow%init(m, nu=nu)
	call flow%velocity%eval(tgv)
	call flow%velocity%applyBC()
	call flow%reset_u0()
	flow%dt = flow%velocity%cfl_limit(nu)
	flow%velocity%e%exit = .false.

	! Print info
	if(root) write(*,*) '--- Taylor-Green Vortex --- '
	if(root) print*, 'm', m
	if(root) print*, 'kn', kn
	if(root) print*,
	if(root) print*, 
	write(num,*) 't CFL tke  enstrophy'

	! -- Update and keep track of evaluation time
	do while (flow%time*kn.le.14)
		call calc_tke(flow%velocity)
		if (mod(flow%time,2./kn)<flow%dt) call flow%write()
		if (mod(flow%time,0.2/kn)<flow%dt) call display(flow%velocity%vorticity_Z(),'vort',10*kn)
		call flow%update
	end do

	call calc_tke(flow%velocity)
	call flow%write()
	call mympi_end()

contains

	pure function tgv(x) result(v)
		real,intent(in) :: x(3)
		real :: v(3)
		v(1) = -sin(kn*x(1))*cos(kn*x(2))*cos(kn*x(3))
	    v(2) =  cos(kn*x(1))*sin(kn*x(2))*cos(kn*x(3))
	    v(3) = 0.
	end function tgv

	subroutine calc_tke(u)
		use vectorMod, only: vfield, vorticity

		type(vfield), intent(inout) :: u
		integer :: d, num=9
		real :: tke, ens
		real, save :: ens0, tke0
		logical, save :: t0=.true.
		type(vfield) :: vort, uGradTensor(3)

		tke = u%tke()
		call u%gradTensor(uGradTensor)
		call vorticity(uGradTensor, vort)
		ens = vort%tke()

		if (t0) then
			tke0 = tke
			ens0 = ens
			t0 = .false.
		end if

		1 format(2f8.4,2e16.8)
		write(num,1) flow%time*kn, flow%dt, tke/tke0, ens/ens0
		if (root) write(*,1) flow%time*kn, flow%dt, tke/tke0, ens/ens0
	end subroutine calc_tke
end program tg
