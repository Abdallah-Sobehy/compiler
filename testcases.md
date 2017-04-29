# :poop: :poop: Test Cases & their respective Outputs :poop: :poop:
## Math Expressions
```c
int v = 7 + 4 + 2 + 5 + 2 * 2;

MOV R1, 7   
MOV R2, 4  
ADD R0,R2,R1  
MOV R1, 2  
ADD R0,R1,R0  
MOV R1, 5  
ADD R0,R1,R0  
MOV R1, 2  
MOV R2, 2  
MUL R4,R2,R1  
ADD R0,R0,R4  
MOV v,R0  
```  

```c
float g = 3;

MOV R1, 3  
MOV g,R1  
```

## Logical Expressions

### not '!' :joy: :joy: :joy:
```c
int x = ! 3 + 4;
```


## Conditional statement
### IF
```c
if ( 3 == 4 + 1  || 2 == 2 || -1 == 6) {
int x = 2 ;
}
int y = 2;

MOV R1, 3
MOV R2, 4
MOV R3, 1
ADD R0,R3,R2
CMPE R10,R1,R0
MOV R0, 2
MOV R1, 2
CMPE R14,R1,R0
OR R10,R10,R14
MOV R0, -1
MOV R1, 6
CMPE R14,R1,R0
OR R10,R10,R14
JNZ R10, label2

MOV R1, 2
MOV x,R1
label2:
MOV R1, 2
MOV y,R1
```

```c
int x = 1;
if ( ! x == 3 ){
	if( x != 3 ) {
		int y = 2;
	}
int z = 1;
}
int w;

MOV R1, 1
MOV x,R1

MOV R1, x
MOV R2, 3
CMPE R10,R2,R1
NOT R10
JNZ R10, label2

MOV R1, x
MOV R2, 3
CMPNE R10,R2,R1
JNZ R10, label3

MOV R1, 2
MOV y,R1

label3:

MOV R1, 1
MOV z,R1

label2:
```

```c
int x = 0;
int z = 1;
if (x == 0) {
  x = 1;
  if (x == 1) {
    int y = 3;
    x = 2;
  } else {
    int y = 2;
    x = 10;
  }
} else if ( z == 0 ) {
  z = 2;
}

if ( x > 20) {
int y = 1;
}

MOV R1, 0
MOV x,R1

MOV R1, 1
MOV z,R1

MOV R1, x
MOV R2, 0
CMPE R10,R2,R1
JF R10, label1

MOV R1, 1
MOV x,R1

MOV R1, x
MOV R2, 1
CMPE R10,R2,R1
JF R10, label2

MOV R1, 3
MOV y,R1

MOV R1, 2
MOV x,R1

label2:
JT R10, label3

MOV R1, 2
MOV y,R1

MOV R1, 10
MOV x,R1

label3:

label1:
MOV R1, z
MOV R2, 0
CMPE R10,R2,R1
JF R10, label4

MOV R1, 2
MOV z,R1

label4:

MOV R1, x
MOV R2, 20
CMPG R10,R2,R1
JF R10, label5

MOV R1, 1
MOV y,R1

label5:


```

### While loops
```c
int x = 1;
while( x == 1 &&  x <= 1 || x == 20 ) {
  x = 67;
}

MOV R1, 1
MOV x,R1

label1:
MOV R1, x
MOV R2, 1
CMPE R10,R2,R1
MOV R1, x
MOV R2, 1
CMPLE R14,R2,R1
AND R10,R10,R14
MOV R1, x
MOV R2, 20
CMPE R14,R2,R1
OR R10,R10,R14
JF R10, label2

MOV R1, 67
MOV x,R1

JMP label1
label2:

```

```c
int x = 50;
do {
  x = x + 1;
} while ( x <= 100 )

MOV R1, 50
MOV x,R1

label:1
MOV R1, x
MOV R2, 1
ADD R0,R2,R1
MOV x,R0

MOV R1, x
MOV R2, 100
CMPLE R10,R2,R1
JT R10,label1
```

