char [a-zA-Z]
digit [0-9]
special [$_@]
header   hash[' ']LT[' ']stdio.h[' ']GT

%{
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>
	#include "project.tab.h"
	#include<math.h>
	extern YYSTYPE yylval;
	
%}


%%

"var"         { return VAR;}
"INT MAIN"	  { return INTMAIN; }
"IF"		  { return IF; }
"ELSE"		  { return ELSE; }
"ELSEIF"      { return ELSEIF; }
"WHILE"       {return WHILE;} 
"GHORO"       {return FOR;}
"SWITCH"      { return SWITCH; }
"CASE"        { return CASE; }
"DEFAULT"     { return DEFAULT; }
":"           { return COL;}
"LB"          {return LEFT_BRAC;}
"RB"          {return RIGHT_BRAC;}
"LP"          {return LEFT_PARENTHESIS;}
"RP"          {return RIGHT_PARENTHESIS;}
"sm"          {return SEMI;}
"cm"          {return COMMA;}
jog           {return PLUS;}
biyog         {return MINUS;}
gon           {return MULT;}
vag           {return DIV;}
[<][-]        {return ASSIGN;}
"LT"          {return LESS;}
"GT"          {return GREATER;}
"GTE"         {return GE; }
"LTE"         {return LE; }
"NE"          {return NE; }
"="           { return EQUAL;}
"POW"         {return POWER; }
"SIN"         { return SIN; }
"COS"         { return COS; }
"TAN"         { return TAN; }
"LOG"         { return LOG; }
"FACT"        { return FACTORIAL; }
"SQRT"        { return SQRT; }
"SQR"         { return SQR; }
"CUBE"        { return CUBE; }
{header}      { return HEADER;}
"PRINT"       { return PRINT;}
"\""(.)*"\""  {strcpy(yylval.text,yytext);return STR;}

[ \t\n]* ;

"-"?[0-9]+     {
	yylval.val=atof(yytext);
	return NUMBER;
}
"-"?[0-9]+?"."[0-9]+   {
	yylval.val=atof(yytext);
	return NUMBER;
}
{char}+({char}|{digit}|{special})*  {
	strcpy(yylval.text,yytext);
	return VARIABLE; 
}
"#".*("\n")  {}
"#*".*"\n"(.*"\n")*(.*"*#") {}
.          { yyerror("Unknown charecter\n"); }

%%


int main()
{
	yyin = freopen("input.txt","r",stdin);
	yyout=freopen("out.txt","w",stdout);
	
	yyparse();

}
