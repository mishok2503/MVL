bison -d parser.ypp &&
flex lex.l &&
g++ -std=c++20 parser.tab.cpp lex.yy.c astout.cpp &&
./a.out "$1" > ast.out &&
jq . ast.out > "$1.out"
