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
int num;
int exitFlag=0;
int value[52];
int declared[52];
int valueSet[52];
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
%type <num> statement
/*Other type defs depend on non-terminal nodes that you are going to make*/

// Production rules
%%

statement	: variable_declaration_statement ';' {;}
			| constant_declaration_statement ';' {;}
			| exit_command ';' {exit(EXIT_SUCCESS);}
			| statement variable_declaration_statement ';' {;}
			| statement constant_declaration_statement ';' {;}
			| statement exit_command ';' {exit(EXIT_SUCCESS);}
			;

variable_declaration_statement:	
	TYPE_INT ID 	{ 	if(declared[$2] == 0) {
							value[$2] = 0; 
							declared[$2] = 1;
							type[$2] = 1;
							valueSet[$2] = 0;
							printf("Debug int\n");
							printf("var name %c \n",$2+'a');
							printf("index %d \n",$2);
							printf("declared %d \n",declared[$2]);
						} else { 
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_FLT ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 2;
							valueSet[$2] = 0;
						} else { 
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_CHR ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 3;
							valueSet[$2] = 0;
						} else { 
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_STR ID	{ 	if(declared[$2] == 0) {
							declared[$2] = 1;
							type[$2] = 4;
							valueSet[$2] = 0;
						} else { 
							printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
						}
					}
	|TYPE_INT ID '=' NUM	{ 	if(declared[$2] == 0) {
									value[$2] = $4; 
									declared[$2] = 1;
									type[$2] = 1;
									valueSet[$2] = 1;
									printf("Debug int assign\n");
									printf("var name %c \n",$2+'a');
									printf("index %d \n",$2);
									printf("value %d \n",value[$2]);
								} else { 
									printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
								}
							}
	|TYPE_FLT ID '=' FLOATING_NUM	{ 	if(declared[$2] == 0) {
											value[$2] = $4; 
											declared[$2] = 1;
											type[$2] = 2;
											valueSet[$2] = 1;
										} else { 
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
	|TYPE_CHR ID '=' CHAR_VALUE		{ 	if(declared[$2] == 0) {
											value[$2] = $4; 
											declared[$2] = 1;
											type[$2] = 3;
											valueSet[$2] = 1;
									} else { 
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
	|TYPE_STR ID '=' STRING_VALUE	{ 	if(declared[$2] == 0) {
											value[$2] = $4; 
											declared[$2] = 1;
											type[$2] = 4;
											valueSet[$2] = 1;
										} else { 
											printf("Syntax Error : %c is an already declared variable\n", $2 + 'a');
										}
									}
;
constant_declaration_statement:
	TYPE_CONST TYPE_INT ID '=' NUM					{ 	if(declared[$3] == 0) {
															value[$3] = $5; 
															declared[$3] = 1;
															type[$3] = 1;
															valueSet[$3] = 1;
														} else { 
															printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
														}
													}
	| TYPE_CONST TYPE_FLT ID '=' FLOATING_NUM		{ 	if(declared[$3] == 0) {
															value[$3] = $5; 
															declared[$3] = 1;
															type[$3] = 2;
															valueSet[$3] = 1;
														} else { 
															printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
														}
													}
	| TYPE_CONST TYPE_CHR ID '=' CHAR_VALUE			{ 	if(declared[$3] == 0) {
															value[$3] = $5; 
															declared[$3] = 1;
															type[$3] = 3;
															valueSet[$3] = 1;
														} else { 
															printf("Syntax Error : %c is an already declared variable\n", $3 + 'a');
														}
													}
	| TYPE_CONST TYPE_STR ID '=' STRING_VALUE		{ 	if(declared[$3] == 0) {
															value[$3] = $5; 
															declared[$3] = 1;
															type[$3] = 4;
															valueSet[$3] = 1;
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
int yywrap()
{
  return(1);
}
