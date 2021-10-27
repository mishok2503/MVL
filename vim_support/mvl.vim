" TODO include guards

let b:current_syntax = "mvl"


" Keywords
syn keyword Keyword if endif while else
syn keyword Keyword skip

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
syn match MvlComment /O_o.*/ contains=ComKeyword
syn region MvlComment start=/+_+/ end=/-_-/ contains=MvlComment,ComKeyword
syn keyword ComKeyword TODO MVL contained
hi ComKeyword ctermfg=Blue
hi MvlComment ctermfg=LightGrey
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape('0_o ','\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape('0_o ','\/')<CR>//e<CR>:nohlsearch<CR>

" Autocomplete
set complete+=k~/.vim/mvl_keywords.txt
imap ( ()
imap { {}
let @m='imain( {'
let @f='A( {'
