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
FILE* log_file = fopen("lexer.log", "w");

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
COMM_ON_STRING  0\_\o
COMMA           ,
MAIN            main
IF              if
ENDIF           endif
ELSE            else
WHILE           while
SKIP            skip
SW              \|\=\|
QUESTION        \?
AND             \&\&
OR              \|\|\|\|
EXCLAM_P        !
PLUS            \|\+\|
OPM             [|]([*]|[\/])[|]
NOT_AS          \|(==|\/=|<=|<|>=|>)\|
MINUS           \|-\|
UNARY_MINUS     \-
DEGREE          \|\^\|
USER_OPERATOR_OPA   \|(\+|-)(\+|-|\*|\/|!|<|>|=|\^)+\|
USER_OPERATOR_OPM  \|(\*|\/)(\+|-|\*|\/|!|<|>|=|\^)+\|
USER_OPERATOR_DEG   \|\^(\+|-|\*|\/|!|<|>|=|\^)+\|
USER_OPERATOR_EXCLAM \|!(\+|-|\*|\/|!|<|>|=|^)+\|
USER_OPERATOR_NOT_AS \|(=|<|>)(\+|-|\*|\/|!|<|>|=|^)+\| 
COLON           \:
STRING          \"[^"]*\"
NAME_STRING     [A-Za-z][A-Za-z_0-9]*
SQ_BR_OP        \[
SQ_BR_CL        \]
%%


{SQ_BR_OP} {
    yylval.sym = '[';
    return SQ_BR_OP;
}

{SQ_BR_CL} {
    yylval.sym = ']';
    return SQ_BR_CL;
}


{INT} {
    n = atoi(yytext);
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.val = n;
    fprintf(log_file, "readed INT\n");
    return INT;
}
{INT2} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed INT2\n");
    return INT2;
}
{OPEN_PAREN} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '(';
    fprintf(log_file, "readed OPEN_PAREN\n");
    return OPEN_PAREN;
}
{CLOSE_PAREN} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = ')';
    fprintf(log_file, "readed CLOSE_PAREN\n");
    return CLOSE_PAREN;
}
{CURLY_OPEN_BR} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '{';
    fprintf(log_file, "readed CURLY_OPEN_BR\n");
    return CURLY_OPEN_BR;
}
{CURLY_CLOSE_BR} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = '}';
    fprintf(log_file, "readed CURLY_CLOSE_BR\n");
    return CURLY_CLOSE_BR;
}
{COMM_OPEN}    {
    num_of_open_comma++;
}
{COMM_CLOSE} {
    if (num_of_open_comma <=0) {
        fprintf(log_file, "ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
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
    fprintf(log_file, "readed COMMA\n");
    return COMMA;
}
{MAIN} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("main", 5);
    fprintf(log_file, "readed MAIN\n");
    return MAIN;
}

{ENDIF} {
    yylval.word = new std::string("endif");
    return ENDIF;
}

{IF} {
    pos_before = position;
    position += 2;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("if", 3);
    fprintf(log_file, "readed IF\n");
    return IF;
}
{ELSE} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("else", 5);
    fprintf(log_file, "readed ELSE\n");
    return ELSE;
}
{WHILE} {
    pos_before = position;
    position += 5;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("while", 6);
    fprintf(log_file, "readed WHILE\n");
    return WHILE;
}
{SKIP} {
    pos_before = position;
    position += 4;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("skip", 5);
    fprintf(log_file, "readed SKIP\n");
    return SKIP;
}
{SW}   {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|=|", 4);
    fprintf(log_file, "readed SW\n");
    return SW;
}
{QUESTION} {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.sym = '?';
    fprintf(log_file, "readed QUESTION\n");
    return QUESTION;
}
{AND} {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("&&", 3);
    fprintf(log_file, "readed AND\n");
    return AND;
}
{OR} {
    pos_before = position;
    position += 2;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("||", 3);
    fprintf(log_file, "readed OR\n");
    return OR;
}
{EXCLAM_P} {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.sym = '!';
    fprintf(log_file, "readed EXCLAM_P\n");
    return EXCLAM_P;
}
{PLUS} {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|+|", 4);
    fprintf(log_file, "readed PLUS\n");
    return PLUS;
}
{OPM}  {
    pos_before = position;
    position++;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed OPM\n");
    return OPM;
}
{NOT_AS}  {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed NOT_AS\n");
    return NOT_AS;
}
{MINUS}  {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|-|", 4);
    fprintf(log_file, "readed MINUS\n");
    return MINUS;
}

{UNARY_MINUS} {
    yylval.sym = '-';
    return UNARY_MINUS;
}

{DEGREE}  {
    pos_before = position;
    position += 3;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string("|^|", 4);
    fprintf(log_file, "readed DEGREE\n");
    return DEGREE;
}

{USER_OPERATOR_OPA} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed USER_OPERATOR\n");
    return USER_OPERATOR_OPA;
}

{USER_OPERATOR_OPM} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed USER_OPERATOR\n");
    return USER_OPERATOR_OPM;
}

{USER_OPERATOR_NOT_AS} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed USER_OPERATOR\n");
    return USER_OPERATOR_NOT_AS;
}

{USER_OPERATOR_DEG} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed USER_OPERATOR\n");
    return USER_OPERATOR_DEG;
}

{USER_OPERATOR_EXCLAM} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed USER_OPERATOR\n");
    return USER_OPERATOR_EXCLAM;
}



{COLON} {
    pos_before = position;
    position ++;
    if (check_comma() == 1)
        break;
    yylval.sym = ':';
    fprintf(log_file, "readed COLON\n");
    return COLON;
}
{STRING}    {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed STRING\n");
    return STRING;
}
{NAME_STRING} {
    pos_before = position;
    position += yyleng;
    if (check_comma() == 1)
        break;
    yylval.word = new std::string(yytext, yyleng);
    fprintf(log_file, "readed NAME_STRING\n");
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
    	fprintf(log_file, "ERROR, unclosed comment\n");
	exit(1);
    }
    fprintf(log_file, "(eof %u)\n", yylineno);
    return 0;
}

. {
    if (check_comma() == 0) {
        fprintf(log_file, "ERROR in line %u, symbol %s position %u\n", yylineno, yytext, position);
        exit(1);
    }
}

%%

