bison -d parser.ypp &&
flex lex.l &&
g++ -std=c++20 parser.tab.cpp lex.yy.c astout.cpp &&
./a.out t.mvl > ast.out &&
cat ast.out | jq
