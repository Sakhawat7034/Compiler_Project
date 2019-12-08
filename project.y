%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>

    #define convt 180.0
    #define py  3.1416

     int ifval[1000];
	int ifptr = -1;
	int ifdone[1000];

    int ptr = 0;
    float value[1000];
    char varlist[1000][1000];

    ///if already declared  return 1 else return 0
    int isdeclared(char str[]){
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) return 1;
        }
        return 0;
    }
    /// if already declared return 0 or add new value and return 1;
    int addnewval(char str[],float val){
        if(isdeclared(str) == 1) return 0;
        strcpy(varlist[ptr],str);
        value[ptr] = val;
        ptr++;
        return 1;
    }

    ///get the value of corresponding string
   float getval(char str[]){
        int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        return value[indx];
    }
    int setval(char str[], float val){
    	int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        value[indx] = val;
    }
    
%}

%union {
  char text[1000];
  float val;
}

%type <val> expression

%token <val>  NUMBER
%token <text>  VARIABLE

%token  HEADER ABS ABF INT FLOAT CHAR INTMAIN VOIDMAIN IF ELSE ELSEIF WHILE FOR SWITCH CASE DEFAULT COLON COL LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRAC RIGHT_BRAC SEMI COMMA PLUS MINUS MULT DIV ASSIGN EQUAL LESS GREATER GE LE NE POWER SIN COS TAN LOG FACTORIAL SQRT SQR CUBE DOUBLE PRINT
RET FUNCTION  

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
            ;
declaration : type variables SEMI {}
			;
type		: INT | FLOAT | CHAR {}
			;
variables	: variable COMMA variables {}
			| variable {}
			;
variable   	: VARIABLE	
					{
						//printf("%s\n",$1);
						int x = addnewval($1,0);
						if(!x) {
							printf("Compilation Error:Variable %s is already declared\n",$1);
							exit(-1);
						}

					}
			| VARIABLE ASSIGN expression 	
					{
						//printf("%s %f\n",$1,$3);
						int x = addnewval($1,$3);
						if(!x) {
							printf("Compilation Error: Variable %s is already declared\n",$1);
							exit(-1);
							}
					}

			;

expression :  NUMBER				{ $$ = $1; 	}

	| VARIABLE {
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							$$ = getval($1);
						}
				 	}
    |  expression EQUAL expression   {$3 == $1; $$=$1;}   

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	    { 	
	 									if($3) 
					  					{
					     					$$ = $1 / $3;
					  					}
								  		else
								  		{
											$$ = 0;
											printf("\ndivision by zero --> undefined\n\t");
							  			} 	
							        }
  

	| expression POWER expression   { $$ = pow($1,$3);  }   

	| expression LESS expression	{ $$ = $1 < $3; }

	| expression GREATER expression	{ $$ = $1 > $3; }

	| expression LE expression	    { $$ = $1 <= $3; }

	| expression GE expression	    { $$ = $1 >= $3; }

    | expression NE expression	    { $$ = $1 != $3; }

	| LEFT_PARENTHESIS expression RIGHT_PARENTHESIS		{ $$ = $2;	}

	| SIN LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = sin(($3*py)/convt);	}

	| COS LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = cos(($3*py)/convt);	}

	| TAN LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = tan(($3*py)/convt);	}

	| LOG LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = log($3);	}

	| SQRT LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = sqrt($3);}

	| SQR LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = $3 * $3;	}

	| CUBE LEFT_PARENTHESIS expression RIGHT_PARENTHESIS { $$ = $3 * $3 * $3;	}

	| expression FACTORIAL {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;
						printf(" factorial value!= %.10g\n",$$); 
					 }
	;
print		: 	PRINT LEFT_PARENTHESIS VARIABLE RIGHT_PARENTHESIS
					{
						if(!isdeclared($3)){
							printf("Compilation Error: Variable %s is not declared\n",$3);
							exit(-1);
						}
						else{
							float v = getval($3);
							printf("%f",v);
						}
					};
			
ifelse      : IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS ABS statement ABF  {
                    //printf("came here ifelse %d\n",$3);
                    
                    if(ifptr<0){
                        printf("1ok negetive");
                        ifptr=0;
                    }
                    ifdone[ifptr] = 0;
                    ifptr --;
                } elseif 
            ;
elseif : /* empty */
        | ELSEIF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS ABS statement ABF
            {
                printf("ELSE IF :: %d\n",$3);
            } elseif
        | elseif ELSE ABS statement ABF 
            {
                //printf("Came ELSE\n");
                
                if(ifptr<0){
                    printf("4ok negetive");
                    ifptr=0;
                }
                if(ifdone[ifptr] == 0) 
                {
                    printf("\n ELSE Executed\n");
                    ifdone[ifptr] = 1;
                }
            }
        ;
assign:VARIABLE ASSIGN expression SEMI
					{
						if(!isdeclared($1)) {
							printf("Compilation Error: Variable %s is not declared\n",$1);
							exit(-1);
						}
						else{
							setval($1,$3);
						}
					} ;
whilestmt : ;
forloopstmt: ;


%%


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}