### For loops
```c
int i;  
for ( i = 0; i < 10; i = i + 1 ) {
  int x = 1;
}

MOV R1, 0
MOV i,R1
MOV RF,0
label1:

MOV R1, i
MOV R2, 10
CMPL R10,R2,R1
JF R10, label2
CMPE RF,0
JT R10, label3
MOV R1, i
MOV R2, 1
ADD R0,R2,R1
MOV i,R0
label3:
MOV RF,1

MOV R1, 1
MOV x,R1

JMP label1
label2:

```

```c
int i;  
for ( i = 0; i < 10; i = i + 1 ) {
  int x = 1;
  for ( x = 2; x < 5; x = x + 1 ) {
    x = 15;
  }
}

MOV R1, 0
MOV i,R1
MOV RF,0
labelf3:

MOV R1, i
MOV R2, 10
CMPL R10,R2,R1
JF R10, labelf4
CMPE RF,0
JT R10, labelf5
MOV R1, i
MOV R2, 1
ADD R0,R2,R1
MOV i,R0
labelf5:
MOV RF,1

MOV R1, 1
MOV x,R1

MOV R1, 2
MOV x,R1
MOV RF,0
labelf6:

MOV R1, x
MOV R2, 5
CMPL R10,R2,R1
JF R10, labelf7
CMPE RF,0
JT R10, labelf8
MOV R1, x
MOV R2, 1
ADD R0,R2,R1
MOV x,R0
labelf8:
MOV RF,1

MOV R1, 15
MOV x,R1

JMP labelf6
labelf7:

JMP labelf3
labelf4:
```

### Do While
```c
int x = 1 ;
do{
x = x + 1;
} while(x < 10)


label:3
MOV R1, x
MOV R2, 1
ADD R0,R2,R1
MOV x,R0

MOV R1, x
MOV R2, 10
CMPL R10,R2,R1
JT R10,label3


```

### Switch case
```c
int x = 3;
switch(x){
  case 5 : x = x + 2;
  case 8 : x = 1; break;
}
int x = 3;
switch(x){
  case 5 : x = x + 2;
  case 8 : x = 1; break;
}

MOV R1, 3
MOV x,R1

MOV R1, x
MOV RS,R1
MOV R1, 5
CMPE R10,RS,R1
JF R10,label1a

MOV R1, x
MOV R2, 2
ADD R0,R2,R1
MOV x,R0

label1a:
MOV R1, 8
CMPE R10,RS,R1
JF R10,label1b

MOV R1, 1
MOV x,R1

JMP label1
label1b:
label1:

```

```c
int x = 10;
int y = 15;
switch(x){
  case y + 3 : x = x + 2; break;
  case 8 : x = 1;
	default: int z = 1;
}

MOV R1, 10
MOV x,R1

MOV R1, 15
MOV y,R1

MOV RS,x
MOV R1, y
MOV R2, 3
ADD R0,R2,R1
CMPE R10,RS,R0
JF R10,labelS1

MOV R1, x
MOV R2, 2
ADD R0,R2,R1
MOV x,R0

JMP label1
labelS1:
MOV R1, 8
CMPE R10,RS,R1
JF R10,labelS2

MOV R1, 1
MOV x,R1

MOV R1, 1
MOV z,R1

labelS2:
label1:
```

### Symbol table printing

```c

int x = 3;
const char y ='l';
float z;

if(x ==8){
	float m;
	symbol_table

MOV R1, 3
MOV x,R1
MOV y,'l'

MOV R1, x
MOV R2, 8
CMPE R10,R2,R1
JF R10, label1

Symbol Table:
=============
Symbol		Type		Initialized		Constant		Scope		
m		float		false			false			1
x		int		true			false			0
y		char		true			true			0
z		float		false			false			0

```
