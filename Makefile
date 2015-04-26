CC=gcc
FC=flex
src_l=lalg.l
src_c=lex.yy.c
exe=lalg-al
par=-o
in1=in1.txt
in2=in2.txt
in3=in3.txt
in4=in4.txt
in5=in5.txt
out=lalg-al-out.txt

all: compile_flex compile_c

compile_flex:
	$(FC) $(src_l)

compile_c: compile_flex
	$(CC) $(src_c) $(par) $(exe)

clean:
	rm $(exe) $(src_c) $(out)

1: all
	./$(exe) < $(in1)
2: all
	./$(exe) < $(in2)
3: all
	./$(exe) < $(in3)
4: all
	./$(exe) < $(in4)
5: all
	./$(exe) < $(in5)
