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

"INT"	{ return INT; }
"FLOAT"	{ return FLOAT; }
"CHAR"	{ return CHAR; }
"DOUBLE" { return DOUBLE; }




"INT MAIN"	    { return INTMAIN; }
"VOID MAIN"	    { return VOIDMAIN; }
"IF"		    { return IF; }
"ELSE"		    { return ELSE; }
"ELSEIF"        { return ELSEIF; }
"WHILE"         {return WHILE;} 
"FORLOOP"       {return FOR;}
"SWITCH "       { return SWITCH; }
"CASE"          { return CASE; }
"DEFAULT"      { return DEFAULT; }
"COLON"        {return COLON;}
":"           { return COL;}
"FUNCTION"    {return FUNCTION;}
"RET"         {return RET;}
[+]           { return *yytext; }
"LB"          {return LEFT_BRAC;}
"RB"          {return RIGHT_BRAC;}
"LP"          {return LEFT_PARENTHESIS;}
"RP"          {return RIGHT_PARENTHESIS;}
"ABS"		  {return ABS;}
"ABF"         {return ABF;}
"sm"          {return SEMI;}
"cm"          {return COMMA;}
jog          {return PLUS;}
biyog          {return MINUS;}
gon          {return MULT;}
vag          {return DIV;}
[<][-]          {return ASSIGN;}
[=]             { return *yytext; }
"equal"          {return EQUAL;}
"LT"            {return LESS;}
"GT"            {return GREATER;}
"GTE"           {return GE; }
"LTE"           {return LE; }
"NE"            {return NE; }
"POW"           {return POWER; }
"SIN"         { return SIN; }
"COS"         { return COS; }
"TAN"         { return TAN; }
"LOG"         { return LOG; }
"FACT"        { return FACTORIAL; }
"SQRT"          { return SQRT; }
"SQR"           { return SQR; }
"CUBE"          { return CUBE; }
{header}        { return HEADER;}
"PRINT"         { return PRINT;}

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

.          { yyerror("Unknown charecter\n"); }

%%


int main()
{
	yyin = freopen("input.txt","r",stdin);
	
	yyparse();

}
