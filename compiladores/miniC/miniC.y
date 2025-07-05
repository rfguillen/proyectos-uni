%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "listaSimbolos.h"


Lista tablaSimb;
int contCadenas=0;
int contCadenasUsadas = 0;
char registros[10];


extern int errores;
int contadorEtiquetas = 1;

int perteneceTablaS(Lista l, char *nombre);
void insertaTablaIdentificador(Lista l, char *nombre, Tipo tipo);
extern char *yytext;
extern int yylineno;
extern int yylex();


int analisis_ok();
void iniciaRegistros();
char* queRegistro();
void liberaRegistro(char* registro);
char* concatenar(char* cad1, char* cad2);
char* queStr();
char *obtenerEtiqueta();
void yyerror();
void errorSem();
void main();
%}

%code requires{
#include "listaCodigo.h"
}

%token VAR CONST INT IF ELSE WHILE PRINT READ PUNTOYCOMA COMA IGUAL PARENTESISI PARENTESISD LLAVEI LLAVED INTERROGACION DOSPUNTOS

%left MAS MENOS 
%left ASTERISCO BARRA
%left UMENOS

%expect 1
// La gramatica genera un conflicto S/R con las sentencias if y if-else
// Bison por defecto desplaza, asociando el else con el if mas cercano
// Esto es lo que queremos y es por eso que ponemos el %expect 1, para evitar un warning

%union{
char *lexema;
ListaC codigo;
}
%type <codigo> expression statement statement_list declarations var_list const_list print_list print_item read_list

/* Solo se puede 1 union por .y
%union{
    char *lexema;
}
*/
%token <lexema> ID ENTERO CADENA
%%

program: {  
            tablaSimb = creaLS(); 
            //printf("Creado tablaSimb \n");
            extern int errores;
         } 
            ID PARENTESISI PARENTESISD LLAVEI declarations statement_list LLAVED {
            if(errores == 0){
                imprimirTablaLS(tablaSimb); 
                concatenaLC($6, $7);
                imprimirLC($6);
                liberaLC($7);
                liberaLC($6);
                liberaLS(tablaSimb); 
                //printf("Final Exitoso \n");
                }; 
            }
    ;
declarations: declarations VAR tipo var_list PUNTOYCOMA {
                                                        if(analisis_ok){
                                                            $$ = $1;
                                                            concatenaLC($$, $4);
                                                            liberaLC($4);
                                                        }
                                                        }
    | declarations CONST tipo const_list PUNTOYCOMA     {
                                                        if(analisis_ok){
                                                            $$ = $1;
                                                            concatenaLC($$, $4);
                                                            liberaLC($4);
                                                        }
                                                        }
    | /*LAMBDA*/                                        {$$ = creaLC();}
    ;
tipo: INT
    ;
var_list: ID    {
                //printf("Comprobando que  \" %s \" pertenece a la tabla \n", $1);
                if (perteneceTablaS(tablaSimb, $1) == 0){
                    //printf("No pertenece, procedo a insertar \n");
                    insertaTablaIdentificador(tablaSimb, $1,VARIABLE);
                    //printf("Insertado \n");                   
                } 
                else {
                    errores++;
                    errorSem();
                    printf("Variable %s ya declarada \n",$1);
                }
                $$ = creaLC();
                }
    | var_list COMA ID  {
                        if (perteneceTablaS(tablaSimb, $3) == 0) {
                            insertaTablaIdentificador(tablaSimb, $3,VARIABLE);
                        }
                        else {
                            errores++;
                            errorSem();
                            printf("Variable %s ya declarada \n",$3);
                        }
                        $$ = $1;
                        }
    ;
