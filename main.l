%option noyywrap
%{
#include <stdio.h>

#define LOG(...) printf(__VA_ARGS__);putchar('\n');

enum TOKEN {
    T_INTEGER = 1,
    T_FLOAT,
    T_IDENTIFIER,
    T_STRING,
    T_KEYWORD,
    T_OPERATOR,
    T_DELIMITER,
};

int line = 0;

int hextoi(const char* s) {
    return 0;
}

int octtoi(const char* s) {
    return 0;
}

%}

/*keyword "break|case|func|const|continue|do|double|else|float|for|if|int|long|return|short|sizeof|struct|switch|void|while*/
whitespace  [ \t]+
newline     \n
keyword     "break"|"case"|"func"|"const"|"continue"|"do"|"double"|"else"|"float"|"for"|"if"|"int"|"long"|"return"|"short"|"sizeof"|"struct"|"switch"|"void"|"while"
operator    "+"|"-"|"*"|"/"|"%"|"="|"+="|"-="|"*="|"/="|"!"|"&&"|"||"|"=="|"!="|"++"|"--"|"<"|">"|"<="|">="|"&"
/*operator    [\(\)\{\}\[\]]*/
identifier  ([a-zA-Z_][a-zA-Z_0-9]*)
string      (\"([^\\\n\"]|(\\{2}|\\n|\\\"))*\")
octal       (0[0-7]+)
hex         (0[xX][0-9A-F]+)
integer     (([1-9][0-9]*)|0)
float       ((([1-9][0-9]*)|0)(\.[0-9]+)?([eE]-?(([1-9][0-9]*)|0))?)

%%
{whitespace}    {}
{newline}       {line++;}
";"             {printf("delimiter(%s)\n", yytext); return T_DELIMITER;}
{keyword}       {printf("keyword(%s)\n", yytext); return T_KEYWORD;}
{operator}      {printf("operator(%s)\n", yytext); return T_OPERATOR;}
{identifier}    {printf("identifier(%s)\n", yytext); return T_IDENTIFIER;}
{string}        {printf("string(%s)\n", yytext); return T_STRING;}

{octal}         {printf("integer(%d)\n", octtoi(yytext)); return T_INTEGER;}
{hex}           {printf("integer(%d)\n", hextoi(yytext)); return T_INTEGER;}
{integer}       {printf("integer(%d)\n", atoi(yytext)); return T_INTEGER;}

{float}         {printf("float(%f)\n", atof(yytext)); return T_FLOAT;}
.               {return 0;}
%%

int main(int argc, char* argv[]) {
    if (argc == 2) {
        LOG("USING FILE INPUT");
        FILE *input = fopen(argv[1], "r");
        if (input == NULL) {
            LOG("FAILED TO OPEN FILE: %s", argv[1]);
            return -1;
        }

        yyin = input;
    } else {
        yyin = stdin;
    }

    int prev_line = -1;
    int result = 1;
    while(result != 0) {
        if (prev_line != line) {
            LOG("Line %d", line);
            prev_line = line;
        }
        result = yylex();
    }
    return 0;
}