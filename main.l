%option noyywrap
%x comment
%x single_comment
%{
#include <stdio.h>
#include "tokens.h"

#define PRINTTOK(TOKEN, VALUE) printf("line %d, token=%-13s, value=`%s`\n", line, #TOKEN, VALUE)
void yyerror(char*);

int line = 1;

int hextoi(const char* s) {
    return 0;
}

int octtoi(const char* s) {
    return 0;
}

%}

whitespace  [ \t]+
newline     \n
keyword     "break"|"case"|"func"|"const"|"continue"|"do"|"double"|"else"|"float"|"for"|"if"|"int"|"long"|"return"|"short"|"sizeof"|"struct"|"switch"|"void"|"while"
operator    "+"|"-"|"*"|"/"|"%"|"="|"+="|"-="|"*="|"/="|"!"|"&&"|"||"|"=="|"!="|"++"|"--"|"<"|">"|"<="|">="|"&"
identifier  ([a-zA-Z_][a-zA-Z_0-9]*)
string      (\"([^\\\n\"]|(\\{2}|\\n|\\\"))*\")
octal       (0[0-7]+)
hex         (0[xX][0-9A-F]+)
integer     (([1-9][0-9]*)|0)
float       ((([1-9][0-9]*)|0)(\.[0-9]+)?([eE]-?(([1-9][0-9]*)|0))?)

%%
{whitespace}    {}
{newline}       {line++;}
";"             {PRINTTOK(T_DELIMITER, yytext); return T_DELIMITER;}
"/*"            {BEGIN(comment);}
"//"            {BEGIN(single_comment);}

{keyword} {
    PRINTTOK(T_KEYWORD, yytext);
    return T_KEYWORD;
}

{operator} {
    PRINTTOK(T_OPERATOR, yytext);
    return T_OPERATOR;
}

{identifier} {
    PRINTTOK(T_IDENTIFIER, yytext);
    return T_IDENTIFIER;
}

{string} {
    PRINTTOK(T_STRING, yytext);
    return T_STRING;
}

{octal} {
    PRINTTOK(T_INTEGER, yytext);
    return T_INTEGER;
}

{hex} {
    PRINTTOK(T_INTEGER, yytext);
    return T_INTEGER;
}

{integer} {
    PRINTTOK(T_INTEGER, yytext);
    return T_INTEGER;
}

{float}         {PRINTTOK(T_FLOAT, yytext); return T_FLOAT;}
<<EOF>>         {return 0;}

<comment>"*/"   {BEGIN(0);}
<comment>"\n"   {line++;}
<comment>.      {}

<single_comment>"\n"   {line++; BEGIN(0);}
<single_comment>.      {}

.               {yyerror("Invalid character"); exit(1);}
%%

void yyerror(char* s) {
    fprintf(stderr, "ERROR(line %d, input `%s`): %s\n", line, yytext, s);
}

int main(int argc, char* argv[]) {
    if (argc == 2) {
        printf("USING FILE INPUT\n");
        FILE *input = fopen(argv[1], "r");
        if (input == NULL) {
            printf("FAILED TO OPEN FILE: %s\n", argv[1]);
            return -1;
        }

        yyin = input;
    } else {
        yyin = stdin;
    }

    int prev_line = -1;
    int result = 1;
    while(result != 0) {
        result = yylex();
    }
    return 0;
}