const_list: ID IGUAL expression             {
                                            if (perteneceTablaS(tablaSimb, $1) == 0) {
                                                insertaTablaIdentificador(tablaSimb, $1,CONSTANTE);
                                            }
                                            else {
                                                errores++;
                                                errorSem();
                                                printf("Constante %s ya declarada \n",$1);
                                            }
                                            if(analisis_ok){
                                                $$ = creaLC();
                                                concatenaLC($$, $3);

                                                Operacion operacion;
                                                operacion.op = "sw";
                                                operacion.res = recuperaResLC($3);
                                                operacion.arg1 = concatenar("_", $1);
                                                operacion.arg2 = NULL;

                                                insertaLC($$, finalLC($$), operacion);
                                                liberaRegistro(operacion.res);
                                            }
                                            }
    | const_list COMA ID IGUAL expression   {
                                            if (perteneceTablaS(tablaSimb, $3) == 0) {
                                                insertaTablaIdentificador(tablaSimb, $3,CONSTANTE);
                                            }
                                            else {
                                                errores++;
                                                errorSem();
                                                printf("Constante %s ya declarada \n",$3);
                                            }
                                            if(analisis_ok){
                                                $$ = $1;
                                                concatenaLC($$, $5);			

                                                Operacion operacion;
                                                operacion.op = "sw";
                                                operacion.res = recuperaResLC($5);
                                                operacion.arg1 = concatenar("_", $3);
                                                operacion.arg2 = NULL;

                                                insertaLC($$, finalLC($$), operacion);
                                                concatenaLC($$, $5);
						liberaLC($5);
                                                liberaRegistro(operacion.res);
                                            }
                                            }
    ;
statement_list: statement_list statement {
                                         $$ = $1;
                                         concatenaLC($$, $2);
                                         liberaLC($2);
                                         }
    | /*LAMBDA*/                         {
                                         $$ = creaLC();
                                         }   
    ;
statement: ID IGUAL expression PUNTOYCOMA {
                                         if (perteneceTablaS(tablaSimb, $1) == 0){

                                            errores++;
                                            errorSem();
                                            printf("Variable %s no declarada \n",$1);
                                            
                                         }
                                         else if (esConstante(tablaSimb, $1) == 1){
                                            errores++;
                                            errorSem();
                                            printf("Asignación a constante\n");
                                            
                                         }
                                         if(analisis_ok){
                                            $$ = $3;

                                            Operacion operacion;
                                            operacion.op = "sw";
                                            operacion.res = recuperaResLC($3);
                                            operacion.arg1 = concatenar("_", $1);
                                            operacion.arg2 = NULL;

                                            insertaLC($$, finalLC($$), operacion);
                                            liberaRegistro(operacion.res);
                                         }
                                         }
    | LLAVEI statement_list LLAVED  {$$ = $2;}
    | IF PARENTESISI expression PARENTESISD statement ELSE statement    {
                                                            if(analisis_ok){
                                                                $$ = $3;

                                                                char* etqElse = obtenerEtiqueta();
                                                                char* etqFinIf = obtenerEtiqueta();
                                                                

                                                                Operacion operacion;
                                                                operacion.op = "beqz";
                                                                operacion.res = recuperaResLC($3);
                                                                operacion.arg1 = etqElse;
                                                                operacion.arg2 = NULL;

                                                                insertaLC($$, finalLC($$), operacion);
                                                                concatenaLC($$, $5);

                                                                operacion.op = "b";
                                                                operacion.res = etqFinIf;
                                                                operacion.arg1 = NULL;
                                                                operacion.arg2 = NULL;

                                                                insertaLC($$, finalLC($$), operacion);

                                                                operacion.op = concatenar(etqElse, ":");
                                                                operacion.res = NULL;
                                                                operacion.arg1 = NULL;
                                                                operacion.arg2 = NULL;

                                                                insertaLC($$, finalLC($$), operacion);
                                                                concatenaLC($$, $7);

                                                                liberaLC($7);

                                                                operacion.op = concatenar(etqFinIf, ":");
                                                                operacion.res = NULL;
                                                                operacion.arg1 = NULL;
                                                                operacion.arg2 = NULL;

                                                                insertaLC($$, finalLC($$), operacion);
                                                                liberaRegistro(recuperaResLC($3));
                                                                liberaLC($5);
                                                            }
                                                            }
    | IF PARENTESISI expression PARENTESISD statement        {
                                                if(analisis_ok){
                                                    $$ = $3;

                                                    char* etqFinIf = obtenerEtiqueta();
                                                
                                                    Operacion operacion;
                                                    operacion.op = "beqz";
                                                    operacion.res = recuperaResLC($3);
                                                    operacion.arg1 = etqFinIf;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);
                                                    concatenaLC($$, $5);

                                                    operacion.op = concatenar(etqFinIf, ":");
                                                    operacion.res = NULL;
                                                    operacion.arg1 = NULL;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);

                                                    liberaRegistro(recuperaResLC($3));
                                                    liberaLC($5);
                                                }
                                                }
    | WHILE PARENTESISI expression PARENTESISD statement     {
                                                if(analisis_ok){
                                                    $$ = creaLC();
                                                
                                                    char* etqWhile = obtenerEtiqueta();
                                                    char* etqFinWhile = obtenerEtiqueta();

                                                    Operacion operacion;
                                                    operacion.op = concatenar(etqWhile, ":");
                                                    operacion.res = NULL;
                                                    operacion.arg1 = NULL;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);                                       
                                                    concatenaLC($$, $3);

                                                    operacion.op = "beqz";
                                                    operacion.res = recuperaResLC($3);
                                                    operacion.arg1 = etqFinWhile;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);
                                                    concatenaLC($$, $5);

                                                    operacion.op = "b";
                                                    operacion.res = etqWhile;
                                                    operacion.arg1 = NULL;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);


                                                    operacion.op = concatenar(etqFinWhile, ":");
                                                    operacion.res = NULL;
                                                    operacion.arg1 = NULL;
                                                    operacion.arg2 = NULL;

                                                    insertaLC($$, finalLC($$), operacion);


                                                    liberaRegistro(recuperaResLC($3));
                                                    liberaLC($3);
                                                    liberaLC($5);                                    
                                                }
                                                }
    | PRINT PARENTESISI print_list PARENTESISD PUNTOYCOMA     {$$ = $3;}
    | READ PARENTESISI read_list PARENTESISD PUNTOYCOMA       {$$ = $3;}
    ;
