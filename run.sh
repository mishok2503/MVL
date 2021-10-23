bison -d parser.ypp
flex lex.l
g++ parser.tab.cpp lex.yy.c 
./a.out t.mvl 2> output.out
cat output | jq
