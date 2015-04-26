/**	SCC0217 - LINGUAGENS DE PROGRAMAÇÃO E COMPILADORES
	*	1º TRABALHO PRÁTICO - ANALISADOR LÉXICO DA LALG (PASCAL SIMPLIFICADO)
	*
	*	UNIVERSIDADE DE SÃO PAULO
	*	INSTITUTO DE CIÊNCIAS MATEMÁTICAS E DE COMPUTAÇÃO
	*
  *	ALUNOS:
	*		José Victor Uliana Martins - 7656620
	*		Vinicius Marchesin - XXXXXXX
	*		Vitor Barbosa Novello -	7656425
  *
	*	PROFESSOR: Diego Raphael Amancio
	*
	*	SÃO CARLOS - ABRIL/2015
	*
	**/





%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define HASH_MAX_INDEX 9973 
	#define OK 1	


	// Arquivo de saída
	FILE *output_file;


	// Tabela para as palavras reservadas
	char *reserved_word_table[HASH_MAX_INDEX];


	/** Função Hash **/
	int h(char* strkey){
		int i, value, size = strlen(strkey);
		for(i=0, value=0; i<size; i++){
			value += (int)strkey[i]*(strkey[i]-i)*(strkey[i]-i);
		}
		value %= HASH_MAX_INDEX;
		return value;
	}


%}



