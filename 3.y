%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#define YYSTYPE double
%}
%token num
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
lines : 
 | lines exp '\n' { printf("Result=%g\n", $2); }
 | lines '\n' 
 ;
exp :
exp '+' exp { $$ = $1 + $3; }
 | exp '-' exp { $$ = $1 - $3; }
 | exp '*' exp { $$ = $1 * $3; }
 | exp '/' exp
 {
 if ($3 == 0) 
{
 printf("Divide by zero error\n");
 exit(0);
 }
 $$ = $1 / $3;
 }
 | '(' exp ')' { $$ = $2; }
 | '-' exp %prec UMINUS { $$ = -$2; }
 | num 
 ;
%%
int yylex(void)
{
 int c;
 while ((c = getchar()) == ' ' || c == '\t');
 if (c == '.' || isdigit(c))
{
 ungetc(c, stdin); 
 scanf("%lf", &yylval); 
 return num; 
 }
 return c;
}
int yyerror(const char *s)
{
 printf("Error\n", s);
 return 0;
}
int main(void)
{
 printf("Enter arithmetic expressions:\n");
 yyparse(); 
 return 0;
}