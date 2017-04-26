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
void declare_initalize(int id, int type_);
void declare_only(int id, int type_);
void declare_const(int id, int type);
void calc_lowp(char*);
void calc_highp(char*);
void cond_lowp(char*);
void cond_highp(char*);
int exitFlag=0;
int next_reg = 1; // The register number to be written in the next instruction
int next_cond_reg = 11;
int is_first = 1; // check if is the first operation for consistent register counts
int is_first_cond = 1;
int after_hp = 0; // a high priority operation is done
int after_hp_cond = 0; // a high priority operation is done
int declared[26];
int is_constant[26];// for each variable store 1 if it constant
int scope[26]; // a scope number for each variable
int scopes_id[50];
int current_scope = 1;
int variabled_initialized[26];
int type[26];
%}
// definitions
%union {int INTGR; char * STRNG; float FLT; char CHR;}
%start statement
%token IF ELSE ELSEIF FOR WHILE SWITCH CASE DO BREAK
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
%left '~' '^' '&' '|'
%left '+' '-'
%left '*' '/'
%left AND OR NOT EQ NOTEQ GTE LTE GT LT INC DEC
/*Other type defs depend on non-terminal nodes that you are going to make*/

// Production rules
%%

statement	: variable_declaration_statement ';' {reset();}
			| assign_statement ';' {reset();}
			| constant_declaration_statement ';' {reset();}
			| conditional_statement {reset();}
			| math_expr ';' {reset();}
			| exit_command ';' {exit(EXIT_SUCCESS);}
			| statement variable_declaration_statement ';' {reset();}
			| statement assign_statement ';' {reset();}
			| statement constant_declaration_statement ';' {reset();}
			| statement conditional_statement {reset();}
			| statement math_expr ';' {reset();}
			| statement exit_command ';' {exit(EXIT_SUCCESS);}
			;

conditional_statement :
			if_statement {;}
			/*| for_loop {;}
			| while_loop {;}
			| do_while {;}*/
			;

if_statement :
			IF '(' condition ')'open_brace statement closed_brace {;}
			| IF '(' condition ')'open_brace statement closed_brace ELSE_FINAL statement closed_brace {;}
			| IF '(' condition ')'open_brace statement closed_brace ELSE if_statement {;}
			| condition {;} //TODO REMOVE this line
			;
ELSE_FINAL : ELSE '{' {printf("JZ R10, label%d\n",++current_scope);reset();}
open_brace : '{' {printf("JNZ R10, label%d\n",++current_scope);reset();}
closed_brace : '}' {printf("label%d:\n",current_scope--);}
;
condition :
			'(' condition ')' {;}
		| condition OR high_p_condition {cond_lowp("OR");}
			| condition AND high_p_condition {cond_lowp("AND");}
			| NOT condition {printf("NOT R10\n");}
			| high_p_condition {;}
			; // @ASobehy is this neccesary

high_p_condition :
			math_expr EQ math_expr {cond_highp("CMPE");}
			| math_expr NOTEQ math_expr {cond_highp("CMPNE");}
			| math_expr GTE math_expr {cond_highp("CMPGE");}
			| math_expr GT math_expr {cond_highp("CMPG");}
			| math_expr LTE math_expr {cond_highp("CMPLE");}
			| math_expr LT math_expr {cond_highp("CMPL");}
			; // @ASobehy is this neccesary


math_expr	:
 			'('math_expr')'											{$$=$2;}
			|math_expr '+' high_priority_expr    { calc_lowp("ADD"); }
			| math_expr '-' high_priority_expr    		{ calc_lowp("SUB"); }
		  | '~' math_expr 													{
																												$$ = ~$2;
																												if(after_hp)
																													printf("NOT R4\n");
																												else
																													printf("NOT R%d\n",next_reg-1);
																											}
			| math_expr '|' high_priority_expr				{ calc_lowp("OR"); }
			| math_expr '&' high_priority_expr				{ calc_lowp("AND"); }
			| math_expr '^' high_priority_expr				{ calc_lowp("XOR"); }
			|high_priority_expr												{	$$=$1;}
			;

high_priority_expr:		high_priority_expr '*' math_element		{ calc_highp("MUL"); }
						|high_priority_expr '/' math_element						{ calc_highp("DIV"); }
						|math_element																		{ $$=$1; }
						;

