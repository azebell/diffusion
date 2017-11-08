
# Diffusion Simulation

Code checked for mass consistency on 11/8/17 

This program runs a three dimensional simulation of the diffusion of particles in a cube shaped room. The precision of the simulation is determined by the number of blocks inside of the room. A larger number takes longer to calculate, but is more accurate. 

# How to Use

## C
To compile and run the C program:
```
$ cd c
$ gcc diffusion.c -O3 -o diffusion.exe
$ ./diffusion.exe
```
## C#
To compile and run the C# program:
```
$ cd csharp
$ mcs diffusion.cs
$ mono ./diffusion.exe
```

## FORTRAN
To compile and run the FORTRAN program:
```
$ cd fortran
$ gfortran diffusion.f90 -O3 -o diffusion.exe
$ ./diffusion.exe
```

## GO
To run the GO program:
```
$ cd go
$ go run diffusion.go
```

## LISP
To run the LISP program:
```
$ cd lisp
$ ./diffusion.lisp
```

## PYTHON
To run the PYTHON program:
```
$ cd python
$ ./diffusion.py
```
