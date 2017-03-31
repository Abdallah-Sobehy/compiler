# Makefile example -- lexner and yaccr.
# Creates "myprogram" from "lex.l", "yacc.y", and "myprogram.c"
#
LEX     = flex
YACC    = bison -y
YFLAGS  = -d
objects = lex.o yacc.o

compiler: $(objects)
		flex lex.l
		gcc lex.yy.c yacc.c  -o compiler
lex.o: lex.l yacc.c
yacc.o: yacc.y

clear:
	rm *.o y.tab.h lex.yy.c yacc.c