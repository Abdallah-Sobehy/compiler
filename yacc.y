/**
 * @file yacc.y
 * @date March 3, 2017
 * @author Abdallah sobehy
 * @author Mostafa Fateen
 * @author Ramy Alfred
 * @author Yousra Samir
 * @brief yacc file of a compiler for a C++ like language
 * @ref https://github.com/jengelsma/yacc-tutorial
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void reset();
int exitFlag=0;
int value[52];
int next_reg = 1; // The register number to be written in the next instruction
int is_first = 1; // check if is the first operation for consistent register counts
int after_hp = 0; // a high priority operation is done
int declared[52];
int variabled_initialized[52];
int type[52];
%}
// definitions
%union {int INTGR; char * STRNG; float FLT; char CHR;}
%start statement
%token TYPE_INT TYPE_FLT TYPE_STR TYPE_CHR TYPE_CONST
%token <INTGR> ID
%token <INTGR> NUM
%token <FLT> FLOATING_NUM
%token <CHR> CHAR_VALUE
%token <STRNG> STRING_VALUE
%token exit_command
%type <INTGR> math_expr
%type <INTGR> high_priority_expr
%type <INTGR> math_element
%left '+' '-'
%left '*' '/'
/*Other type defs depend on non-terminal nodes that you are going to make*/

// Production rules
%%

statement	: variable_declaration_statement ';' {reset();}
			| assign_statement ';' {reset();}
			| constant_declaration_statement ';' {reset();}
			| math_expr ';' {reset();}
			| exit_command ';' {exit(EXIT_SUCCESS);}
			| statement variable_declaration_statement ';' {reset();}
			| statement assign_statement ';' {reset();}
			| statement constant_declaration_statement ';' {reset();}
			| statement math_expr ';' {reset();}
			| statement exit_command ';' {exit(EXIT_SUCCESS);}
			;

math_expr	:
 			'('math_expr')'											{$$=$2;}
			|math_expr '+' high_priority_expr    {
																									$$ = $1 + $3;
																									/*printf("Result +: %d. ",$$);*/
																									if(is_first){
																										printf("ADD R0,R%d,R%d\n",--next_reg ,--next_reg );
																										is_first=0;
																									}
																									else{
																										if(after_hp){
																											printf("ADD R0,R%d,R4\n",--next_reg);
																											after_hp = 0;
																										}
																										else{
																											printf("ADD R0,R%d,R0\n",--next_reg);
																										}
																										}
																								}
			| math_expr '-' high_priority_expr    		{
																									$$ = $1 - $3;
																									/*printf("Result - : %d. ",$$);*/
																									if(is_first){
																										printf("SUB R0,R%d,R%d\n",--next_reg ,--next_reg );
																										is_first = 0;
																									}
																									else{
																										if(after_hp){
																											printf("SUB R0,R%d,R4\n",--next_reg);
																											after_hp = 0;
																										}
																										else{
																											printf("SUB R0,R%d,R0\n",--next_reg);
																										}
																										}
																								}
		  | '~' math_expr 													{
																												$$ = ~$2;
																												if(after_hp)
																													printf("NOT R4\n");
																												else
																													printf("NOT R%d\n",next_reg-1);
																											}
			| math_expr '|' high_priority_expr				{
																									$$ = $1 | $3;
																									if(is_first){
																										printf("OR R0,R%d,R%d\n",--next_reg ,--next_reg );
																										is_first = 0;
																									}
																									else{
																										if(after_hp){
																											printf("OR R0,R%d,R4\n",--next_reg);
																											after_hp = 0;
																										}
																										else{
																											printf("OR R0,R%d,R0\n",--next_reg);
																										}
																										}

																								}
			| math_expr '&' high_priority_expr				{
																									$$ = $1 & $3;
																									if(is_first){
																										printf("AND R0,R%d,R%d\n",--next_reg ,--next_reg );
																										is_first = 0;
																									}
																									else{
																										if(after_hp){
																											printf("AND R0,R%d,R4\n",--next_reg);
																											after_hp = 0;
																										}
																										else{
																											printf("AND R0,R%d,R0\n",--next_reg);
																										}
																										}

																								}
			| math_expr '^' high_priority_expr				{
																									$$ = $1 ^ $3;
																									if(is_first){
																										printf("XOR R0,R%d,R%d\n",--next_reg ,--next_reg );
																										is_first = 0;
																									}
																									else{
																										if(after_hp){
																											printf("XOR R0,R%d,R4\n",--next_reg);
																											after_hp = 0;
																										}
																										else{
																											printf("XOR R0,R%d,R0\n",--next_reg);
																										}
																										}

																								}
			|high_priority_expr												{	$$=$1;}
			;

high_priority_expr:		high_priority_expr '*' math_element		{
																															$$ = $1 * $3;
																															/*printf("Result * : %d. ",$$);*/
																															if(!after_hp){
																																printf("MUL R4,R%d,R%d\n",--next_reg ,--next_reg );
																																after_hp = 1;
																																is_first = 0;
																															}
																															else{
																																printf("MUL R4,R%d,R4\n",--next_reg );
																															}

																														}
						|high_priority_expr '/' math_element						{
																															$$ = $1 / $3;
																															if(!after_hp){
																																printf("DIV R4,R%d,R%d\n",--next_reg ,--next_reg );
																																after_hp = 1;
																																is_first = 0;
																															}
																															else{
																																printf("DIV R4,R%d,R4\n",--next_reg );
																															}
																														}
						|math_element																		{
																															$$=$1;
																														}
						;

