bison -d parser.ypp
flex lex.l
g++ parser.tab.cpp lex.yy.c 
./a.out test 2> output
cat output | jq
