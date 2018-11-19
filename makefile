all: coursework

coursework: coursework.o
	gcc -o $@ $+

coursework.o: coursework.s
	as -o $@ $<

clean:
	rm -vf cw *.o