print_list: print_item              {$$ = $1;}
    | print_list COMA print_item    {
                                    if(analisis_ok){
                                        $$ = $1;
                                        concatenaLC($$,$3);
                                        liberaLC($3);
                                    }
                                    }
    ;
print_item: expression {
                        if(analisis_ok){
                            $$ = $1;

                            Operacion operacion;
                            operacion.op = "li";
                            operacion.res = "$v0";
                            operacion.arg1 = "1";
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$),operacion);

                            operacion.op = "move";
                            operacion.res = "$a0";
                            operacion.arg1 = recuperaResLC($1);
                            operacion.arg2 = NULL;

                            liberaRegistro(operacion.arg1);
                            insertaLC($$,finalLC($$), operacion);

                            operacion.op = "syscall";
                            operacion.res = NULL;
                            operacion.arg1 = NULL;
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$),operacion);
                        }
                        }
            | CADENA    {
                        int idxCadena = contCadenas++;

                        insertaTablaString(tablaSimb, $1,CADNA, idxCadena);

                        
                        if(analisis_ok){
                            $$ = creaLC();


                            Operacion operacion;
                            operacion.op = "la";
                            operacion.res = "$a0";                       
                            operacion.arg1 = queStr();
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$),operacion);

                            operacion.op = "li";
                            operacion.res = "$v0";
                            operacion.arg1 = "4";
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$), operacion);

                            operacion.op = "syscall";
                            operacion.res = NULL;
                            operacion.arg1 = NULL;
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$),operacion);
                            
                        }
                        
                        }
    ;
read_list: ID {if (perteneceTablaS(tablaSimb, $1) == 0) {

                    errores++;
                    errorSem();
                    printf("Variable %s no declarada \n",$1);
               }
               else if (esConstante(tablaSimb, $1) == 1) {
                    errores++;
                    errorSem();
                    printf("Asignación a constante\n");
               }
               if(analisis_ok){
                    $$=creaLC();

                    Operacion operacion;
                    operacion.op = "li";
                    operacion.res = "$v0";
                    operacion.arg1 = "5";
                    operacion.arg2 = NULL;

                    insertaLC($$, finalLC($$), operacion);

                    // Una vez ya insertada le cambiamos los parametros
                    operacion.op = "syscall";
                    operacion.res = NULL;
                    operacion.arg1 = NULL;
                    operacion.arg2 = NULL;

                    insertaLC($$, finalLC($$), operacion);

                    // Una vez ya insertada le cambiamos los parametros
                    operacion.op = "sw";
                    operacion.res = "$v0";
                    operacion.arg1 = concatenar("_",$1);
                    operacion.arg2 = NULL;

                    insertaLC($$,finalLC($$), operacion);
               }
               }
    | read_list COMA ID {
                         if (perteneceTablaS(tablaSimb, $3) == 0) {

                            errores++;
                            errorSem();
                            printf("Variable %s no declarada \n",$3);

                         }
                         else if (esConstante(tablaSimb, $3) == 1) {

                            errores++;
                            errorSem();
                            printf("Asignación a constante\n");
                         }
                         if(analisis_ok){
                            $$=$1;

                            Operacion operacion;
                            operacion.op = "li";
                            operacion.res = "$v0";
                            operacion.arg1 = "5";
                            operacion.arg2 = NULL;

                            insertaLC($$, finalLC($$), operacion);

                            // Una vez ya insertada le cambiamos los parametros
                            operacion.op = "syscall";
                            operacion.res = NULL;
                            operacion.arg1 = NULL;
                            operacion.arg2 = NULL;

                            insertaLC($$, finalLC($$), operacion);

                            operacion.op = "sw";
                            operacion.res = "$v0";
                            operacion.arg1 = concatenar("_",$3);
                            operacion.arg2 = NULL;

                            insertaLC($$,finalLC($$), operacion);
                         }
                         }
    ;
