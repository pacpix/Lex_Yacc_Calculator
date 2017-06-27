%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "sym.h"
%}

%union {
    double dval;
    struct sym * symptr;
}

%token <symptr> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <dval> expression
%%
statement_list
    : statement '\n'
    | statement_list statement '\n'
    ;

statement
    : NAME '=' expression { 
                            if ( (strcmp ( $1->name, "PI") == 0) || (strcmp ( $1->name, "PHI") == 0))
                            {
                                printf("assign to const\n");
                            }
                            else
                            {
                                $1->value = $3;
                            } 
                          }
    | expression { printf("= %g\n", $1); }
    ;

expression
    : expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { 
                                    if($3 == 0) 
                                    {
                                         printf("divide by zero\n");
                                    }
                                    else 
                                    {
                                          $$ = $1 / $3;
                                    }
                                 }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')' { $$ = $2; }
    | NUMBER
    | NAME { $$ = $1->value; }
    ;

%%

void symtablegen()
{
    struct sym * constptr;

    static int x = 0;
    if (x == 0)
    {
        head = NULL;
        x++;
    }

    if (head == NULL)
    {
        constptr = malloc(sizeof(struct sym));
        constptr->name = "PHI";
        constptr->value = 1.61803;
        constptr->next = malloc(sizeof(struct sym));
        constptr->next->name = "PI";
        constptr->next->value = 3.14159;
        constptr->next->next = NULL;
        head = constptr;
    }
}     

void printsymbols()
{
    struct sym *printptr;
    int symcount = 0;
        
    printptr = head;
        
    while (printptr != NULL)
    {
        symcount++;
        printptr = printptr->next;
    }

    char * symbols[symcount];
    double symvals[symcount];

    printf("num-syms: ");
    printf("%d", symcount);
    printf("\n");

    int i = 0;
    int j = 0;
    for ( printptr = head; printptr != NULL; printptr = printptr->next )
    {
        symbols[i] = printptr->name;
        symvals[i] = printptr->value;
        i++;
    }
    for (i = 0; i < symcount; i++)
    {  
        for (j = i + 1; j < symcount; j++)
        {   
            if (strcmp(symbols[i], symbols[j]) > 0)
            {
                char * tempsym;
                double tempval;
                tempsym = symbols[i];
                symbols[i] = symbols[j];
                symbols[j] = tempsym;
                tempval = symvals[i];
                symvals[i] = symvals[j];
                symvals[j] = tempval;
           }               
        }
    }
    
    for (i = 0; i < symcount; i++)
    {
        printf("\t");
        printf("%s", symbols[i]);
        printf(" => ");
        printf("%g", symvals[i]);
        printf("\n");
    } 

}
struct sym * sym_lookup(char * s)
{
    char * p;
    struct sym * sp;
    struct sym * currentptr;


   for (currentptr = head; currentptr != NULL; currentptr = currentptr->next)
    {
        if (currentptr->name && strcmp(currentptr->name, s) == 0)
        {
            return currentptr;
        }
        
        if (currentptr->next == NULL)
        {
            sp = malloc(sizeof(struct sym));
            sp->name = strdup(s);
            sp->next = NULL;
            currentptr->next = sp;
            return sp;
        }
        else
        {   
            continue;
        }
    }
    yyerror("Too many symbols");
    exit(-1);
    return NULL; /* unreachable */
}

