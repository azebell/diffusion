
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define mval(MEM,x,y,z) MEM[x*M*M+y*M+z]

double pow(double, double);

int main(int argc, char** argv) {


	int i, j, k;
	double* A;
	double tstep, tacc;
	double min, max;
	double dTerm, dc, tmp;

	int partition = 1;

	const double C = 1e21;
	const double L = 5;
	const int M = 10;
	const double u = 250;
	const double D = 0.175;

	A = malloc(M*M*M * sizeof(double));

	// initialize the array values to 0
	for(i=0; i<M; i++) {
		for(j=0; j<M; j++) {
			for(k=0; k<M; k++) {
				// if there is to be a partition
				// assign -1 to the blocks 
				// serving as the barrier
				if(partition && i==M/2 && j>=M/2) {
					mval(A,i,j,k) = -1.0;
				}
				else {
					mval(A,i,j,k) = 0.0;
				}
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


	// for each block in the room,
	// move particles between adjacent blocks
	// that have a common face
	// until the room has equilibrated
	while(min <= 0.99*max) {
		tacc = tacc+tstep;

		for(i=0; i<M; i++) {
			for(j=0; j<M; j++) {
				for(k=0; k<M; k++) {

					if(i+1<M && mval(A,i,j,k)!=-1 && mval(A,(i+1),j,k)!=-1) {
						dc = dTerm*( mval(A,(i+1),j,k) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,(i+1),j,k) = mval(A,(i+1),j,k) - dc;
					}
					if(j+1<M && mval(A,i,j,k)!=-1 && mval(A,i,(j+1),k)!=-1) {
						dc = dTerm*( mval(A,i,(j+1),k) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,i,(j+1),k) = mval(A,i,(j+1),k) - dc;
					}
					if(k+1<M && mval(A,i,j,k)!=-1 && mval(A,i,j,(k+1))!=-1) {
						dc = dTerm*( mval(A,i,j,(k+1)) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,i,j,(k+1)) = mval(A,i,j,(k+1)) - dc;
					}
					if(i-1>=0 && mval(A,i,j,k)!=-1 && mval(A,(i-1),j,k)!=-1) {
						dc = dTerm*( mval(A,(i-1),j,k) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,(i-1),j,k) = mval(A,(i-1),j,k) - dc;
					}
					if(j-1>=0 && mval(A,i,j,k)!=-1 && mval(A,i,(j-1),k)!=-1) {
						dc = dTerm*( mval(A,i,(j-1),k) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,i,(j-1),k) = mval(A,i,(j-1),k) - dc;
					}
					if(k-1>=0  && mval(A,i,j,k)!=-1 && mval(A,i,j,(k-1))!=-1) {
						dc = dTerm*( mval(A,i,j,(k-1)) - mval(A,i,j,k) );
						mval(A,i,j,k) = mval(A,i,j,k) + dc;
						mval(A,i,j,(k-1)) = mval(A,i,j,(k-1)) - dc;
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
					tmp = mval(A,i,j,k);
					if(tmp < min && tmp >= 0)
						min = mval(A,i,j,k);
					if(mval(A,i,j,k) > max)
						max = mval(A,i,j,k);
				}
			}
		}

	}

	printf("%s: %.2f seconds\n", "Time", tacc);
	printf("%s: %.1E\n", "Min", min);
	printf("%s: %.1E\n", "Max", max);
	printf("%s: %f\n", "Ratio", min/max);

	free(A);
}