expression: expression MAS expression{
                                    if(analisis_ok){
                                        $$ = $1;

                                        concatenaLC($$,$3);

                                        Operacion operacion;
                                        operacion.op = "add";
                                        operacion.res = queRegistro();
                                        operacion.arg1 = recuperaResLC($1);
                                        operacion.arg2 = recuperaResLC($3);

                                        insertaLC($$, finalLC($$), operacion);
                                        guardaResLC($$, operacion.res);
                                        liberaRegistro(operacion.arg1);
                                        liberaRegistro(operacion.arg2);
                                        liberaLC($3);
                                    }
                                    }
    | expression MENOS expression   {
                                    if(analisis_ok){
                                        $$ = $1;

                                        concatenaLC($$,$3);

                                        Operacion operacion;
                                        operacion.op = "sub";
                                        operacion.res = queRegistro();
                                        operacion.arg1 = recuperaResLC($1);
                                        operacion.arg2 = recuperaResLC($3);

                                        insertaLC($$, finalLC($$), operacion);
                                        guardaResLC($$, operacion.res);
                                        liberaRegistro(operacion.arg1);
                                        liberaRegistro(operacion.arg2);
                                        liberaLC($3);
                                    }
                                    }
    | expression ASTERISCO expression{
                                    if(analisis_ok){
                                        $$ = $1;

                                        concatenaLC($$,$3);

                                        Operacion operacion;
                                        operacion.op = "mul";
                                        operacion.res = queRegistro();
                                        operacion.arg1 = recuperaResLC($1);
                                        operacion.arg2 = recuperaResLC($3);

                                        insertaLC($$, finalLC($$), operacion);
                                        guardaResLC($$, operacion.res);
                                        liberaRegistro(operacion.arg1);
                                        liberaRegistro(operacion.arg2);
                                        liberaLC($3);
                                    }
                                    }
    | expression BARRA expression   {
                                    if(analisis_ok){
                                        $$ = $1;

                                        concatenaLC($$,$3);

                                        Operacion operacion;
                                        operacion.op = "div";
                                        operacion.res = queRegistro();
                                        operacion.arg1 = recuperaResLC($1);
                                        operacion.arg2 = recuperaResLC($3);

                                        insertaLC($$, finalLC($$), operacion);
                                        guardaResLC($$, operacion.res);
                                        liberaRegistro(operacion.arg1);
                                        liberaRegistro(operacion.arg2);
                                        liberaLC($3);
                                    }
                                    }
    | PARENTESISI expression INTERROGACION expression DOSPUNTOS expression PARENTESISD {
                                                                         if(analisis_ok){
                                                                            $$ = $2;
                                                                        
                                                                            char* etqFinIf = obtenerEtiqueta();
                                                                            char* etqElse = obtenerEtiqueta();

                                                                            char * regRes = queRegistro();

                                                                            Operacion operacion;                                                                        
                                                                            operacion.op = "beqz";
                                                                            operacion.res = recuperaResLC($2);
                                                                            operacion.arg1 = etqElse;
                                                                            operacion.arg2 = NULL;                                                                           
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            concatenaLC($$, $4);

                                                                            operacion.op = "move";
                                                                            operacion.res = regRes;
                                                                            operacion.arg1 = recuperaResLC($4);
                                                                            operacion.arg2 = NULL;
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            operacion.op = "b";
                                                                            operacion.res = etqFinIf;
                                                                            operacion.arg1 = NULL;
                                                                            operacion.arg2 = NULL;
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            operacion.op = concatenar(etqElse, ":");
                                                                            operacion.res = NULL;
                                                                            operacion.arg1 = NULL;
                                                                            operacion.arg2 = NULL;
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            concatenaLC($$, $6);


                                                                            operacion.op = "move";
                                                                            operacion.res = regRes;
                                                                            operacion.arg1 = recuperaResLC($6);
                                                                            operacion.arg2 = NULL;
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            operacion.op = concatenar(etqFinIf, ":");
                                                                            operacion.res = NULL;
                                                                            operacion.arg1 = NULL;
                                                                            operacion.arg2 = NULL;
                                                                            insertaLC($$, finalLC($$), operacion);

                                                                            guardaResLC($$, regRes);

                                                                            liberaRegistro(recuperaResLC($2));
                                                                            liberaRegistro(recuperaResLC($4));            
                                                                            liberaRegistro(recuperaResLC($6));

                                                                            //Liberamos despues para poder recuperar el res
                                                                            liberaLC($4);
                                                                            liberaLC($6);
                                                                         }   
                                                                         }
    | MENOS expression %prec UMENOS {
                                    $$ = $2;

                                    Operacion operacion;
                                    operacion.op = "neg";
                                    operacion.res = recuperaResLC($2);
                                    operacion.arg1 = recuperaResLC($2);
                                    operacion.arg2 = NULL;

                                    insertaLC($$, finalLC($$), operacion);
                                    guardaResLC($$, operacion.res);
                                    }
    | PARENTESISI expression PARENTESISD  {
                            $$ = $2; // Subimos la expresion
                            } 
    | ID        {
                 if (perteneceTablaS(tablaSimb, $1) == 0) {
                    errores++;
                    errorSem();
                    printf("Variable %s no declarada \n",$1);
                    }
                if(analisis_ok){
                    $$ = creaLC();

                    Operacion operacion;
                    operacion.op = "lw";
                    operacion.res = queRegistro();
                    operacion.arg1 = concatenar("_",$1);
                    operacion.arg2 = NULL;

                    insertaLC($$, finalLC($$), operacion);
                    guardaResLC($$, operacion.res);
                }
                }
    | ENTERO    {
                if(analisis_ok){
                    $$ = creaLC();

                    Operacion operacion;
                    operacion.op = "li";
                    operacion.res = queRegistro();
                    operacion.arg1 = $1;
                    operacion.arg2 = NULL;

                    insertaLC($$, finalLC($$), operacion);
                    guardaResLC($$, operacion.res);
                }
                }
    ;
