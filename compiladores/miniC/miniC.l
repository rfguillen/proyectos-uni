%{

#include <stdio.h>
#include "miniC.tab.h"
int errores = 0;
char msg = '\0';
void error_lexico();

%}

digito              						[0-9]
letra               						[a-zA-Z]
entero              						{digito}+
comentarioMulti							"/*"([^*]|\*+[^*/])*\*+"/"
comentarioLinea							"//".*\n
espacioTab							[ \n\t\r]+
MODOPANICO							[^0-9a-zA-Z_ \t\n\r;:\?{}()=+\-*/,"]+

%option yylineno

%%
	
{comentarioMulti}						;
{comentarioLinea}						;
{espacioTab}							;

var								{return VAR; }
const								{return CONST; }
int								{return INT; }
if								{return IF; }
else								{return ELSE; }
while                 						{return WHILE; }
print                 						{return PRINT; }
read                  						{return READ; }
";"             						{return PUNTOYCOMA; }
","         							{return COMA; }
"+"             						{return MAS; }
"-"             						{return MENOS; }
"*"             						{return ASTERISCO; }
"/"             						{return BARRA; }
"="              						{return IGUAL; }
"("             						{return PARENTESISI; }
")"             						{return PARENTESISD; }
"{"             						{return LLAVEI; }
"}"             						{return LLAVED; }
"?"             						{return INTERROGACION; }
":"			        				{return DOSPUNTOS; }

_|{letra}({letra}|{digito}|_)* 					{yylval.lexema=strdup(yytext);if (yyleng >= 32) printf("Error: Identificador demasiado largo en linea %d: (%s)\n", yylineno, yytext); return ID;  }

{entero} 							{yylval.lexema=strdup(yytext);if (atoll(yytext) > 2147483647) printf("Error: Número fuera de rango en linea %d: (%s)\n", yylineno, yytext); return ENTERO; }

\"([^"\n\\]|\\["\\tnr])*\"					{yylval.lexema=strdup(yytext);return CADENA; }

{MODOPANICO} 							{{error_lexico("Caracter invalido.");}}
%%

void error_lexico(char *msg)
{
	printf("Error en linea %d - %s %s\n",yylineno, yytext,msg);
	errores++;
}
