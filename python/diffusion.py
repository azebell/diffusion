#!/usr/bin/python3

C = 1e21
L = 5
M = 10
u = 250
D = 0.175

partition = True

A = [[[0.0 for i in range(M)] for j in range(M)] for k in range(M)]

tstep = L/(u*M)
tacc = 0.0

# dTerm is the factor used when moving particles from 
# one cube to another
# dTerm = D * tstep / h^2
dTerm = D*tstep/((L/M)**2)


# if there is to be a partition
# assign -1 to the blocks 
# serving as the barrier
if partition:
	for i in range(M):
			for j in range(M):
				for k in range(M):
					if i==M/2 and j>=M/2:
						A[i][j][k] = -1.0

# set the starting position of the
# concentration of particles
A[0][0][0] = C

biggest = C
smallest = 0.0

print("C = ", C)
print("L = ", L)
print("M = ", M)
print("u = ", u)
print("D = ", D)
print("tstep = ", tstep)


# for each block in the room,
# move particles between adjacent blocks
# that have a common face
# until the room has equilibrated
while smallest <= 0.99*biggest:
	tacc = tacc+tstep
	for i in range(M):
		for j in range(M):
			for k in range(M):

				if i+1<M and A[i][j][k]!=-1 and A[i+1][j][k]!=-1:
					dc = dTerm*( A[i+1][j][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i+1][j][k] = A[i+1][j][k] - dc

				if j+1<M and A[i][j][k]!=-1 and A[i][j+1][k]!=-1:
					dc = dTerm*( A[i][j+1][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j+1][k] = A[i][j+1][k] - dc

				if k+1<M and A[i][j][k]!=-1 and A[i][j][k+1]!=-1:
					dc = dTerm*( A[i][j][k+1] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j][k+1] = A[i][j][k+1] - dc

				if i-1>=0 and A[i][j][k]!=-1 and A[i-1][j][k]!=-1:
					dc = dTerm*( A[i-1][j][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i-1][j][k] = A[i-1][j][k] - dc

				if j-1>=0 and A[i][j][k]!=-1 and A[i][j-1][k]!=-1:
					dc = dTerm*( A[i][j-1][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j-1][k] = A[i][j-1][k] - dc

				if k-1>=0 and A[i][j][k]!=-1 and A[i][j][k-1]!=-1:
					dc = dTerm*( A[i][j][k-1] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j][k-1] = A[i][j][k-1] - dc

	# update the max and min
	biggest = 0.0
	smallest = C
	for i in range(M):
		for j in range(M):
			for k in range(M):
				if A[i][j][k]<smallest and A[i][j][k]>=0:
					smallest = A[i][j][k]
				if A[i][j][k]>biggest:
					biggest = A[i][j][k]

print("Time", tacc, "seconds")
print("min", smallest)
print("max", biggest)