%%

int analisis_ok(){
    if (errores == 0){
        return 1;
    }
    else{
        return 0;
    }
}

void yyerror(){
	printf("Error sintactico en linea %d\n", yylineno);
}

void errorSem(){
	printf("Error semantico en caracter %s, linea %d\n", yytext, yylineno);
}

void iniciaRegistros(){
  for(int i = 0; i<10; i++){
    registros[i] = 0;
  }
}

char* queRegistro(){
    for (int i = 0; i < 10; i++){
        if(registros[i] == 0){ // Recorre los registros hasta encontrar uno vacio
            registros[i] = 1; // Al encontrarlo lo marca como lleno
            char aux[32];
            sprintf(aux, "$t%d", i); // Asigna a registro $ti
            return strdup(aux);
        }
    }
    printf("Error: Todos los registros ocupados");
    exit(1);
}

void liberaRegistro(char* registro){
    int num = atoi(&(registro[2])); // La cadena es $tx
    registros[num] = 0; 
}


char* concatenar(char* cad1, char* cad2){
    char aux[64]; // 64 porque las etiquetas tienen 32 y hay 2
    sprintf(aux, "%s%s", cad1,cad2);
    return strdup(aux);
}

char* queStr(){
    char aux[32];
    sprintf(aux, "$str%d", contCadenasUsadas++);
    return strdup(aux);
}

char *obtenerEtiqueta() {
    char aux[32];
    sprintf(aux,"$l%d",contadorEtiquetas++);
    return strdup(aux);
}
