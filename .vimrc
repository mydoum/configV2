" ============================================
" =================== Init ===================
" ============================================

syntax enable
set textwidth=79

" tab into spaces
set tabstop=4
set shiftwidth=4
set expandtab

" ============================================
" ================= Plug-in ==================
" ============================================

call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()

" ============================================
" ================= Visual ===================
" ============================================

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

" ============================================
" ================= Backup ===================
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
" ================= Actions ==================
" ============================================

"delete automaticaly the trailing whitespaces when :w
autocmd BufWritePre * :%s/\s\+$//e

" fix backspace problem
set backspace=start,eol,indent

" Setting called autowrite that writes
" the content of the file automatically if you call :make or :GoBuild
set autowrite

" ============================================
" ================= Bindings =================
" ============================================

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
