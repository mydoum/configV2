" ---------------------------------------------------------------------------

" Sections:
"   1. Text format
"   2. Plug-in
"   3. Visual
"   4. Backup
"   5. Actions
"   6. Spellchecker
"   7. Bindings
"   8. Memos

" ---------------------------------------------------------------------------

" ============================================
"   1. TEXT FORMAT
" ============================================
set textwidth=79
set ruler

" Tab into spaces
set tabstop=4
set shiftwidth=4
set expandtab

"Format the file from 2 spaces to 4 spaces
command Format %s/^\s*/&&

" ============================================
"   2. PLUG-IN
" ============================================
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()

" ============================================
"   3. VISUAL
" ============================================
syntax enable

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Activating the color scheme
" It has been tested on OSX, if linux try to delete the termcolors=256 line
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" show line numbers
set number

" visual autocomplete for command menu
set wildmenu

" search as characters are entered
set incsearch

" ============================================
"   4. BACKUP
" ============================================
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

" ============================================
"   5. ACTIONS
" ============================================
"delete automaticaly the trailing whitespaces when :w
autocmd BufWritePre * :%s/\s\+$//e

" fix backspace problem
set backspace=start,eol,indent

" Setting called autowrite that writes
" the content of the file automatically if you call :make or :GoBuild
set autowrite

" ============================================
"   6. SPELL CHECKER
" ============================================
set spelllang=fr
au BufNewFile,BufRead *.md,*.tex setlocal spell

function CallAntidote()
    :w
    call system("open -a /Applications/Antidote\\ 9.app ".bufname("%"))
endfunction

nmap <silent> <C-B> :call CallAntidote()<CR>

" ============================================
"   7. BINDINGS
" ============================================
" Save a readonly file
command SaveRO w !sudo tee %

" ================ Go conf ===================
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>


" ============================================
"   8. MEMOS
" ============================================
" Replace elements
" : %s/org_text/text_to_repl/gc
