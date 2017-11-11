
using System;

public class diffusion {

static public void Main() {

	double tstep, tacc;
	double min, max;
	double dTerm, dc;
	bool partition = true;

	double C = Math.Pow(10,21);
	const double L = 5;
	int M = 10;
	const double u = 250;
	const double D = 0.175;


	//
	// user input for M and partition
	//
	Console.Clear();
	Console.Write("Input number of divisions M: ");
	int.TryParse(Console.ReadLine(), out M);
	if(M<1) { M = 10; }
	Console.Write("Use a partition? (y/n): ");
	partition = Console.Read()=='y';
	if(partition) {
		Console.WriteLine("\nUsing a partition.");
	}
	else {
		Console.WriteLine("\nNot using a partition.");
	}


	// allocate 3d array
	double[,,] A = new double[M,M,M];

	// initialize the array values to 0
	for(int i=0; i<M; i++) {
		for(int j=0; j<M; j++) {
			for(int k=0; k<M; k++) {
				A[i,j,k] = 0.0;
			}
		}
	}

	tstep = L/(u*M);
	tacc = 0.0;

	// dTerm is the factor used when moving particles from 
	// one cube to another
	// dTerm = D * tstep / h^2
	dTerm = D*tstep/Math.Pow(L/M, 2);


	Console.WriteLine("C = " + C + "\nL = " + L + "\nM = " + M);
	Console.WriteLine("u = " + u + "\nD = " + D);
	Console.WriteLine("tstep: " + tstep);


	// if there is to be a partition
	// assign -1 to the blocks 
	// serving as the barrier
	if (partition) {
		for(int i=0; i<M; i++) {
			for(int j=0; j<M; j++) {
				for(int k=0; k<M; k++) {
					if(i==M/2-1 && j>=M/2-1) {
						A[i,j,k] = -1.0;
					}
				}
			}
		}
	}

	// set the starting position of the 
	// concentration of particles
	A[0,0,0] = C;

	// the starting max will always be C
	// and the initial min will always be 0
	max = C;
	min = 0;


	// for each block in the room,
	// move particles between adjacent blocks
	// that have a common face
	// until the room has equilibrated
	while(min <= 0.99*max) {
		tacc = tacc+tstep;

		for(int i=0; i<M; i++) {
			for(int j=0; j<M; j++) {
				for(int k=0; k<M; k++) {
					if (i+1<M && A[i,j,k]!=-1 && A[i+1,j,k]!=-1) {
						dc = dTerm*( A[i+1,j,k] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i+1,j,k] = A[i+1,j,k] - dc;
					}
					if (j+1<M && A[i,j,k]!=-1 && A[i,j+1,k]!=-1) {
						dc = dTerm*( A[i,j+1,k] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i,j+1,k] = A[i,j+1,k] - dc;
					}
					if (k+1<M && A[i,j,k]!=-1 && A[i,j,k+1]!=-1) {
						dc = dTerm*( A[i,j,k+1] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i,j,k+1] = A[i,j,k+1] - dc;
					}
					if (i-1>=0 && A[i,j,k]!=-1 && A[i-1,j,k]!=-1) {
						dc = dTerm*( A[i-1,j,k] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i-1,j,k] = A[i-1,j,k] - dc;
					}
					if (j-1>=0 && A[i,j,k]!=-1 && A[i,j-1,k]!=-1) {
						dc = dTerm*( A[i,j-1,k] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i,j-1,k] = A[i,j-1,k] - dc;
					}
					if (k-1>=0 && A[i,j,k]!=-1 && A[i,j,k-1]!=-1) {
						dc = dTerm*( A[i,j,k-1] - A[i,j,k] );
						A[i,j,k] = A[i,j,k] + dc;
						A[i,j,k-1] = A[i,j,k-1] - dc;
					}
				}
			}
		}

		// update the current min and max
		min = max;
		max = 0.0;
		for(int i=0; i<M; i++) {
			for(int j=0; j<M; j++) {
				for(int k=0; k<M; k++) {
					if(A[i,j,k] < min && A[i,j,k] >= 0)
						min = A[i,j,k];
					if(A[i,j,k] > max)
						max = A[i,j,k];
				}
			}
		}

	}

	Console.WriteLine();
	Console.WriteLine("Time: " + tacc);
	Console.WriteLine("Min: " + min);
	Console.WriteLine("Max: " + max);
	Console.WriteLine("Ratio: " + (min/max));
}

}
