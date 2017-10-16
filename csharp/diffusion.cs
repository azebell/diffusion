
using System;

public class diffusion {

static public void Main() {

	double tstep, tacc;
	double min, max;
	double dTerm, dc;

	double C = Math.Pow(10,21);
	const double L = 5;
	const int M = 10;
	const double u = 250;
	const double D = 0.175;

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

	// set the starting position of the 
	// concentration of particles
	A[0,0,0] = C;

	// the starting max will always be C
	// and the initial min will always be 0
	max = C;
	min = 0;

	while(min <= 0.99*max) {
		tacc = tacc+tstep;

		for(int i=0; i<M; i++) {
			for(int j=0; j<M; j++) {
				for(int k=0; k<M; k++) {
					for(int l=i-1; l<i+2; l++) {
						for(int m=j-1; m<j+2; m++) {
							for(int n=k-1; n<k+2; n++) {

								// if cube l,m,n is exactly 1 unit away
								// and also within the array bounds
								if( (uint)l<M && (uint)m<M && (uint)n<M ){
									if( Math.Abs(i-l) + Math.Abs(j-m) + Math.Abs(k-n) == 1 ) {
										dc = dTerm*( A[l,m,n] - A[i,j,k] );
										A[i,j,k] = A[i,j,k] + dc;
										A[l,m,n] = A[l,m,n] - dc;
									}
								}

							}
						}
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
					if(A[i,j,k] < min)
						min = A[i,j,k];
					if(A[i,j,k] > max)
						max = A[i,j,k];
				}
			}
		}

	}

	Console.WriteLine("Time: " + tacc);
	Console.WriteLine("Min: " + min);
	Console.WriteLine("Max: " + max);
	Console.WriteLine("Ratio: " + (min/max));
}

}