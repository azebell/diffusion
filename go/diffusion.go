package main

import "fmt"
import "math"

func main() {

	var C float64 = 1e21
	var L float64 = 5.0
	var M int = 10
	var u float64 = 250.0
	var D float64 = 0.175

	var partition = false
	var part string


	//
	// user inpute for M and partition
	//
	fmt.Printf("Input number of divisions M: \n")
	if _, err := fmt.Scan(&M); err == nil {
		// successful inpput
	} else {
		// error handling
	}
	fmt.Printf("Use a partition? (y/n): \n")
	if _, err := fmt.Scan(&part); err == nil {
		// successful input
		if part=="y" {
			partition = true
		}
	} else {
		// error handling
	}


	var tstep = L/(u*float64(M))
	var tacc = 0.0


	// dTerm is the factor used when moving particles from 
	// one cube to another
	// dTerm = D * tstep / h^2
	var dTerm = D*tstep/math.Pow((L/float64(M)), 2)

	// allocate 3d array
	A := make([][][]float64, M)
	for i := range A {
		A[i] = make([][]float64, M)
		for j := range A[i] {
			A[i][j] = make([]float64, M)
		}
	}


	if(partition) {
		fmt.Printf("Using a partition.\n")
	} else {
		fmt.Printf("Not using a partition.\n")
	}
	fmt.Printf("C = %f\n", C)
	fmt.Printf("L = %f\n", L)
	fmt.Printf("M = %d\n", M)
	fmt.Printf("u = %f\n", u)
	fmt.Printf("D = %f\n", D)
	fmt.Printf("tstep = %f\n", tstep)
	fmt.Printf("tacc = %f\n", tacc)
	fmt.Printf("dTerm = %f\n\n", dTerm)

	// if there is to be a partition
	// assign -1 to the blocks 
	// serving as the barrier
	if(partition) {
		for i := range A {
			for j := range A[i] {
				for k := range A[i][j] {
					if (i==M/2-1 && j>=M/2-1) {
						A[i][j][k] = -1.0
					}
				}
			}
		}
	}

	// set the starting position of the 
	// concentration of particles
	A[0][0][0] = C

	// the starting max will always be C
	// and the initial min will always be 0
	var max = C
	var min = 0.0
	var dc = 0.0


	// for each block in the room,
	// move particles between adjacent blocks
	// that have a common face
	// until the room has equilibrated
	for (min <= 0.99*max) {
		tacc += tstep
		for i := range A {
			for j := range A[i] {
				for k := range A[i][j] {

					if (i+1<M && A[i][j][k]!=-1 && A[i+1][j][k]!=-1) {
						dc = dTerm*( A[i+1][j][k] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i+1][j][k] = A[i+1][j][k] - dc
					}
					if (j+1<M && A[i][j][k]!=-1 && A[i][j+1][k]!=-1) {
						dc = dTerm*( A[i][j+1][k] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i][j+1][k] = A[i][j+1][k] - dc
					}
					if (k+1<M && A[i][j][k]!=-1 && A[i][j][k+1]!=-1) {
						dc = dTerm*( A[i][j][k+1] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i][j][k+1] = A[i][j][k+1] - dc
					}
					if (i-1>=0 && A[i][j][k]!=-1 && A[i-1][j][k]!=-1) {
						dc = dTerm*( A[i-1][j][k] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i-1][j][k] = A[i-1][j][k] - dc
					}
					if (j-1>=0 && A[i][j][k]!=-1 && A[i][j-1][k]!=-1) {
						dc = dTerm*( A[i][j-1][k] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i][j-1][k] = A[i][j-1][k] - dc
					}
					if (k-1>=0 && A[i][j][k]!=-1 && A[i][j][k-1]!=-1) {
						dc = dTerm*( A[i][j][k-1] - A[i][j][k] )
						A[i][j][k] = A[i][j][k] + dc
						A[i][j][k-1] = A[i][j][k-1] - dc
					}

				}
			}
		}


		// update the max and min
		max = 0
		min = C
		for i := range A {
			for j := range A[i] {
				for k := range A[i][j] {
					if (A[i][j][k] < min && A[i][j][k] >= 0) {
						min = A[i][j][k]
					}
					if (A[i][j][k] > max) {
						max = A[i][j][k]
					}
				}
			}
		}

	}

	fmt.Printf("tacc = %f\n", tacc)
	fmt.Printf("max = %.1e\n", max)
	fmt.Printf("min = %.1e\n", min)

}
