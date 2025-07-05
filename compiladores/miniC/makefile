miniC: lex.yy.c miniC.tab.c miniC.tab.h miniC.main.c listaCodigo.c listaCodigo.h listaSimbolos.c listaSimbolos.h
	gcc lex.yy.c miniC.tab.c miniC.main.c listaCodigo.c listaSimbolos.c -lfl -o miniC
	
lex.yy.c: miniC.l
	 flex miniC.l

miniC.tab.c miniC.tab.h: miniC.y
	bison -d miniC.y

clean: 
			rm lex.yy.c miniC miniC.tab.c miniC.tab.h	
