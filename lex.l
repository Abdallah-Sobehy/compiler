%{
#include <stdio.h>
%}

DIGIT [0-9]

%%
if							printf("IF ");
else						printf("ELSE ")
while						printf("WHILE ");
for							printf("FOR ");
switch					printf("SWICH ");
case						printf("CASE ");


"&&"						printf("AND ");
"|"							printf("OR ");
"=="						printf("EQUALITY ");
">="						printf("GTOREQ ");
"<="						printf("LTOREQ ");
">"							printf("GREATER ");
"<"							printf("LESS ");
"="							printf("ASSIGN ");
"+"							printf("PLUS ");
"-"							printf("MINUS ");
"*"							printf("MULT ");
"/"							printf("DIVIDE ");
"%"							printf("MOD ");


int							printf("TYPE_INT ");
float						printf("TYPE_FLT ");
string						printf("TYPE_STR ");
char						printf("TYPE_CHR ");


{DIGIT}*"."{Digit}+			printf("FLOATING_NUM ");
{DIGIT}+					printf("NUM ");
"'"[0-9a-zA-z]"'"			printf("CHAR ");
"""[0-9a-zA-Z ]+"""			printf("STRING ");
[_a-zA-Z][a-zA-Z0-9]+		printf("ID");


"("							printf("OPEN_BRACE");
")"							printf("CLOSE_BRACE ");
"{"							printf("OPEN_CURLY ");
"}"							printf("CLOSE_CURLY ");
";"							printf("END_STMNT ");
"//"            printf("INLINE_COMMENT ");