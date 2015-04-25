%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	#define RESERVED 15
	#define ID -1
	#define ERROR -2
	
/*	
	enum{
		PROGRAM=1,
		PROCEDURE,
		BEGIN2,	// a definicao 'BEGIN' já foi definida em lex.yy.c
		END,
		CONST,
		VAR,
		INTEGER,
		REAL,
		READ,
		WRITE,
		WHILE,
		DO,
		IF,
		THEN,
		ELSE
	};
*/
	char *reservedWordTable[]={
		"begin",	
		"const",
		"do",
		"else",
		"end",
		"if",
		"integer",
		"procedure",
		"program",
		"read",
		"real",
		"then",
		"var",
		"while",
		"write"
	};


int binarySearch(char** list, char* str_key){
	int init=0, end=RESERVED, current;

	while(init <= end){
		current = init + (end-init)/2;
		if (!strcmp(str_key, list[current])){
			return current;
		}
		else if(strcmp(str_key, list[current]) < 0){
			end = current-1;
		}
		else if(strcmp(str_key, list[current]) > 0){
			init = current+1;
		}
	}	
	return -1;	// Nao encontrou
}

%}

LETTER [A-Za-z]
DIGIT [0-9]
ALPHANUM [A-Za-z0-9]
OTHERS [\{\}\+\-\*\/]
SPACE [\ \r\t\n]
INVALID ["'!@#$%¨&~]

%%

\{(.|{SPACE})*\} {
	return 1; // Ignora Comentários
}

	/* Comentário não fechado */
	/* FALTANDO!!! */
	/*<comment><<EOF>> {
	printf("%s - ERRO: Comentario nao fechado", yytext);
	return 1; // Ignora Comentários
}*/

	/*** IDENTIFICADORES E PALAVRAS RESERVADAS ***/

	/* Erros de IDs mal-formados: <alpha><invalidez> */
[[:alpha:]](([[:alnum:]]|\_)*{INVALID})+([[:alnum:]]|\_)* {
	printf("%s - ERRO: Identificador mal-formado\n", yytext);	
	return 1;
}

	/* Erros de IDs mal-formados: <invalidez><alpha> */
([[:digit:]]|{INVALID})+[[:alpha:]]([[:alnum:]]|{INVALID})* {
	printf("%s - ERRO: Identificador mal-formado\n", yytext);	
	return 1;
}

	/* Palavras reservadas, IDs corretos e IDs longos*/
[[:alpha:]]([[:alnum:]]|\_)* {
	if(strlen(yytext) >= 10){
		printf("%s - ERRO: Identificador longo\n", yytext);
		return ERROR;
	}
	else {		
		int index = binarySearch(reservedWordTable, yytext);
		if (index == -1){
			printf("%s - ID\n", yytext);	// ID
			return 1;
		}
		else{
			printf("%s - %s\n", yytext, reservedWordTable[index]);	// Palavra reservada
			return 1;
		}
	}
}
	/**-----------------------------------------**/





	/*** ELIMINA ESPACAMENTOS ***/

{SPACE}+ return 1;

	/* ------------------------ */


	/*** NÚMEROS INTEIROS E REAIS ***/

	/* Real correto */
[[:digit:]]+(\.)[[:digit:]]+ {
	printf("%s - numero_real\n", yytext);
	return 1;
}

	/* Inteiros corretos e inteiros longos */
[[:digit:]]+ {
	if(strlen(yytext) >= 10){
		printf("%s - ERRO: numero inteiro longo\n", yytext);
	} else {
		printf("%s - numero_inteiro\n", yytext);
	}
	return 1;
}

	/* Real mal-formado */
([[:digit:]]|{INVALID})+(\.)([[:alnum:]]|{INVALID}|\.)* {
	printf("%s - ERRO: Real mal-formado\n", yytext);
	return 1;
}
	/* Inteiro mal-formado */
([[:digit:]]|{INVALID})+ {
	printf("%s - ERRO: Inteiro mal-formado\n", yytext);
	return 1;
}

	/* ---------------------------- */


	/*** OPERADORES ARITMETICOS ***/
\+ {
	printf("%s - simb_adicao\n", yytext);
	return 1;
}

\- {
	printf("%s - simb_subtracao\n", yytext);
	return 1;
}

\* {
	printf("%s - simb_multiplicacao\n", yytext);
	return 1;
}

\/ {
	printf("%s - simb_divisao\n", yytext);
	return 1;
}



	/* Operadores Relacionais*/
>= {
	printf("%s - simb_maior_igual\n", yytext);
	return 1;
}

> {
	printf("%s - simb_maior\n", yytext);
	return 1;
}

\<> {
	printf("%s - simb_diferente\n", yytext);
	return 1;
}

= {
	printf("%s - simb_igual\n", yytext);
	return 1;
}

\<= {
	printf("%s - simb_menor_igual\n", yytext);
	return 1;
}

\< {
	printf("%s - simb_menor\n", yytext);
	return 1;
}





	/* Atribuicao*/
:= {
	printf("%s - simb_atribuicao\n", yytext);
	return 1;
}



	/* Tokens de marcacao*/
\( {
	printf("%s - simb_abre_parenteses\n", yytext);
	return 1;
}

\) {
	printf("%s - simb_fecha_parenteses\n", yytext);
	return 1;
}

\, {
	printf("%s - simb_virgula\n", yytext);
	return 1;
}

\; {
	printf("%s - simb_ponto_virgula\n", yytext);
	return 1;
}

\: {
	printf("%s - simb_dois_pontos\n", yytext);
	return 1;
}

\. {
	printf("%s - simb_ponto\n", yytext);
	return 1;
}


	/* Caracteres inválidos*/
[[:^alnum:]] {
	printf("%s - ERRO: simbolo inválido\n", yytext);
	return 1;
}

%%

// if(EOF) yylex() return false;
int yywrap(void){
	return 1;
}


void lexicalAnalyzer(){	

	int running;
	char* table[RESERVED];

	running = 1;
	while(running){
		running = yylex();
		if(running == ID){
				//Implementar um Hash
		}
	}
}

int main(int argc, char* argv[]){
	lexicalAnalyzer();
	return 0;
}
