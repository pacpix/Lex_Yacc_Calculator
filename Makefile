cc = gcc
ccopts = -ly
lex = lex
lexopts =
lexgens = lex.yy.c
yacc = yacc
yaccopts = -d
yaccgens = y.tab.c y.tab.h
prj = calc

$(prj): $(lexgens) $(yaccgens)
	$(cc) $(lexgens) $(yaccgens) $(ccopts) -o $(prj)

clean:
	rm $(lexgens) $(yaccgens) $(prj)

$(yaccgens): $(prj).y sym.h
	$(yacc) $(yaccopts) $(prj).y

$(lexgens): $(prj).l $(yaccgens) sym.h
	$(lex) $(lexopts) $(prj).l
