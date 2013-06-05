""" Milk's vimrc

""" Init pathogen
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

" Neobundle script manager
filetype off                   " Required!
filetype plugin indent off     " Required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/,/usr/share/vim/vim72
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
"NeoBundle 'Shougo/neobundle.vim'


" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

" :help ConqueTerm
NeoBundle 'Flolagale/conque'


" Coding

" NeoBundle 'Raimondi/delimitMate'

" Add/remove comments with ease
NeoBundle 'tomtom/tcomment_vim'

" Surrount objects with something
NeoBundle 'tpope/vim-surround'

" Multiline text objects
NeoBundle 'paradigm/TextObjectify'

" Repeat movements
NeoBundle 'vim-scripts/repmo.vim'

" . repeat for plugin actions
NeoBundle 'tpope/vim-repeat'

" Syntax

NeoBundle 'othree/html5.vim'
" NeoBundle 'scrooloose/syntastic'

NeoBundle 'Valloric/vim-operator-highlight'

NeoBundle 'skammer/vim-css-color.git'

NeoBundle 'cakebaker/scss-syntax.vim'
" NeoBundle 'vim-scripts/Better-CSS-Syntax-for-Vim' - fuxks with scss :(
" NeoBundle 'html.vim'

NeoBundle 'pangloss/vim-javascript'

NeoBundle 'Valloric/MatchTagAlways'

" NeoBundle 'hallettj/jslint.vim'
" NeoBundle 'joestelmach/lint.vim'

" NeoBundle 'sleistner/vim-jshint'
NeoBundle 'wookiehangover/jshint.vim'

" Find things easily

" NeoBundle 'FuzzyFinder'
" NeoBundle 'L9' " required by ff

" Search for text in open buffers
" NeoBundle 'buffergrep'

" <leader>v
" holy shit yello
NeoBundle 'compview'

" Find things across windows/tabs
NeoBundle 'kien/ctrlp.vim'

" File navigation
" Jump to word using characters <leader>w (like f in vimium)
NeoBundle 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = '<leader>'

" NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'

NeoBundle 'myusuf3/numbers.vim'
nnoremap <leader>n :NumbersToggle<CR>


" Startup

" NeoBundle 'mhinz/vim-startify'


" Large interface

" Tiling buffer window manager
" Ctrl-j/k/space/...
NeoBundle 'spolu/dwm.vim'

" New staus line tool
NeoBundle 'Lokaltog/vim-powerline'

" Manage multiple files with ease
NeoBundle 'scrooloose/nerdtree'
" \p - toggle nerdtree
nmap <silent> <leader>p :NERDTreeToggle<CR>


" Tabs
NeoBundle 'jistr/vim-nerdtree-tabs'
map <Leader>o <plug>NERDTreeTabsToggle<CR>

NeoBundle 'benatkin/vim-move-between-tabs'
NeoBundle 'maxmeyer/vim-tabreorder'

" Manage tab workspaces
" NeoBundle 'sjbach/lusty'


" Doesn't work right with Awesome
" NeoBundle 'xolox/vim-misc'
" NeoBundle 'xolox/vim-lua-inspect'

" Zen coding like
"NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'mattn/zencoding-vim'

" Yank ring
" NeoBundle 'vim-scripts/YankRing.vim'
" 2p, paste sedonc last delete


" Git integration
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'

NeoBundle 'airblade/vim-gitgutter'


""" to sort

" Open files easily
"NeoBundle 'git://git.wincent.com/command-t.git'

"NeoBundle 'xolox/vim-session'
" :SaveSession, :OpenSession, :RestartVim, etc.

NeoBundle 'chrisbra/histwin.vim'

" Display sections in sidebar
" NeoBundle 'yazug/vim-taglist-plus'
" required ctags installed

" Manage buffers
"NeoBundle 'fholgado/minibufexpl.vim'

NeoBundle 'sickill/vim-pasta'

" NeoBundle 'inky/tumblr'

"NeoBundle 'msanders/snipmate.vim'

"NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Valloric/YouCompleteMe'



" Color theme
NeoBundle 'BlackSea'
colorscheme BlackSea


" NeoBundle required
" Basic syntax highlighting
if has("syntax")
  syntax on
  filetype on
  filetype plugin on
  filetype indent on
endif



""" General

