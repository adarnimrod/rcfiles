"autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"autocmd BufRead *.py set nocindent
"autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
filetype plugin indent on
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal incsearch
syntax on
setlocal modeline
