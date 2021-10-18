%{
#include <stdio.h>
#include <stdlib.h>
//#include "gram.tab.hpp"

#define true 1
#define false 0
int strcom = false;
int num_of_str = 1;
int num_of_open_comma = 0;
int n, position = 1, pos_before, t;
char c;


int check_comma() {
    if (num_of_open_comma > 0 || strcom == true)
    	return true;
    return false;
}

enum token {
  INT10 = 1, INT2 = 2, OPEN_PAREN = 3, CLOSE_PAREN = 4, CURLY_OPEN_BR = 5, CURLY_CLOSE_BR = 6, COMMA_OPEN = 7, COMMA_CLOSE = 8,
  COMMA_ON_STRING = 9, IF = 10, WHILE = 11, SKIP = 12, SW = 13, QUESTION = 14, AND = 15, OR = 16, EXCLAM_P = 17, PLUS = 18, OPM = 19,
  NOT_AS = 20, MINUS = 21, DEGREE = 22, USER_OPERATOR = 23, STRING = 24
};
%}

%option yylineno
%option noyywrap


INT10           -?[1-9][0-9]*|0
INT2            2x-?[1][01]*|0
OPEN_PAREN      \(
CLOSE_PAREN     \)
CURLY_OPEN_BR   \{
CURLY_CLOSE_BR  \}
COMMA_OPEN      \/\*
COMMA_CLOSE     \*\/
COMMA_ON_STRING \/\/.*\n
IF              if
WHILE           while
SKIP            skip
SW              \|\=\|
QUESTION        \?
AND             and
OR              or
EXCLAM_P        !
PLUS            \+
OPM             \*|\/
NOT_AS          ==|\/=|<=|<|>=|>
MINUS           -
DEGREE          \^
USER_OPERATOR  \|.*\|
STRING          [A-Za-z_0-9][A-Za-z_0-9]*

%%



{INT10} {
    n = atoi(yytext);
    pos_before = position;
    position += yyleng;
    //yylval.val = n;
    printf("readed INT10\n");
    return INT10;
}
{INT2} {
    pos_before = position;
    position += yyleng;
    //yylval.word = yytext;
    printf("readed INT2\n");
    return INT2;
}
{OPEN_PAREN} {
    pos_before = position;
    position ++;
    //yylval.sym = '(';
    printf("readed OPEN_PAREN\n");
    return OPEN_PAREN;
}
{CLOSE_PAREN} {
    pos_before = position;
    position ++;
    //yylval.sym = ')';
    printf("readed CLOSE_PAREN\n");
    return CLOSE_PAREN;
}
{CURLY_OPEN_BR} {
    pos_before = position;
    position ++;
    //yylval.sym = '{';
    printf("readed CURLY_OPEN_BR\n");
    return CURLY_OPEN_BR;
}
{CURLY_CLOSE_BR} {
    pos_before = position;
    position ++;
    //yylval.sym = '}';
    printf("readed CURLY_CLOSE_BR\n");
    return CURLY_CLOSE_BR;
}
{COMMA_OPEN}    {
    num_of_open_comma++;
}
{COMMA_CLOSE} {
    if (num_of_open_comma <=0) {
        printf("ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
        exit(1);
    }
    num_of_open_comma--;
}
{COMMA_ON_STRING} {
    strcom = true;
}
{IF} {
    if (check_comma())
        break;
    pos_before = position;
    position += 2;
    //yylval.word = "if";
    printf("readed IF\n");
    return IF;
}
{WHILE} {
    pos_before = position;
    position += 5;
    //yylval.word = "while";
    printf("readed WHILE\n");
    return WHILE;
}
{SKIP} {
    pos_before = position;
    position += 4;
    //yylval.word = "skip";
    printf("readed SKIP\n");
    return SKIP;
}
{SW}     {
    pos_before = position;
    position += 3;
    //yylval.word = "|=|";
    printf("readed SW\n");
    return SW;
}
{QUESTION} {
    pos_before = position;
    position++;
    //yylval.sym = '?';
    printf("readed QUESTION\n");
    return QUESTION;
}
{AND} {
    pos_before = position;
    position += 3;
    //yylval.word = "and";
    printf("readed AND\n");
    return AND;
}
{OR} {
    pos_before = position;
    position += 2;
    //yylval.word = "or";
    printf("readed OR\n");
    return OR;
}
{EXCLAM_P} {
    pos_before = position;
    position++;
    //yylval.sym = '!';
    printf("readed EXCLAM_P\n");
    return EXCLAM_P;
}
{PLUS} {
    pos_before = position;
    position += 3;
    //yylval.word = '|+|';
    printf("readed PLUS\n");
    return PLUS;
}
{OPM}  {
    pos_before = position;
    position++;
    //yylval.word = yytext;
    printf("readed OPM\n");
    return OPM;
}
{NOT_AS}  {
    pos_before = position;
    position += yyleng;
    //yylval.word = yytext;
    printf("readed NOT_AS\n");
    return NOT_AS;
}
{MINUS}  {
    pos_before = position;
    position += 3;
    //yylval.word = '|-|';
    printf("readed MINUS\n");
    return MINUS;
}
{DEGREE}  {
    pos_before = position;
    position += 3;
    //yylval.word = '|^|';
    printf("readed DEGREE\n");
    return DEGREE;
}
{USER_OPERATOR} {
    pos_before = position;
    position += yyleng;
    //yylval.word = yytext;
    printf("readed USER_OPERATOR\n");
    return USER_OPERATOR;
}
{STRING}    {
    pos_before = position;
    position += yyleng;
    //yylval.word = yytext;
    printf("readed STRING\n");
    return STRING;
}



#[^\n]*     {
    printf("readed something\n");
}
[ \t]       {position++;
    printf("readed t\n");
}
[\r\n]      {
    position = 1;
    num_of_str++; 
    strcom = false; 
    printf("readed rn\n");
}

<<EOF>>     {
    printf("(eof %u)\n", yylineno);
    return 0;
}

. {
printf("ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
exit(1);
}

%%

int main(int argc, char* argv[]) {
  while (1) {
    enum token t = yylex();
    if (t == 0) {
      break;
    }
  };
  return EXIT_SUCCESS ;
}
