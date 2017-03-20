return/**
 * @file lex.l
 * @date March 3, 2017
 * @author Abdallah sobehy
 * @author Mostafa Fateen
 * @author Ramy Alfred
 * @author Yousra Samir
 * @brief lex file of a compiler for a C++ like language
 * @ref https://github.com/jengelsma/yacc-tutorial
 */
%{
#include "y.tab.h"
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
ALNUM [0-9a-zA-Z]

%%
if      printf("IF ");
else    printf("ELSE ");
while	  printf("WHILE ");
for     printf("FOR ");
switch  printf("SWICH ");
case    printf("CASE ");
do			printf("DO ");

/*
Returning actual symbol rather than description(easier)
"+"			printf("PLUS ");
"-"			printf("MINUS ");
"*"			printf("MULT ");
"="			printf("ASSIGN ");
"/"			printf("DIVIDE ");
"%"			printf("MOD ");
";"		  printf("END_STATEMENT ");*/
[*+-/=%;]  {return yytext[0];}

"&&"		printf("AND ");
"|"			printf("OR ");
"!"			printf("NOT ");
"=="		printf("EQUALITY ");
">="		printf("GTOREQ ");
"<="		printf("LTOREQ ");
">"			printf("GREATER ");
"<"			printf("LESS ");
"++"		printf("INC ");
"--"		printf("DEC ");



"int"			return TYPE_INT;
"float"		return TYPE_FLT;
"string"  return TYPE_STR;
"char"		return TYPE_CHR;
"const"   return TYPE_CONST;

/*stof should be string to floating(Needs revision when running)*/
\-?{DIGIT}*"."{DIGIT}+      {yylval.FLT = stof(yytext); return FLOATING_NUM;}
\-?{DIGIT}+					        {yylval.INTGR = atoi(yytext); return NUM;}
/*Literal string and char not needed in this phase*/
"'"[0-9a-zA-z]"'"			      printf("CHAR ");
\"[0-9a-zA-Z ]+\" 			    printf("STRING ");
[_a-zA-Z][a-zA-Z0-9]*       {yylval.STRNG = yytext; return ID;}


"("				            printf("OPEN_BRACE");
")"							      printf("CLOSE_BRACE ");
"{"							      printf("OPEN_CURLY ");
"}"							      printf("CLOSE_CURLY ");
"//".*                printf("INLINE_COMMENT ");
"/*"(.|\n)*"*/"     printf("BLOCK_COMMENT ");

%%

int yywrap (void) {return 1;}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