set ttymouse=xterm2
set mouse=n

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
set paste

" Set title to Vim for xterm systems
set title

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set wildchar=<Tab> wildmenu wildmode=full



" Tag syntax config

" Vim syntax file
" Language: HTML (version 5)
" Maintainer: Rodrigo Machado <rcmachado [at] gmail [dot] com>
" URL: http://rm.blog.br/vim/syntax/html.vim
" Last Change: 2009 Aug 19
" License: Public domain
" (but let me know if you liked it :) )
"
" Note: This file just adds the new tags from HTML 5
" and don't replace default html.vim syntax file

" HTML 5 tags
syn keyword htmlTagName contained article aside audio bb canvas command datagrid
syn keyword htmlTagName contained datalist details dialog embed figure footer
syn keyword htmlTagName contained header hgroup keygen mark meter nav output
syn keyword htmlTagName contained progress time ruby rt rp section time video

" HTML 5 arguments
syn keyword htmlArg contained autofocus placeholder min max step
syn keyword htmlArg contained contenteditable contextmenu draggable hidden item
syn keyword htmlArg contained itemprop list subject spellcheck
" this doesn't work because default syntax file alredy define a 'data' attribute
syn match htmlArg "\<\(data-[\-a-zA-Z0-9_]\+\)=" contained


"Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
" I.e., for remembering cursor position
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
set viminfo='10,\"100,:20,%,n~/.viminfo


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


""" Key settings and bindings
" N.b. I have urxvt pass shift-space as an esc

" Make backspace work like most other apps
set backspace=eol,indent,start

" Shift-space as Esc - for gvim, vim requires mapping in terminal emulator config
imap <S-Space> <Esc>
imap <C-c> <Esc>

" Backspace in normal mode
" (beeps on blank line due to l)
noremap <BS> i<BS><Esc>li

" Space from normal to insert with a space
nmap <Space> i<Space><Esc>

" Enter in normal to add a line below and escape back to normal
nmap <CR> i<CR><Esc>

" Ctrl-N twice in normal mode toggles line numbers
nmap <C-N><C-N> :set invnumber<CR>

" Leader key (default = \)
"let mapleader = ","


" Edit .vimrc in current buffer with \ev
nmap <silent> <Leader>ev :e $MYVIMRC<cr>

" Source .vimrc with \sv
nmap <silent> <Leader>sv :so $MYVIMRC<cr>



" http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Turn of indentation and paste from clipboard
noremap <leader><leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>



" Move between windows with alt-arrows "not working after a few tries
" http://vim.wikia.com/wiki/Switch_between_Vim_window_splits_easily
"map  <C-+> :wincmd k<CR>
"map  <C--> :wincmd j<CR>
"map <silent> <M-Left> :wincmd h<CR>
"map <silent> <M-Right> :wincmd l<CR>

" Swap windows
" map <C-K> <C-W>x

" Ctrl-+ and Ctrl-- to resize windows
map <C--> <C-W>-
map <C-+> <C-W>+


" Highlight search term in all buffers
" set hlsearch
" Toggle search term highlight
nmap <silent> <leader>/ :silent set invhlsearch<CR>


" Highlight trailing whitespace in red on non-active line
" http://sartak.org/2011/03/end-of-line-whitespace-in-vim.html
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

" Delete whitespace at end of a line in normal - <Leader><Space>
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


" http://vim.wikia.com/wiki/Quickly_adding_and_deleting_empty_lines
nnoremap <silent><leader>j :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><leader>k :set paste<CR>m`O<Esc>``:set nopaste<CR>`
nnoremap <silent><leader><leader>j m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader><leader>k m`:silent -g/\m^\s*$/d<CR>``:noh<CR>


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
set foldmethod=manual

" set fillchars=vert:|,fold: ,diff:-

" open/close folds with tab
map <TAB> za

" folding is on by default. setting a high fold start level stops this
set foldlevel=20


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


""" Gvim

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>

  set guifont=monospace\ 8
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar

endif


""" Ctrl-q, insert just one character, not working!
"function! RepeatChar(char, count)
"   return repeat(a:char, a:count)
" endfunction
" nnoremap <C-q> :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
" below not urxvt friendly
" nnoremap C-S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Auto open NERDTree on start - to fix
" autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
