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
syntax on
:silent! python3 from powerline.vim import setup as powerline_setup
:silent! python3 powerline_setup()
:silent! python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
