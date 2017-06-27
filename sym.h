#ifndef SYMTBL_H
#define SYMTBL_H


struct sym {
    char * name;
    double value;
    struct sym * next;
} * head;

struct sym * sym_lookup(char *);

#endif /* SYMTBL_H */
