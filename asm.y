%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
int reg = -1; //定义全局寄存器编号
%}

%token NUMBER
%token ADD MINUS
%token MUL DIV
%token left_paren right_paren

%left ADD MINUS
%left MUL DIV
%right UMINUS

%%

lines   : lines expr ';' {  
                            printf("the final result in r%d\n", reg);
                            printf("@   assembly code end\n");
                        }
        | lines ';'
        | 
        ;

expr    : expr ADD expr { 
            printf("ADD r%d, r%d, r%d\n", reg-1, reg-1, reg);
            reg--;//每次进行二元运算后，减少寄存器数量
        }
        | expr MINUS expr { 
            printf("SUB r%d, r%d, r%d\n", reg-1, reg-1, reg);
            reg--;
        }
        | expr MUL expr { 
            printf("MUL r%d, r%d, r%d\n", reg-1, reg-1, reg);
            reg--;
        }
        | expr DIV expr { 
            printf("SDIV r%d, r%d, r%d\n", reg-1, reg-1, reg);
            reg--;
        }
        | left_paren expr right_paren
        | MINUS expr %prec UMINUS { 
            printf("NEG r%d, r%d\n", reg, reg);
        }
        | NUMBER { 
            reg++;//给每一个新读取到的数字分配新一个寄存器
            printf("MOV r%d, #%d\n", reg, yylval);

        }
        ;

%%

int yylex() {
        int t;
    double tokenval = 0.0;
    while(1){
        t=getchar();
        if(t==' ' || t=='\t' || t=='\n'){
            // do nothing
        } else if(isdigit(t)){
            tokenval = t - '0';
            while(isdigit(t=getchar())){
                tokenval = tokenval*10 + t - '0';
            }
            // 将多读取出的一个字符放回输入流
            ungetc(t, stdin);
            yylval = tokenval;
            return NUMBER;
            
        } else if(t == '+'){
            return ADD;
        } else if(t == '-'){
            return MINUS;
        } else if(t == '*'){
            return MUL;
        } else if(t == '/'){   
            return DIV;
        } else if(t == '('){   
            return left_paren; 
        } else if(t == ')'){
            return right_paren;
        } else{
            return t;
        }
    }
}

int main(void) {
    yyin = stdin;
    printf("@  assembly code begin\n");
    do{
        yyparse();
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

