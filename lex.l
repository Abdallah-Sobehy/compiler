/**
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
ALPHA [a-z]
ALPHA_CAPITAL [A-Z]
ALNUM [0-9a-zA-Z]

%%
if      printf("%s", yytext);
else    printf("ELSE ");
while	printf("WHILE ");
for     printf("FOR ");
switch  printf("SWICH ");
case    printf("CASE ");
do		printf("DO ");

[*+-/=%;~&|^]  {return yytext[0];}

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
"float"			return TYPE_FLT;
"string"  		return TYPE_STR;
"char"			return TYPE_CHR;
"const"   		return TYPE_CONST;
"exit"			return exit_command;

[ \t\n]+        ;       /* ignore whitespace */

\-?{DIGIT}*"."{DIGIT}+      {	yylval.FLT = atof(yytext);
								return FLOATING_NUM;}
\-?{DIGIT}+				 	{	yylval.INTGR = atoi(yytext);
								return NUM;}
\'.\'						{ 	yylval.INTGR = yytext[1]-'a';
								return(CHAR_VALUE); }
{ALPHA}						{	yylval.INTGR = *yytext-'a';
								return(ID);}
{ALPHA_CAPITAL}				{	yylval.INTGR = *yytext-'A'+26;
								return(ID);}
\"[0-9a-zA-Z ]+\" 			{ 	yylval.STRNG = yytext;
								return(STRING_VALUE); }

"("				            printf("OPEN_BRACE");
")"							printf("CLOSE_BRACE ");
"{"							printf("OPEN_CURLY ");
"}"							printf("CLOSE_CURLY ");
"//".*                		printf("INLINE_COMMENT ");
"/*"(.|\n)*"*/"     		printf("BLOCK_COMMENT ");

%%
