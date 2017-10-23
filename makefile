
all: c


c: $(patsubst c/%.c, c/%.exe, $(wildcard c/*.c))

%.exe: %.c
	gcc -Wall -lm $^ -o $@ -O3


csharp: $(patsubst csharp/%.cs, csharp/%.exe, $(wildcard csharp/*.cs))

%.exe: %.cs
	mcs $^ -o $@


run: all
	@echo "----------------"
	@echo "C"
	@echo "----------------"
	c/diffusion.exe

clean:
	rm */*.o */*.exe