SPACE [\ \r\t\n]
INVALID ["'!@#$%¨&~]



%%



	/*** COMENTÁRIOS ***/

	/* Ignorar*/
\{(.|{SPACE})*\} {
	return OK; // Ignora Comentários
}

	/* Comentário não fechado */
	/* FALTANDO!!! */
	/*<comment><<EOF>> {
	printf("%s - ERRO: Comentario nao fechado", yytext);
	return OK; // Ignora Comentários
}*/





	/*** IDENTIFICADORES E PALAVRAS RESERVADAS ***/

	/* Erros de IDs mal-formados: <alpha><invalidez> */
[[:alpha:]](([[:alnum:]]|\_)*{INVALID})+([[:alnum:]]|\_)* {
	printf("%s - ERRO: Identificador mal-formado\n", yytext);
	fprintf(output_file, "%s - ERRO: Identificador mal-formado\n", yytext);	
	return OK;
}

	/* Erros de IDs mal-formados: <invalidez><alpha> */
([[:digit:]]|{INVALID})+[[:alpha:]]([[:alnum:]]|{INVALID})* {
	printf("%s - ERRO: Identificador mal-formado\n", yytext);	
	fprintf(output_file, "%s - ERRO: Identificador mal-formado\n", yytext);	
	return OK;
}

	/* Palavras reservadas, IDs corretos e IDs longos */
[[:alpha:]]([[:alnum:]]|\_)* {
	if(strlen(yytext) >= 10){
		printf("%s - ERRO: Identificador longo\n", yytext);
		fprintf(output_file,"%s - ERRO: Identificador longo\n", yytext);
		return OK;
	}
	else {		
		int hash_num = h(yytext);
		if (reserved_word_table[hash_num] == NULL){
			printf("%s - ID\n", yytext);	// ID
			fprintf(output_file, "%s - ID\n", yytext);	// ID
			return OK;
		}
		else{
			printf("%s - %s\n", yytext, reserved_word_table[hash_num]);	// Palavra reservada
			fprintf(output_file, "%s - %s\n", yytext, reserved_word_table[hash_num]);	// Palavra reservada
			return OK;
		}
	}
}






	/*** ELIMINA ESPACAMENTOS ***/

{SPACE}+ return OK;







	/*** NÚMEROS INTEIROS E REAIS ***/

	/* Real correto */
[[:digit:]]+(\.)[[:digit:]]+ {
	printf("%s - numero_real\n", yytext);
	fprintf(output_file, "%s - numero_real\n", yytext);
	return OK;
}

	/* Inteiros corretos e inteiros longos */
[[:digit:]]+ {
	if(strlen(yytext) >= 10){
		printf("%s - ERRO: numero inteiro longo\n", yytext);
		fprintf(output_file, "%s - ERRO: numero inteiro longo\n", yytext);
	} else {
		printf("%s - numero_inteiro\n", yytext);
		fprintf(output_file, "%s - numero_inteiro\n", yytext);
	}
	return OK;
}

	/* Real mal-formado */
([[:digit:]]|{INVALID})+(\.)([[:alnum:]]|{INVALID}|\.)* {
	printf("%s - ERRO: Real mal-formado\n", yytext);
	fprintf(output_file, "%s - ERRO: Real mal-formado\n", yytext);
	return OK;
}
	/* Inteiro mal-formado */
[[:digit:]]([[:digit:]]|{INVALID})+ {
	printf("%s - ERRO: Inteiro mal-formado\n", yytext);
	fprintf(output_file,"%s - ERRO: Inteiro mal-formado\n", yytext);
	return OK;
}







	/*** OPERADORES ARITMETICOS ***/

\+ {
	printf("%s - simb_adicao\n", yytext);
	fprintf(output_file, "%s - simb_adicao\n", yytext);
	return OK;
}

\- {
	printf("%s - simb_subtracao\n", yytext);
	fprintf(output_file,"%s - simb_subtracao\n", yytext);
	return OK;
}

\* {
	printf("%s - simb_multiplicacao\n", yytext);
	fprintf(output_file, "%s - simb_multiplicacao\n", yytext);
	return OK;
}

\/ {
	printf("%s - simb_divisao\n", yytext);
	fprintf(output_file, "%s - simb_divisao\n", yytext);
	return OK;
}



	/*** OPERADORES RELACIONAIS ***/
>= {
	printf("%s - simb_maior_igual\n", yytext);
	fprintf(output_file, "%s - simb_maior_igual\n", yytext);
	return OK;
}

> {
	printf("%s - simb_maior\n", yytext);
	fprintf(output_file, "%s - simb_maior\n", yytext);
	return OK;
}

\<> {
	printf("%s - simb_diferente\n", yytext);
	fprintf(output_file, "%s - simb_diferente\n", yytext);
	return OK;
}

= {
	printf("%s - simb_igual\n", yytext);
	fprintf(output_file, "%s - simb_igual\n", yytext);
	return OK;
}

\<= {
	printf("%s - simb_menor_igual\n", yytext);
	fprintf(output_file, "%s - simb_menor_igual\n", yytext);
	return OK;
}

\< {
	printf("%s - simb_menor\n", yytext);
	fprintf(output_file, "%s - simb_menor\n", yytext);
	return OK;
}





	/*** ATRIBUIÇÃO ***/
:= {
	printf("%s - simb_atribuicao\n", yytext);
	fprintf(output_file, "%s - simb_atribuicao\n", yytext);
	return OK;
}



	/*** TOKENS DE MARCAÇÃO ***/
\( {
	printf("%s - simb_abre_parenteses\n", yytext);
	fprintf(output_file, "%s - simb_abre_parenteses\n", yytext);
	return OK;
}

\) {
	printf("%s - simb_fecha_parenteses\n", yytext);
	fprintf(output_file, "%s - simb_fecha_parenteses\n", yytext);
	return OK;
}

\, {
	printf("%s - simb_virgula\n", yytext);
	fprintf(output_file, "%s - simb_virgula\n", yytext);
	return OK;
}

\; {
	printf("%s - simb_ponto_virgula\n", yytext);
	fprintf(output_file, "%s - simb_ponto_virgula\n", yytext);
	return OK;
}

\: {
	printf("%s - simb_dois_pontos\n", yytext);
	fprintf(output_file, "%s - simb_dois_pontos\n", yytext);
	return OK;
}

\. {
	printf("%s - simb_ponto\n", yytext);
	fprintf(output_file, "%s - simb_ponto\n", yytext);
	return OK;
}





	/*** CARACTERES INVÁLIDOS ***/

[[:^alnum:]] {
	printf("%s - ERRO: simbolo inválido\n", yytext);
	fprintf(output_file, "%s - ERRO: simbolo inválido\n", yytext);
	return OK;
}


%%


// Retornar falso ao encontrar final de arquivo e termina o scan
int yywrap(void){
	return OK;
}

int lexicalAnalyzer(){
	return yylex();
}

int main(int argc, char* argv[]){
	int i;
	output_file = fopen("lalg-al-out.txt", "w");
  if(output_file == NULL) return -1;

	// Inicializando tabela Hash de palavras reservadas
	for(i=0; i<HASH_MAX_INDEX; i++){
		reserved_word_table[i] = NULL;
	}
	reserved_word_table[9340] =	"program";
	reserved_word_table[3463] = "procedure";
	reserved_word_table[4693] = "begin";
	reserved_word_table[6521] =	"end";
	reserved_word_table[1680] = "const";
	reserved_word_table[7719] =	"var";
	reserved_word_table[4311] = "integer";
	reserved_word_table[8] = "real";
	reserved_word_table[9506] =	"read";
	reserved_word_table[4373] = "write";
	reserved_word_table[9784] = "while";
	reserved_word_table[9418] =	"do";
	reserved_word_table[4067] =	"if";
	reserved_word_table[6807] = "then";
	reserved_word_table[7949] =	"else";
	// Obs: os valores destas chaves foram previamente calculados e definidos

	while(lexicalAnalyzer());
	fclose(output_file);

	return 0;
}
