%{
#include<stdio.h>
#include<ctype.h>
int yylex(void);
int yyerror(const char *s);
%}
%token letter digit
%%
id: letter other '\n' { printf("Valid\n"); }
 ;
other: other letter
 | other digit
 | /*empty*/
 ;
%%
int main()
{
 yyparse();
 return 0;
}
int yyerror(const char *s)
{
 printf("Error\n");
 return 0;
}
int yylex(void)
{
 int c;
 while((c=getchar())==' ' || c=='\t');
 if(isalpha(c)) return letter;
 if(isdigit(c)) return digit;
 return c;
}