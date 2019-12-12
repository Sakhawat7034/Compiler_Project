%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>

    #define convt 180.0
    #define py  3.1416

    int cnt=0;
	int ch;
    int ptr = 0;
    float val[1000];
    char varlist[1000][1000];

	int ifptr = -1;
	int ifdone[1000];

    
    int isdeclared(char str[]){
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) return 1;
        }
        return 0;
    }
    int newin(char str[],float value){
        if(isdeclared(str) == 1) return 0;
        strcpy(varlist[ptr],str);
        val[ptr] = value;
        ptr++;
        return 1;
    }

    
   float valueout(char str[]){
        int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        return val[indx];
    }
    int valuein(char str[], float value){
    	int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        val[indx] = value;
    }
    
%}

%union {
  char text[1000];
  float val;
}

%type <val> expression 

%token <val>  NUMBER
%token <text>  VARIABLE
%token <text> STR

%nonassoc IFX
%nonassoc ELSE

%token  HEADER  VAR INTMAIN IF ELSE ELSEIF WHILE FOR SWITCH CASE DEFAULT COL LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRAC RIGHT_BRAC SEMI COMMA PLUS MINUS MULT DIV ASSIGN EQUAL LESS GREATER GE LE NE POWER SIN COS TAN LOG FACTORIAL SQRT SQR CUBE DOUBLE PRINT
RET FUNCTION  

%left LT GT
%left PLUS MINUS
%left MULT DIV
%left SQRT SQR CUBE
%left SIN COS TAN LOG
%left FACTORIAL


%%
start: header program
	| program
	;
header: 
	|header HEADER {}
	;
program: INTMAIN LEFT_PARENTHESIS RIGHT_PARENTHESIS  LEFT_BRAC statement RIGHT_BRAC 
	;
statement : /* empty */
	| statement declaration
	| statement print
	| statement ifelse
	| statement expression
	| statement assign
	| statement whilestmt
	| statement forloopstmt
	| statement switch
            ;
declaration : VAR variables SEMI {}
			;
			;
variables	: variable COMMA variables {}
			| variable {}
			;
variable   	: VARIABLE	
					{
						//printf("%s\n",$1);
						int x = newin($1,0);
						if(!x) {
							printf("Compilation Error:Variable %s is already declared\n",$1);
							exit(-1);
						}

					}
			| VARIABLE ASSIGN expression 	
					{
						//printf("%s %f\n",$1,$3);
						int x = newin($1,$3);
						if(!x) {
							printf("Compilation Error: Variable %s is already declared\n",$1);
							exit(-1);
							}
					}

			;

expression :  NUMBER				{ $$ = $1; ch=$$;  	}

	| VARIABLE {
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							$$ = valueout($1);
							ch=$$; 
						}
				 	}
    |  expression EQUAL expression   {$$ = $3 == $1; ch=$$; }   

	| expression PLUS expression	{ $$ = $1 + $3; ch=$$;  }

	| expression MINUS expression	{ $$ = $1 - $3; ch=$$;  }

	| expression MULT expression	{ $$ = $1 * $3; ch=$$;  }

	| expression DIV expression	    { 	
	 									if($3) 
					  					{
					     					$$ = $1 / $3;
											 ch=$$; 
					  					}
								  		else
								  		{
											$$ = 0;
											printf("\ndivision by zero --> undefined\n\t");
											exit(-1);
							  			} 	
							        }
  

	| expression POWER expression   { $$ = pow($1,$3); ch=$$;   }   

	| expression LESS expression	{ $$ = $1 < $3; ch=$$;  }

	| expression GREATER expression	{ $$ = $1 > $3; ch=$$;  }

	| expression LE expression	    { $$ = $1 <= $3; ch=$$;  }

	| expression GE expression	    { $$ = $1 >= $3; ch=$$;  }

    | expression NE expression	    { $$ = $1 != $3; ch=$$;  }

	| LEFT_PARENTHESIS expression RIGHT_PARENTHESIS		{ $$ = $2; ch=$$; 	}

	| SIN LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = sin(($3*py)/convt); ch=$$; 	}

	| COS LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = cos(($3*py)/convt); ch=$$; 	}

	| TAN LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = tan(($3*py)/convt); ch=$$; 	}

	| LOG LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = log($3); ch=$$; 	}

	| SQRT LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = sqrt($3); ch=$$; }

	| SQR LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = $3 * $3; ch=$$; 	}

	| CUBE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = $3 * $3 * $3; ch=$$; 	}

	| expression FACTORIAL {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;
						ch=$$; 
					 }
	;
print	: 	PRINT LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
					{
						/*if(!isdeclared($3)){
							printf("Compilation Error: Variable %s is not declared\n",$3);
							exit(-1);
						}
						else{
							float v = valueout($3);
							printf("%f\n",v);
						}*/
						printf("%.2f\n",$3);
					}
	|PRINT LEFT_PARENTHESIS STR RIGHT_PARENTHESIS{
		printf("%s\n",$3);
	}
					;
			
assign:VARIABLE ASSIGN expression SEMI
					{
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							valuein($1,$3);
						}
					} ;

ifelse : IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_BRAC statement RIGHT_BRAC  {
	
						ifptr++;
						ifdone[ifptr] = 0;
						if($3){
							printf("\nIf executed\n");
							ifdone[ifptr] = 1;
						}
}
elseif
;

elseif : 
	| elseif ELSEIF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_BRAC statement RIGHT_BRAC {
		
						if($4 && ifdone[ifptr] == 0){
							printf("\nElse if block expressin %d executed\n",$4);
							ifdone[ifptr] = 1;
						}
	} 
	| elseif ELSE  LEFT_BRAC statement RIGHT_BRAC{
		
			if(ifdone[ifptr] == 0){
							printf("\nElse block executed\n");
							ifdone[ifptr] = 1;
						}
		
	}
	;

whilestmt : WHILE LEFT_PARENTHESIS expression LESS expression RIGHT_PARENTHESIS LEFT_BRAC statement RIGHT_BRAC   {
										int i;
										printf("While LOOP: ");
										for(i=$3;i<$5;i++)
										{
											printf("%d ",i);
										}
										printf("\n");
	}
	;

forloopstmt: FOR LEFT_PARENTHESIS  VARIABLE ASSIGN NUMBER COL expression COL expression RIGHT_PARENTHESIS LEFT_BRAC statement RIGHT_BRAC     {
	   
	   if(newin($3,$5)){
		   printf("for loop statement execute :");
		   int i;
	   for(i=$5;i<=$7;i+=$9){
		   newin($3,valueout($3)+$9);
	   printf("%d ",i);
	   }
	   printf("\n");
	   }
	} ;

switch : SWITCH LEFT_PARENTHESIS expression RIGHT_PARENTHESIS LEFT_BRAC bases RIGHT_BRAC { cnt=0;ch=(int)$3;
};
bases : base 
	|base default;
base : 
	|base case
	;
case : CASE NUMBER COL expression SEMI {

	if ((int)$2 == ch)
	{
		cnt=1;
		printf(" Case No : %d  and Result :  %d\n",(int)$2,(int)$4);
	}
};
default : DEFAULT COL expression SEMI {
	if(cnt==0)
	{
		printf(" Result :  %d\n",(int)$3);
	}
}
;


%%


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}