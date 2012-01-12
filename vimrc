""" Milk's vimrc

""" Init pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


""" General

" Color theme
colorscheme BlackSea

" Use Vim defaults instead of 100% vi compatibility
set nocompatible

" Set bell to visual
set visualbell

" Advanced command completion
set wildmenu
set wildmode=full

" Use spaces not tabs
set expandtab

" Use two spaces for tabs
set tabstop=2

" User two spaces for indents
set shiftwidth=2

" Turn on line numbers
set nu

" Always show status bar
set laststatus=2

" Always 10 lines at top, excluding top and bottom
set scrolloff=10

" Incremental search - moves as you type
set incsearch

" Wrap searches
set wrapscan

" Case insensitive search for lowercase, case sensitive for upper
" http://stackoverflow.com/a/2288438
set ignorecase
set smartcase

" history bugger to 1000 lines
set history=1000

" Set swap and backup dir
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Show the cursor position all the time
set ruler

" Let pasting from middle click buffer work properly
"set paste

" Set title to Vim for xterm systems
set title

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" http://drupal.org/node/29325
if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
  augroup END
endif

" Basic syntax highlighting
if has("syntax")
  syntax on
  filetype on
  filetype plugin on
  " filetype indent on " causes comments to be indented down??
endif

"Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
" I.e., for remembering cursor position
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
set viminfo='10,\"100,:20,%,n~/.viminfo


""" Key settings and bindings

" N.b. I have urxvt pass shift-space as an esc

" Make backspace work like most other apps
set backspace=eol,indent,start

" Shift-space as Esc - for gvim, vim requires mapping in terminal emulator config
imap <S-Space> <Esc>

" Backspace in normal mode
" (beeps on blank line due to l)
noremap <BS> i<BS><Esc>li

" Space from normal to insert with a space
nmap <Space> i<Space>

" Enter in normal to add a line below and escape back to normal
nmap <CR> i<CR><Esc>

" Ctrl-N twice in normal mode toggles line numbers
nmap <C-N><C-N> :set invnumber<CR>

" Leader key (default = \)
"let mapleader = ","

" Let's make it easy to edit this file (mnemonic for the key sequence is 'e'dit 'v'imrc)
nmap <silent> <Leader>ev :e $MYVIMRC<cr>

" And to source this file as well (mnemonic for the key sequence is 's'ource 'v'imrc)
nmap <silent> <Leader>sv :so $MYVIMRC<cr>


" Move between windows with alt-arrows "not working after a few tries
" http://vim.wikia.com/wiki/Switch_between_Vim_window_splits_easily
"map  <C-+> :wincmd k<CR>
"map  <C--> :wincmd j<CR>
"map <silent> <M-Left> :wincmd h<CR>
"map <silent> <M-Right> :wincmd l<CR>

" Swap windows
map <C-K> <C-W>x

" Ctrl-+ and Ctrl-- to resize windows
map <C--> <C-W>-
map <C-+> <C-W>+

" Remap hlsearch toggle, need to fix other bindings first
" :set hlsearch
" map <F5> :set hls!<bar>set hls?<CR>:
" or
" nmap <silent> <leader>n :silent :nohlsearch<CR>

" Delete whitespace at end of a line in normal - <Leader><Space>
" http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
noremap <silent> <Leader><Space> :call <SID>StripTrailingWhitespace()<CR>


""" Functions

" Restore cursor postion on reload
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

""" Folding

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" automatically fold code depending on indent
set foldmethod=indent

" set fillchars=vert:|,fold: ,diff:-

" open/close folds with tab
map <TAB> za

" Diff with saved file - :diffsaved, :diffoff

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif


""" Nifty

" Highlight trailing whitespace in red on non-active line
" http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

""" Gvim

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif
