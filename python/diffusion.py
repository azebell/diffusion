
C = 1e21
L = 5
M = 10
u = 250
D = 0.175

A = [[[0.0 for i in range(M)] for j in range(M)] for k in range(M)]

tstep = L/(u*M)
tacc = 0.0

dTerm = D*tstep/((L/M)**2)

A[0][0][0] = C


biggest = max(list(map(max, map(max, A))))
smallest = min(list(map(min, map(min, A))))

print("C = ", C)
print("L = ", L)
print("M = ", M)
print("u = ", u)
print("D = ", D)
print("tstep = ", tstep)

while smallest <= 0.99*biggest:
	tacc = tacc+tstep
	for i in range(M):
		for j in range(M):
			for k in range(M):
				if i+1<M:
					dc = dTerm*( A[i+1][j][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i+1][j][k] = A[i+1][j][k] - dc
				if j+1<M:
					dc = dTerm*( A[i][j+1][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j+1][k] = A[i][j+1][k] - dc
				if k+1<M:
					dc = dTerm*( A[i][j][k+1] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j][k+1] = A[i][j][k+1] - dc
				if i-1>=0:
					dc = dTerm*( A[i-1][j][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i-1][j][k] = A[i-1][j][k] - dc
				if j-1>=0:
					dc = dTerm*( A[i][j-1][k] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j-1][k] = A[i][j-1][k] - dc
				if k-1>=0:
					dc = dTerm*( A[i][j][k-1] - A[i][j][k] )
					A[i][j][k] = A[i][j][k] + dc
					A[i][j][k-1] = A[i][j][k-1] - dc
	biggest = max(list(map(max, map(max, A))))
	smallest = min(list(map(min, map(min, A))))

print("Time", tacc, "seconds")
print("min", smallest)
print("max", biggest)