//TODO: ID type check
math_element:	NUM			  				{$$=$1;
																printf("MOV R%d, %d\n",next_reg++ ,$1);}
				| FLOATING_NUM					{$$=$1;
																printf("MOV R%d, %f\n",next_reg++,$1);}
				| ID 										{
																	if(declared[$1] == 1){
																		if(variabled_initialized[$1] == 1){
																			$$=$1;
																			printf("MOV R%d, %c\n",next_reg++,$1+'a');
																		} else {
																			printf("Error: %c is not set\n", $1+'a');
																		}
																	} else {
																		printf("Error: %c is not declared\n", $1+'a');
																	}
																}
				| '('math_expr')'				{$$=$2;}
				;
assign_statement:
	ID '=' math_expr	{	if(declared[$1] == 1) {
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
	TYPE_INT ID 	{ 	declare_only($2,1);}
	|TYPE_FLT ID	{ 	declare_only($2,2);}
	|TYPE_CHR ID	{ 	declare_only($2,3);}
	|TYPE_INT ID '=' math_expr	{ 	declare_initalize($2,1);}
	|TYPE_FLT ID '=' math_expr	{ 	declare_initalize($2,2);}
	|TYPE_CHR ID '=' CHAR_VALUE		{ 	declare_initalize($2,3);}
	;
//TODO edit to match normal declaration registers
//TODO detect error when attempting to edit
constant_declaration_statement:
	TYPE_CONST TYPE_INT ID '=' math_expr			{ 	declare_const($3,1);
																						}

	| TYPE_CONST TYPE_FLT ID '=' math_expr		{ 	declare_const($3,2);
																						}
	| TYPE_CONST TYPE_CHR ID '=' CHAR_VALUE			{
																								if(declared[$3] == 0) {
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
	for (int i = 0; i < 50; i++)
	{
	    scopes_id[i] = i;
	}
	return yyparse();
}
void calc_lowp (char * op) {
	/*$$ = $1 + $3;*/
	if(is_first){
		printf("%s R0,R%d,R%d\n", op, --next_reg ,--next_reg );
		is_first=0;
	}
	else{
		if(after_hp){
			printf("%s R0,R%d,R4\n",op, --next_reg);
			after_hp = 0;
		}
		else{
			printf("%s R0,R%d,R0\n",op, --next_reg);
		}
		}
}

void calc_highp (char * op) {
	if(!after_hp){
		printf("%s R4,R%d,R%d\n", op, --next_reg ,--next_reg );
		after_hp = 1;
		is_first = 0;
	}
	else{
		printf("%s R4,R%d,R4\n", op, --next_reg );
	}
}

void cond_lowp (char * op) {
printf("%s R10,R10,R14\n",op);
}

void cond_highp (char * op) {
	if(!after_hp_cond){
		printf("%s R10,R%d,R%d\n", op, --next_reg ,--next_reg );
		after_hp_cond = 1;
		is_first_cond = 0;
	}
	else{
		printf("%s R14,R%d,R%d\n", op, --next_reg, --next_reg );
	}
}
void declare_only(int id,int type_)
{
	if(declared[id] == 0) {
	declared[id] = 1;
	type[id] = type_;
	variabled_initialized[id] = 0;
	is_constant[id] = 0;
	} else {
		printf("Syntax Error : %c is an already declared variable\n", id + 'a');
	}
}

void declare_const(int id, int _type)
{
	if(declared[id] == 0) {
			declared[id] = 1;
			type[id] = _type;
			variabled_initialized[id] = 1;
			is_constant[id] = 1;
			if(is_first){
				printf("MOV %c,R%d\n",id+'a',--next_reg);
		}else{
			if(after_hp)
				printf("MOV %c,R4\n",id+'a');
			else
				printf("MOV %c,R0\n",id+'a');
			}
	} else {
		printf("Syntax Error : %c is an already declared variable\n", id + 'a');
	}
}
void declare_initalize(int id, int _type){
	if(declared[id] == 0) {
		declared[id] = 1;
		type[id] = _type;
		variabled_initialized[id] = 1;
		is_constant[id] = 0;
		if(is_first){
			printf("MOV %c,R%d\n",id+'a',--next_reg);
		}else{
			if(after_hp)
				printf("MOV %c,R4\n",id+'a');
			else
				printf("MOV %c,R0\n",id+'a');
			}
	} else {
		printf("Syntax Error : %c is an already declared variable\n", id + 'a');
	}
}
void reset()
{
	next_reg = 1;
	is_first = 1;
	after_hp = 0;
	is_first_cond = 1;
	after_hp_cond = 0;
	printf("\n");
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
