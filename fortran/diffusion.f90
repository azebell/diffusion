
program Diffusion

implicit none

real :: C, L, u, D
real :: tacc, tstep
real :: dTerm, dc
real :: maximum, minimum
integer :: M
real, dimension(:,:,:), allocatable :: A
integer :: mem_stat
integer :: i, j, k
logical :: partition = .true.


C = 1e21
L = 5.0
M = 10
u = 250
D = 0.175

tstep = L/(u*M)
tacc = 0.0

! dTerm is the factor used when moving particles from 
! one cube to another
! dTerm = D * tstep / h^2
dTerm = D*tstep/((L/M)**2)

print *, "C =", C
print *, "L =", L
print *, "M =", M
print *, "u =", u
print *, "D =", D
print *, "tstep =", tstep
print *

allocate(A(M,M,M), STAT=mem_stat)
if(mem_stat/=0) STOP "MEMORY ALLOCATION ERROR"
forall(i=1:M,j=1:M,k=1:M) A(i,j,k) = 0.0


! if there is to be a partition
! assign -1 to the blocks 
! serving as the barrier
if (partition) then
    do i = 1, M
        do j = 1, M
            do k = 1, M
                if (i .eq. M/2 .and. j .gt. M/2) then
                    A(i,j,k) = -1.0
                end if
            end do
        end do
    end do
end if

! set the starting position
! of the concentration
A(1,1,1) = C

maximum = C
minimum = 0.0


! for each block in the room,
! move particles between adjacent blocks
! that have a common face
! until the room has equilibrated
do while(minimum .lt. maximum*0.99)
    tacc = tacc+tstep
    do i = 1, M
        do j = 1, M
            do k = 1, M

                if (i+1 .le. M .and. A(i,j,k) .ne. -1 .and. A(i+1,j,k) .ne. -1) then
                    dc = dTerm*( A(i+1,j,k) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i+1,j,k) = A(i+1,j,k) - dc
                end if
                if (j+1 .le. M .and. A(i,j,k) .ne. -1 .and. A(i,j+1,k) .ne. -1) then
                    dc = dTerm*( A(i,j+1,k) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i,j+1,k) = A(i,j+1,k) - dc
                end if
                if (k+1 .le. M .and. A(i,j,k) .ne. -1 .and. A(i,j,k+1) .ne. -1) then
                    dc = dTerm*( A(i,j,k+1) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i,j,k+1) = A(i,j,k+1) - dc
                end if
                if (i-1 .gt. 0 .and. A(i,j,k) .ne. -1 .and. A(i-1,j,k) .ne. -1) then
                    dc = dTerm*( A(i-1,j,k) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i-1,j,k) = A(i-1,j,k) - dc
                end if
                if (j-1 .gt. 0 .and. A(i,j,k) .ne. -1 .and. A(i,j-1,k) .ne. -1) then
                    dc = dTerm*( A(i,j-1,k) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i,j-1,k) = A(i,j-1,k) - dc
                end if
                if (k-1 .gt. 0 .and. A(i,j,k) .ne. -1 .and. A(i,j,k-1) .ne. -1) then
                    dc = dTerm*( A(i,j,k-1) - A(i,j,k) )
                    A(i,j,k) = A(i,j,k) + dc
                    A(i,j,k-1) = A(i,j,k-1) - dc
                end if

            end do
        end do
    end do

    ! update the max and min
    maximum = 0.0
    minimum = C
    do i = 1, M
        do j = 1, M
            do k = 1, M
                if (A(i,j,k) < minimum .and. A(i,j,k) >= 0) then
                    minimum = A(i,j,k)
                end if
                if (A(i,j,k) > maximum) then
                    maximum = A(i,j,k)
                end if
            end do
        end do
    end do
end do

print *, "Time:", tacc, "seconds"
print *, "Min:", minimum
print *, "Max:", maximum


end program Diffusion
