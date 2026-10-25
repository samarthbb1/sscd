#1a
%{
int cc=0,wc=0,sc=0,lc=0;
%}
%%
[ ]{sc++;cc++;}
[ ^ \t\n ]+ 
{wc++;cc+=yyleng;}
[ \n ] {lc++;cc++;}
[ \t ] {sc+=8;cc++;}
%%
int main()
{
char fname[20];
printf(“Enter a filename:\n”); 
scanf(“%s”,fname);
yyin=fopen(fname,"r"); 
yylex();
fclose(yyin);
printf("The no.of characters = %d\n",cc); 
printf("The no.of spaces = %d\n",sc); 
printf("The no.of words = %d\n",wc);
}

#1b
%{
#include <stdio.h>
int com = 0;
%}
%%
"/\\*"([^*]|\\*+[^*/])*"\\*/" { com++; fprintf(yyout, " "); }
.|\n { }
%%
int main()
{
 printf("write a c program\n");
 yyout = fopen("output", "w");
 yylex();
 printf("comment=%d\n", com);
 fclose(yyout);
 return 0;
}