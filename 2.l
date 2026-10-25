#2a
%{
#include <stdio.h>
int opdcount = 0, oprcount = 0;
int i = 0, j = 0, k = 0;
char opd[100], opr[100];
%}
OPERATOR [+\-*/]
OPERANDS [a-zA-Z0-9]+
%%
{OPERATOR} {
 oprcount++;
 opr[i++] = yytext[0];
 opr[i++] = ' ';
 }
{OPERANDS} {
 opdcount++;
 for (j = 0; j < yyleng; j++)
 opd[k++] = yytext[j];
 opd[k++] = ' ';
 }
 \n { }
. { }
%%
int main()
{
 yylex();
 opd[k] = '\0';
 opr[i] = '\0';
 if ((opdcount - oprcount) != 1)
 printf("Not valid expression\n");
 else
 {
 printf("Valid expression\n");
 printf("Operands = %s and count = %d\n", opd, opdcount);
 printf("Operators = %s and count = %d\n", opr, oprcount);
 }
 return 0;
}

#2b
%{
#include <stdio.h>
int count = 0;
%}
LETTER [a-zA-Z]
DIGIT [0-9]
USCORE [_]
%%
({LETTER}|{USCORE})({LETTER}|{DIGIT}|{USCORE})* { count++; }
.|\n { }
%%
int main()
{
 yyin = fopen("ex.txt", "r");
 if (yyin == NULL)
 {
 printf("File not found\n");
 return 1;
 }
 yylex();
 fclose(yyin);
 printf("No of identifiers = %d\n", count);
 return 0;
}