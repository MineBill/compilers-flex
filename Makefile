lexer: lex.yy.c
	gcc -o lexer lex.yy.c

lex.yy.c: main.l
	flex main.l

clean:
	rm lex.yy.c lexer