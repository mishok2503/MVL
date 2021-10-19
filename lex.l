%{
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include "structures.h"
#include "parser.tab.hpp"
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

%}

%option yylineno
%option noyywrap


INT2            2x-?[1][01]*|0
INT           -?[1-9][0-9]*|0
OPEN_PAREN      \(
CLOSE_PAREN     \)
CURLY_OPEN_BR   \{
CURLY_CLOSE_BR  \}
COMM_OPEN       \+\_\+
COMM_CLOSE      \-\_\-
COMM_ON_STRING  \/\/
COMMA           ,
MAIN            main
IF              if
ELSE            else
WHILE           while
SKIP            skip
SW              \|\=\|
QUESTION        \?
AND             \&\&
OR              \|\|
EXCLAM_P        \|!\|
PLUS            \|\+\|
OPM             [|]([*]|[\/])[|]
NOT_AS          \|(==|\/=|<=|<|>=|>)\|
MINUS           \|-\|
DEGREE          \|\^\|
USER_OPERATOR   \|[^|]*\|
COLON           \:
STRING          \"[^"]*\"
NAME_STRING     [A-Za-z][A-Za-z_0-9]*

%%



{INT} {
    n = atoi(yytext);
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.val = n;
    printf("readed INT\n");
    return INT;
}
{INT2} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed INT2\n");
    return INT2;
}
{OPEN_PAREN} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '(';
    printf("readed OPEN_PAREN\n");
    return OPEN_PAREN;
}
{CLOSE_PAREN} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = ')';
    printf("readed CLOSE_PAREN\n");
    return CLOSE_PAREN;
}
{CURLY_OPEN_BR} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '{';
    printf("readed CURLY_OPEN_BR\n");
    return CURLY_OPEN_BR;
}
{CURLY_CLOSE_BR} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '}';
    printf("readed CURLY_CLOSE_BR\n");
    return CURLY_CLOSE_BR;
}
{COMM_OPEN}    {
    num_of_open_comma++;
}
{COMM_CLOSE} {
    if (num_of_open_comma <=0) {
        printf("ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
        exit(1);
    }
    num_of_open_comma--;
}
{COMM_ON_STRING} {
    strcom = true;
}
{COMMA} {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.sym = ',';
    printf("readed COMMA\n");
    return COMMA;
}
{MAIN} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("main", 5);
    printf("readed MAIN\n");
    return MAIN;
}
{IF} {
    pos_before = position;
    position += 2;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("if", 3);
    printf("readed IF\n");
    return IF;
}
{ELSE} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("else", 5);
    printf("readed ELSE\n");
    return ELSE;
}
{WHILE} {
    pos_before = position;
    position += 5;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("while", 6);
    printf("readed WHILE\n");
    return WHILE;
}
{SKIP} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("skip", 5);
    printf("readed SKIP\n");
    return SKIP;
}
{SW}   {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|=|", 4);
    printf("readed SW\n");
    return SW;
}
{QUESTION} {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.sym = '?';
    printf("readed QUESTION\n");
    return QUESTION;
}
{AND} {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("&&", 3);
    printf("readed AND\n");
    return AND;
}
{OR} {
    pos_before = position;
    position += 2;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("||", 3);
    printf("readed OR\n");
    return OR;
}
{EXCLAM_P} {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.sym = '!';
    printf("readed EXCLAM_P\n");
    return EXCLAM_P;
}
{PLUS} {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|+|", 4);
    printf("readed PLUS\n");
    return PLUS;
}
{OPM}  {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed OPM\n");
    return OPM;
}
{NOT_AS}  {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed NOT_AS\n");
    return NOT_AS;
}
{MINUS}  {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|-|", 4);
    printf("readed MINUS\n");
    return MINUS;
}
{DEGREE}  {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|^|", 4);
    printf("readed DEGREE\n");
    return DEGREE;
}
{USER_OPERATOR} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed USER_OPERATOR\n");
    return USER_OPERATOR;
}
{COLON} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = ':';
    printf("readed COLON\n");
    return COLON;
}
{STRING}    {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed STRING\n");
    return STRING;
}
{NAME_STRING} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    printf("readed NAME_STRING\n");
    return NAME_STRING;
}




[ \t]       {
    position++;
}
[\r\n]      {
    position = 1;
    num_of_str++; 
    strcom = false; 	
}

<<EOF>>     {
    if (num_of_open_comma != 0) {
    	printf("ERROR, unclosed comment\n");
	exit(1);
    }
    printf("(eof %u)\n", yylineno);
    return 0;
}

. {
printf("ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
exit(1);
}

%%
