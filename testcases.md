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
int x = 0;
int z = 1;
if (x == 0) {
  x = 1;
  if (x == 1) {
    int y = 3;
    x = 2
  } else {
    int y = 2;
    x = 10;
  }
} else if ( z == 0 ) {
  z = 2;
}

if ( x > 20) {

}
```

### While loops
```c
int x = 1;
while( x == 1 &&  x <= 1 || x = 20) {
  x = 67;
}

do {
  x = x + 1;
} while ( x <= 100 )
```

### For loops
```c
for ( int i = 0; i < 10; i = i + 1 ) {
  int x = 1;
}
```
The previous case could output a warning
