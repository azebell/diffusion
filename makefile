
all: c


c: $(patsubst c/%.c, c/%.exe, $(wildcard c/*.c))

%.exe: %.c
	gcc -Wall -lm $^ -o $@ -O3


run: all
	@echo "----------------"
	@echo "C"
	@echo "----------------"
	c/diffusion.exe

clean:
	rm -f c/*.o c/*.exe
