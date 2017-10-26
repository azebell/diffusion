
all: c


c: $(patsubst c/%.c, c/%.exe, $(wildcard c/*.c))

%.exe: %.c
	gcc -Wall -lm $^ -o $@ -O3


csharp: $(patsubst csharp/%.cs, csharp/%.exe, $(wildcard csharp/*.cs))

%.exe: %.cs
	mcs $^ -o $@

fortran: $(patsubst fortran/%.f90, fortran/%.exe, $(wildcard fortran/*.f90))

%.exe: %.f90
	gfortran $^ -o $@ -O3


run: all
	@echo "----------------"
	@echo "C"
	@echo "----------------"
	c/diffusion.exe

clean:
	rm */*.exe
