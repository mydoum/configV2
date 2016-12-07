" init
syntax on

" tab into spaces
set tabstop=4
set shiftwidth=4
set expandtab

" show line numbers
set number

" fix backspace problem
set backspace=start,eol,indent

" visual
set textwidth=79

" set backup
set backup
set backupdir=~/.vimtmp/backup
set directory=~/.vimtmp/temp

silent !mkdir -p ~/.vimtmp/backup
silent !mkdir -p ~/.vimtmp/temp

if version >= 700
    set undofile
    set undodir=~/.vimtmp/undo
    silent !mkdir -p ~/.vimtmp/undo
endif

" trial binds
    "delete automaticaly the trailing whitespaces when :w
autocmd BufWritePre * :%s/\s\+$//e
