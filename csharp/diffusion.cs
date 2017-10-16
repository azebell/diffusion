
using System;

int main(int argc, char** argv) {

	double tstep, tacc;
	double min, max;
	double dTerm, dc;

	const double C = pow(10,21);
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


	Console.Write("%5s = %f\n%5s = %f\n%5s = %d\n", "C", C, "L", L, "M", M);
	Console.Write("%5s = %f\n%5s = %.3f\n", "u", u, "D", D);
	Console.Write("tstep: %f\n\n", tstep);

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
								if( (unsigned)l<M && (unsigned)m<M && (unsigned)n<M ){
									if( abs(i-l) + abs(j-m) + abs(k-n) == 1 ) {
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

	Console.Write("%s: %.2f seconds\n", "Time", tacc);
	Console.Write("%s: %.1fE17\n", "Min", min/Math.Pow(10,17));
	Console.Write("%s: %.1fE17\n", "Max", max/Math.Pow(10,17));
	Console.Write("%s: %f\n", "Ratio", min/max);
}
