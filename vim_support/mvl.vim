" TODO include guards

let b:current_syntax = "mvl"


" Keywords
syn keyword Keyword if while else
syn keyword Keyword skip " other color

" Literals
syn match Constant /\(\W\|^\)\@<=-*\d\+/
syn region MvlString start=/"/ skip=/\\"/ end=/"/ contains=EscapeSymbol
syn match EscapeSymbol /\\[ntrb"]/ contained
hi MvlString ctermfg=Blue
hi EscapeSymbol ctermfg=LightRed

" Functions
syn match Function /\w\+\((\)\@=/
hi Function ctermfg=Green

" Operators
syn match CreateOperator /(\s*\w\+\s*|.\+|\s*\w\+\s*):/ contains=AssOperator
syn match AssOperator /|\([-+*/^]\|&&\|||\)\+|/
syn match NonAssOperator /|\([<>=/]=\|[<>=]\)\+|/
hi CreateOperator ctermfg=Cyan
hi AssOperator ctermfg=Green
hi NonAssOperator ctermfg=Red

" Comments
syn region MvlComment start=/+_+/ end=/-_-/ contains=MvlComment,ComKeyword
syn keyword ComKeyword TODO MVL contained
hi ComKeyword ctermfg=Blue
hi MvlComment ctermfg=LightGrey

" Autocomplete
set complete+=k~/.vim/mvl_keywords.txt
imap ( ()
imap { {}
