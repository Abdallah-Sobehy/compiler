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
#include <string>
int num;
%}
// definitions
%union {int INTGR; string STRNG; float FLT; char CHR;}
%start line
%token TYPE_CONSTANT
%token TYPE_INT
%token TYPE_FLT
%token TYPE_STR
%token TYPE_CHR
%token TYPE_CONST
%token <STRNG> ID
%token <INTGR> NUM
%token <FLT> FLOATING_NUM
%type <num> line
/*Other type defs depend on non-terminal nodes that you are going to make*/


// Production rules
%%
line: number ';' {;}
%%
//Normal C-code
int main(void)
{
	return yyparse();
}
