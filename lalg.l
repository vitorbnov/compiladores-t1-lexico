%{
#include "ids.h"
char c;
%}

LETTER [A-Za-z]
SPACE [\ \t\n]
DIGIT [0-9]

%%

\{(.|{SPACE})*\} return 1; // Ignora Comentários
{LETTER}({LETTER}|{DIGIT}|\_)* return ID;
{SPACE} return 1;
{DIGIT}+\.{DIGIT}+ return 1;
{DIGIT}+ return 1;


(\+|\-|\*|\/) {	// operadores aritmeticos
	c = yytext[0];

	switch(c){
		case '+':
			printf("%s - simb_adicao\n", yytext);
			break;
		case '-':
			printf("%s - simb_subtracao\n", yytext);
			break;
		case '*':
			printf("%s - simb_multiplicacao\n", yytext);
			break;
		case '/':
			printf("%s - simb_divisao\n", yytext);
			break;
	}
	return 1;
}

(>|>=|<|<=|=|<>) { // operadores relacionais
	c = yytext[0];

	switch(c){
		case '<':
			c = yytext[1];
			if(c == '='){
				printf("%s - simb_menor_igual\n", yytext);
			}
			else if(c == '>'){
				 printf("%s - simb_diferente\n", yytext);
			}
			else{
				printf("%s - simb_menor\n", yytext);
			}
			break;
		case '>':
			c = yytext[1];
			if(c == '='){
				printf("%s - simb_maior_igual\n", yytext);
			}
			else{
				printf("%s - simb_maior\n", yytext);
			}
			break;
		default:
			printf("%s - simb_igual\n", yytext);
			break;
		printf("%s - simb_relational_op\n", yytext);
	}
	return 1;
}

:= {
	printf("%s - simb_atribuicao\n", yytext);
	return 1;
}

(\(|\)|\,|\;|\:|\.) {
	c = yytext[0];

	switch(c){
		case '(':
			printf("%s - simb_abre_parenteses\n", yytext);
			break;
		case ')':
			printf("%s - simb_fecha_parenteses\n", yytext);
			break;
		case ',':
			printf("%s - simb_virgula\n", yytext);
			break;
		case ';':
			printf("%s - simb_ponto_virgula\n", yytext);
			break;
		case ':':
			printf("%s - simb_dois_pontos\n", yytext);
			break;
		case '.':
			printf("%s - simb_ponto\n", yytext);
			break;
	}
	return 1;
}

[^{LETTER}{NUMBER}] {
	printf("%s - ERRO\n", yytext);
	return 1;
}

%%

// if(EOF) yylex() return false;
int yywrap(void){
	return 1;
}

int main(int argc, char* argv[]){
	
	int token;
	char* table[NUM_PALAVRAS];

	table[0] = "program";
	table[1] = "procedure";
	table[2] = "begin";
	table[3] = "end";
	table[4] = "var";
	table[5] = "integer";
	table[6] = "real";
	table[7] = "read";
	table[8] = "write";
	table[9] = "do";
	table[10] = "while";
	table[11] = "if";
	table[12] = "then";
	table[13] = "else";

	token = 1;
	while(token){
		token = yylex();
		if(token == ID){
			printf("%s eh um ID?\n", yytext);
				//Implementar um Hash
		}
	}

	return 0;
}
