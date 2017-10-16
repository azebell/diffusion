
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mval(MEM,x,y,z) MEM[x*M*M+y*M+z]

double pow(double, double);

int main(int argc, char** argv) {


	int i, j, k, l, m, n;
	double* A;
	double tstep, tacc;
	double min, max;
	double dTerm, dc;

	const double C = pow(10,21);
	const double L = 5;
	const int M = 10;
	const double u = 250;
	const double D = 0.175;

	A = malloc(M*M*M * sizeof(double));

	// initialize the array values to 0
	for(i=0; i<M; i++) {
		for(j=0; j<M; j++) {
			for(k=0; k<M; k++) {
				mval(A,i,j,k) = 0.0;
			}
		}
	}

	tstep = L/(u*M);
	tacc = 0.0;

	// dTerm is the factor used when moving particles from 
	// one cube to another
	// dTerm = D * tstep / h^2
	dTerm = D*tstep/pow(L/M, 2);


	printf("%5s = %f\n%5s = %f\n%5s = %d\n", "C", C, "L", L, "M", M);
	printf("%5s = %f\n%5s = %.3f\n", "u", u, "D", D);
	printf("tstep: %f\n\n", tstep);

	// set the starting position of the 
	// concentration of particles
	mval(A,0,0,0) = C;

	// the starting max will always be C
	// and the initial min will always be 0
	max = C;
	min = 0;

	while(min <= 0.99*max) {
		tacc = tacc+tstep;

		for(i=0; i<M; i++) {
			for(j=0; j<M; j++) {
				for(k=0; k<M; k++) {
					for(l=i-1; l<i+2; l++) {
						for(m=j-1; m<j+2; m++) {
							for(n=k-1; n<k+2; n++) {

								// if cube l,m,n is exactly 1 unit away
								// and also within the array bounds
								if( (unsigned)l<M && (unsigned)m<M && (unsigned)n<M ){
									if( abs(i-l) + abs(j-m) + abs(k-n) == 1 ) {
										dc = dTerm*( mval(A,l,m,n) - mval(A,i,j,k) );
										mval(A,i,j,k) = mval(A,i,j,k) + dc;
										mval(A,l,m,n) = mval(A,l,m,n) - dc;
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
		for(i=0; i<M; i++) {
			for(j=0; j<M; j++) {
				for(k=0; k<M; k++) {
					if(mval(A,i,j,k) < min)
						min = mval(A,i,j,k);
					if(mval(A,i,j,k) > max)
						max = mval(A,i,j,k);
				}
			}
		}

	}

	printf("%s: %.2f seconds\n", "Time", tacc);
	printf("%s: %.1fE17\n", "Min", min/pow(10,17));
	printf("%s: %.1fE17\n", "Max", max/pow(10,17));
	printf("%s: %f\n", "Ratio", min/max);

	free(A);
}
