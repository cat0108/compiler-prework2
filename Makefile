.PHONY:	expression,suffix,expression_pro,clean,asm,all
all:	expression suffix expression_pro asm
expression:
	yacc expression.y -o expression.c
	gcc -o expression expression.c
suffix:
	yacc suffix.y -o suffix.c
	gcc -o suffix suffix.c
expression_pro:
	yacc expression_pro.y -o expression_pro.c
	gcc -o expression_pro expression_pro.c
asm:
	yacc asm.y -o asm.c
	gcc -o asm asm.c
clean:
	rm -rf expression suffix expression.c suffix.c	expression_pro expression_pro.c asm asm.c