//TODO: ID type check
math_element:	NUM			  				{$$=$1;
																printf("MOV R%d, %d\n",next_reg++ ,$1);}
				| FLOATING_NUM					{$$=$1;
																printf("MOV R%d, %f\n",next_reg++,$1);}
				| ID 										{
																	if(declared[$1] == 1){
																		if(variabled_initialized[$1] == 1){
																			$$=value[$1];
																			printf("MOV R%d, %c\n",next_reg++,$1+'a');
																		} else {
																			printf("Error: %c is not set", $1+'a');
																		}
																	} else {
																		printf("Error: %c is not declared", $1+'a');
																	}
																}
				| '('math_expr')'				{$$=$2;}
				;
assign_statement:
	ID '=' math_expr	{	if(declared[$1] == 1) {
												value[$1] = $3;
												variabled_initialized[$1] = 1;
												if(after_hp)
													printf("MOV %c,R4\n",$1+'a');
												else
													printf("MOV %c,R0\n",$1+'a');
											}
											else {
												printf("Syntax Error : %c is not declared\n", $1 + 'a');
											}
										}
										;
variable_declaration_statement:
	TYPE_INT ID 	{ 	if(declared[$2] == 0) {
							value[$2] = 0;
							declared[$2] = 1;
							type[$2] = 1;
							variabled_initialized[$2] = 0;
						} else {
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_FLT ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 2;
							variabled_initialized[$2] = 0;
						} else {
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_CHR ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 3;
							variabled_initialized[$2] = 0;
						} else {
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_STR ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 4;
							variabled_initialized[$2] = 0;
						} else {
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_INT ID '=' math_expr	{ 	if(declared[$2] == 0) {
									value[$2] = $4;
									declared[$2] = 1;
									type[$2] = 1;
									variabled_initialized[$2] = 1;
									if(is_first){
										printf("MOV %c,R%d\n",$2+'a',--next_reg);
									}else{
										if(after_hp)
											printf("MOV %c,R4\n",$2+'a');
										else
											printf("MOV %c,R0\n",$2+'a');
										}
									//printf("Push %d\nPop %c", value[$2], $2+'a');
								} else {
									printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
								}
							}
	|TYPE_FLT ID '=' math_expr	{ 	if(declared[$2] == 0) {
											value[$2] = $4;
											declared[$2] = 1;
											type[$2] = 2;
											variabled_initialized[$2] = 1;
											//printf("Push %f\nPop %c", value[$2], $2+'a');
											if(is_first){
												printf("MOV %c,R%d\n",$2+'a',--next_reg);
											}else{
												if(after_hp)
													printf("MOV %c,R4\n",$2+'a');
												else
													printf("MOV %c,R0\n",$2+'a');
												}
										} else {
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
	|TYPE_CHR ID '=' CHAR_VALUE		{ 	if(declared[$2] == 0) {
											value[$2] = $4;
											declared[$2] = 1;
											type[$2] = 3;
											variabled_initialized[$2] = 1;
											//printf("Push %c\nPop %c", value[$2]+'a', $2+'a');
											printf("MOV %c,'%c'\n",$2+'a',$4+'a');
									} else {
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
	|TYPE_STR ID '=' STRING_VALUE	{ 	if(declared[$2] == 0) {
											value[$2] = $4;
											declared[$2] = 1;
											type[$2] = 4;
											variabled_initialized[$2] = 1;
											printf("MOV %c,%s\n",$2+'a',$4);
										} else {
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
;
//TODO edit to match normal declaration registers
//TODO detect error when attempting to edit
constant_declaration_statement:
	TYPE_CONST TYPE_INT ID '=' math_expr			{ 	if(declared[$3] == 0) {
																									value[$3] = $5;
																									declared[$3] = 1;
																									type[$3] = 1;
																									variabled_initialized[$3] = 1;
																									if(is_first){
																										printf("MOV %c,R%d\n",$3+'a',--next_reg);
																								}else{
																									if(after_hp)
																										printf("MOV %c,R4\n",$3+'a');
																									else
																										printf("MOV %c,R0\n",$3+'a');
																									}
																								//printf("Push %d\nPop %c", value[$2], $2+'a');
																							} else {
																								printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
																							}
																						}

	| TYPE_CONST TYPE_FLT ID '=' math_expr		{ 	if(declared[$3] == 0) {
																									value[$3] = $5;
																									declared[$3] = 1;
																									type[$3] = 1;
																									variabled_initialized[$3] = 1;
																									if(is_first){
																										printf("MOV %c,R%d\n",$3+'a',--next_reg);
																								}else{
																									if(after_hp)
																										printf("MOV %c,R4\n",$3+'a');
																									else
																										printf("MOV %c,R0\n",$3+'a');
																									}
																								//printf("Push %d\nPop %c", value[$2], $2+'a');
																							} else {
																								printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
																							}
																						}
	| TYPE_CONST TYPE_CHR ID '=' CHAR_VALUE			{
																								if(declared[$3] == 0) {
																									value[$3] = $5;
																									declared[$3] = 1;
																									type[$3] = 3;
																									variabled_initialized[$3] = 1;
																									printf("MOV %c,'%c'\n",$3+'a',$5+'a');

																								} else {
																									printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
																								}
																							}

	| TYPE_CONST TYPE_STR ID '=' STRING_VALUE		{
																								if(declared[$3] == 0) {
																									value[$3] = $5;
																									declared[$3] = 1;
																									type[$3] = 4;
																									variabled_initialized[$3] = 1;
																								} else {
																									printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
																								}
																							}
;


%%
//Normal C-code
int main(void)
{
	return yyparse();


}
int yyerror(char* s)
{
  fprintf(stderr, "%s\n",s);
  return 1;
}
void reset()
{
	next_reg = 1;
	is_first = 1;
	after_hp = 0;
	printf("\n");
}

int yywrap()
{
  return(1);
}
