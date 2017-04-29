## Project of the Compilers and Languages Module
### Simple Programming Language using Lexx and Yacc

#### Contributers
Abdallah Sobehy ([Abdallah-Sobehy] (https://github.com/Abdallah-Sobehy))

Mostafa Fateen ([MFateen] (https://github.com/MFateen))

Ramy Alfred ([ramyalfred] (https://github.com/ramyalfred))

Yousra Samir

#### Running Steps
- flex lex.l
- yacc -d yacc.y
- gcc lex.yy.c y.tab.c  -o compiler

#### The Project comprises the following
- [ ] Design a suitable programming language; you may use a mini version of an existing one
    - [x] Variables declaration
    - [x] Constants declaration.
    - [x] Mathematical and logical expressions.
    - [x] Assignment statement.
    - [x] If-then-else statement, while loops, repeat-until loops, for loops, switch statement.
    - [x] Block structure (nested scopes where variables may be declared at the beginning of blocks).
    - [ ] [optional] Functions
- [ ] Design a suitable and extensible format for the symbol table.
- [x] Implement the lexical analyzer using Lex.
- [ ] Design suitable action rules to produce the output quadruples and implement your parser using YACC.
- [ ] Implement a proper syntax error handler.
- [ ] Build a simple semantic analyzer
    - [ ] Variable declaration conflicts. i.e. multiple declaration off the same variable.
    - [ ] Improper usage of variables with regard to their type.
    - [ ] [optional] Addition of type conversion quadruples to coupe with operators semantic requirements, i.e. converting integer to real, etc.
    - [ ] Variables used before being initialized and unused variables.
- [ ] Implement a simple GUI.

Phases Delivery schedule: https://docs.google.com/document/d/1yKnRmjnohVbQjooCrwVUGWwnZnTipGHUCsdW_T_MNoM/edit
