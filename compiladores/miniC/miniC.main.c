#include <stdio.h>
#include <stdlib.h>

extern char yytext;
extern int  yyleng;
extern FILE *yyin;
extern int yyparse();
FILE *fich;
int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Error:\nEl uso correcto es: %s fichero\n",argv[0]);
        exit(1);
    }
    FILE *fich = fopen(argv[1],"r");
    if (fich == 0) {
        printf("Error:\nNo se puede abrir %s\n",argv[1]);
        exit(1);
    }
    yyin = fich;
    yyparse();
    fclose(fich);
}
