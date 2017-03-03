%{
#include <stdio.h>
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


"&&"		printf("AND ");
"|"			printf("OR ");
"!"			printf("NOT ");
"=="		printf("EQUALITY ");
">="		printf("GTOREQ ");
"<="		printf("LTOREQ ");
">"			printf("GREATER ");
"<"			printf("LESS ");
"="			printf("ASSIGN ");
"+"			printf("PLUS ");
"++"		printf("INC ");
"-"			printf("MINUS ");
"--"		printf("DEC ");
"*"			printf("MULT ");
"/"			printf("DIVIDE ");
"%"			printf("MOD ");


int			printf("TYPE_INT ");
float		printf("TYPE_FLT ");
string  printf("TYPE_STR ");
char		printf("TYPE_CHR ");
const   printf("TYPE_CONST ");


\-?{DIGIT}*"."{DIGIT}+       printf("FLOATING_NUM ");
\-?{DIGIT}+					        printf("NUM ");
"'"[0-9a-zA-z]"'"			    printf("CHAR ");
\"[0-9a-zA-Z ]+\" 			  printf("STRING ");
[_a-zA-Z][a-zA-Z0-9]+     printf("ID");


"("				            printf("OPEN_BRACE");
")"							      printf("CLOSE_BRACE ");
"{"							      printf("OPEN_CURLY ");
"}"							      printf("CLOSE_CURLY ");
";"							      printf("END_STATEMENT ");
"//".*                printf("INLINE_COMMENT ");
"/*"(.|\n)*"*/"     printf("BLOCK_COMMENT ");

%%

main(int argc, char** argv) {
  yylex();
}
