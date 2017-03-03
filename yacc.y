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
int num;
%}
// definitions
%start line
%token <num> number
%type <num> line

// Production rules
%%
line: number ';' {;}
%% 
//Normal C-code
int main(void)
{
	return yyparse();
}
