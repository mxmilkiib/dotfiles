" Vim configuration file
" Milk Brewster


""" Spaces
" b: <tab> = buffer switch
" \\b = buffers fzf
" sp: <tab> = new split window
" \\f = open file

""" Movement
" \f<letter> = acejump
" shift-{/} = jump to empty lines
" \% = jump to matching symbol
" Ctrl-o = jump cursor back to previous location
" Ctrl-i = jump cursor forward to recent location

""" Other
" \\f = fzf open file
" \\c = fzf command information
" \v = search across files, etc
" \n = toggle relative/absolute line numbers
" \\n = toggle on/off line numbers
" \/ = toggle search term highlight
" \s = toggle scratchpad buffer
" :shell = drop terminal into shell, return to vim on exit
" Ctrl-k = insert diagraph


if &compatible
  " Use Vim defaults instead of 100% vi compatibility
  set nocompatible
endif


""" VimScript Manager
call plug#begin('~/.vim/plugged')

  """ Startup
  " Plug 'mhinz/vim-startify'


  """ Find things easily
  " fzf - populate a menu with things and f*i*l*t*e*r live with ripgrep
  Plug 'junegunn/fzf.vim'
  noremap <Leader><Leader>f :FZF<CR>
  noremap <Leader><Leader>b :Buffers<CR>
  noremap <Leader><Leader>t :Colors<CR>
  noremap <Leader><Leader>c :Commands!<CR>
  noremap <Leader><Leader>h :History<CR>
  noremap <silent><Leader><Leader>d :Files <C-R>=expand('%:h')<CR><CR>
  noremap <Leader><Leader>l :BLines<CR>
  noremap <Leader><Leader>L :Lines<CR>
  noremap <Leader><Leader>' :Marks<CR>
  noremap <Leader><Leader>H :Helptags<CR>
  noremap <Leader><Leader>M :Maps<CR>
  noremap <Leader><Leader>F :Filetypes<CR>
  " noremap <Leader><Leader>/ :History/<CR>
  noremap <Leader><Leader>A :Ag<CR>

  if executable('fzf')
    " Better search history
    command! QHist call fzf#vim#search_history({'right': '40'})
    nnoremap q/ :QHist<CR>
    " Better command history with q:
    command! CmdHist call fzf#vim#command_history({'right': '40'})
    nnoremap q: :CmdHist<CR>
  end

  " http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before
  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
    \ -g "!{.git,node_modules,vendor}/*" '
  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)


  " Multiline f/t search
  Plug 'svermeulen/vim-extended-ft'

  " File navigation
  " Jump to word using characters <leader>w (like f in vimium)
  " Plug 'Lokaltog/vim-easymotion'
  " let g:EasyMotion_leader_key = '<leader>'

  " Plug 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'


  """ Coding

  " Provide insert mode auto-completion for quotes, parens, brackets, etc.
  " Plug 'Raimondi/delimitMate'
  " Plug 'jiangmiao/auto-pairs'

  " Add/remove comments with ease
  Plug 'scrooloose/nerdcommenter'
  let g:NERDSpaceDelims = 1
  let g:NERDCommentEmptyLines = 1
  " <leader>+c+<space> = toggle

  " Surround objects with something
  Plug 'tpope/vim-surround'
  " cs"' = change " to '
  " cs'<q> = change ' to <q>/</q>
  " dst = delete surrounding tags

  " Multiline text objects
  Plug 'paradigm/TextObjectify'

  " Repeat movements
  " Plug 'Houl/repmo-vim'

  " . repeat for some plugin actions
  Plug 'tpope/vim-repeat'

  " Text alignment
  " Plug 'godlygeek/tabular'


  " Display sections in sidebar
  " Plug 'yazug/vim-taglist-plus'
  " required ctags installed


  " Enhanced autocompletion
  "Plug 'Shougo/neocomplcache'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }


  " Visual help

  " Highlight yanked text
  " Plug 'sunaku/vim-highlightedyank'

  " Visually highlight matching opening & closing tags
  Plug 'Valloric/MatchTagAlways'
  " Jump to last tag
  nnoremap <leader>% :MtaJumpToOtherTag<cr>

  " Search index/total
  Plug 'henrik/vim-indexed-search'

  "Show contents of registers on " or @
  "doesnae work! todo: troubleshoot incompatability
  "Plug 'junegunn/vim-peekaboo'

  Plug 'myusuf3/numbers.vim'
  nnoremap <leader>n :NumbersToggle<CR>
  nnoremap <leader><leader>n :NumbersOff<CR>

  " Visual guide to indentation level
  " <leader>ig
  " Plug 'nathanaelkane/vim-indent-guides'
  "let g:indent_guides_enable_on_vim_startup = 1
  Plug 'Yggdroot/indentLine'


  " Syntax highlighting and help

  Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1
  let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}

  " HTML5
  Plug 'othree/html5.vim'

  " Faust syntax highlighting
  " Plug 'gmoe/vim-faust'

  " Plug 'vim-syntastic/syntastic'
  " set statusline+=%#warningmsg#
  " set statusline+=%{SyntasticStatuslineFlag()}
  " set statusline+=%*
" 
  " let g:syntastic_always_populate_loc_list = 1
  " let g:syntastic_auto_loc_list = 1
  " let g:syntastic_check_on_open = 1
  " let g:syntastic_check_on_wq = 0

  Plug 'w0rp/ale'
  let g:airline#extensions#ale#enabled = 1
  let g:ale_completion_enabled = 1

  " Highlights operator characters for every language
  Plug 'Valloric/vim-operator-highlight'

  " Plug 'ap/vim-css-color.git'

  " A plugin to color colornames and codes
  Plug 'chrisbra/Colorizer'
  autocmd VimEnter * ColorToggle

  " Plug 'cakebaker/scss-syntax.vim'

  Plug 'pangloss/vim-javascript'

  Plug 'mxw/vim-jsx'

  " TypeScript
  Plug 'HerringtonDarkholme/yats.vim'

  Plug 'jparise/vim-graphql'

  " Plug 'StanAngeloff/php.vim'

  " Synax for the sxhkd hotkey daemon
  " Plug 'baskerville/vim-sxhkdrc'

  Plug 'chase/nginx.vim'

  " Arch Linux package definition file
  Plug 'Firef0x/PKGBUILD.vim'

  " Python coding style formatting
  " Plug 'tell-k/vim-autopep8'

  " Doesn't work right with Awesome
  " For vim-session
  " Plug 'xolox/vim-misc'
  " Plug 'xolox/vim-lua-inspect'

  Plug 'tbastos/vim-lua'

  " Generate snippets
  " Plug 'mattn/emmet-vim'
  " let g:user_emmet_leader_key='<leader><Tab>'
  " let g:user_emmet_settings = {
    " \  'javascript.jsx' : {
      " \      'extends' : 'jsx',
      " \  },
    " \}


  """ Large interface

  " Tiling buffer window manager
  " Ctrl-j/k/space/...
  Plug 'spolu/dwm.vim'


  " New staus line style, a la powerline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1

  "powerline symbols
  if !exists('g:airline_symbols')
  let g:airline_symbols = {}
  endif

  " let g:airline_left_sep = '▶'
  " let g:airline_left_alt_sep = ''
  " let g:airline_right_sep = '◀'
  " let g:airline_right_alt_sep = ''
  " let g:airline_symbols.branch = ''
  " let g:airline_symbols.readonly = ''
  " let g:airline_symbols.linenr = ''
  let g:airline_statusline_ontop=0

  " Highlight the active line
  Plug 'ntpeters/vim-airline-colornum'
  let g:colors_name='default'


  " Better NetRW file navigation
  Plug 'tpope/vim-vinegar'

  " Manage multiple files with ease
  " Plug 'scrooloose/nerdtree'
  " let NERDTreeHijackNetrw=1
  "
  " " \p - toggle nerdtree
  " " nmap <silent> <leader>p :NERDTreeToggle<CR>
  " " Open NERDTree in the directory of the current file (or /home if no file is open)
  " nmap <silent> <leader>p :call NERDTreeToggleInCurDir()<cr>
  " function! NERDTreeToggleInCurDir()
  " " If NERDTree is open in the current buffer
  " if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    " exe ":NERDTreeClose"
  " else
    " exe ":NERDTreeFind"
  " endif
  " endfunction
  "
  " " open NERDTree automatically when vim starts up on opening a directory
  " autocmd StdinReadPre * let s:std_in=1
  " autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  "
  " " Close Vim if only NERDtree buffer is open
  " " https://github.com/scrooloose/nerdtree/issues/21
  " " autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | en
  "
  " augroup AuNERDTreeCmd
  " autocmd!
  " augroup end
  "
  " if has('gui_running')
  " " autocmd! NERDTreeHijackNetrw
  " autocmd! NERDTreeTabs
  " autocmd! NERDTree
  " endif
  "
  " let g:NERDTreeDirArrowExpandable = '▸'
  " let g:NERDTreeDirArrowCollapsible = '▾'
  "

  " Minimal GUI
  Plug 'junegunn/goyo.vim'
  " :Goyo / :Goyo!


  " :XtermColorTable, # = yank current color, t = toggle RGB text, f = set RGB text to current color
  " Plug 'sunaku/xterm-color-table.vim'


  """ File management

  " :rename for save as
  Plug 'danro/rename.vim'


  " If file is already open, switch to that window
  Plug 'gioele/vim-autoswap'


  """ Buffers
  "Plug 'fholgado/minibufexpl.vim'

  " Scratch pad buffer
  Plug 'mtth/scratch.vim'
  noremap <Leader>s :ScratchPreview<CR>


  """ Tabs
  " Plug 'jistr/vim-nerdtree-tabs'
  " map <Leader>o <plug>NERDTreeTabsToggle<CR>

  Plug 'benatkin/vim-move-between-tabs'
  " tN and tP

  Plug 'maxmeyer/vim-tabreorder'
  " alt-pgup and alt-pgdown

  " Manage tab workspaces
  " Plug 'sjbach/lusty'


  """ Registers
  " Plug 'vim-scripts/YankRing.vim'
  " 2p, paste second last delete

  """ Undo history
  " :UB
  Plug 'chrisbra/histwin.vim'


  """ Pasting
  " Plug 'sickill/vim-pasta'
  " Work with bracketed paste content from terminals
  Plug 'ConradIrwin/vim-bracketed-paste'


  """ Git integration
  Plug 'tpope/vim-fugitive'

  Plug 'gregsexton/gitv'

  " Plug 'airblade/vim-gitgutter'
  " Show a diff using Vim its sign column
  Plug 'mhinz/vim-signify'


  " Create Gists
  Plug 'mattn/webapi-vim'
  Plug 'mattn/gist-vim'


  """ Sessions

  "Plug 'xolox/vim-session'
  " :SaveSession, :OpenSession, :RestartVim, etc.
  "let g:session_autosave = 'yes'
  "let g:session_autoload = 'no'

  " Plug 'tpope/vim-obsession'


  """ Mouse support
  " F12 to toggle mouse between vim and terminal
  Plug 'vim-scripts/toggle_mouse'

  " ctrl/shift mouse click+drag over text copies/moves said text
  Plug 'vim-scripts/xemacs-mouse-drag-copy'


  """ Colour theme
  " Plug 'BlackSea'
  " colorscheme BlackSea

call plug#end()


" Basic syntax highlighting
if has("syntax")
  syntax on
  filetype on
  filetype plugin on
  filetype indent on
endif


""" General settings

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand('~/.vim/undodir')
    " Create dirs
    call system('mkdir ~/.vim/undodir')
    let &undodir = myUndoDir
    set undofile
endif


" Send more characters for redraws
set ttyfast

" Enable terminal mouse support
" if has("mouse_urxvt")
  " set ttymouse=urxvt - broken in tmux
" else
if has ("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" Enable mouse use in all modes. Use shift+middle-click to paste
set mouse=a
" Or make middle-click work proper
" set mouse=v

" Set bell to visual
set visualbell

" Advanced command completion
set wildmenu
set wildmode=full

" Use spaces for tabs
set expandtab

" Use two spaces for tabs
set tabstop=2

" User two spaces for indents
set shiftwidth=2

" Turn on line numbers
set nu

" Always show status bar
set laststatus=2

" Notification message space
set cmdheight=1

" Always keep extra lines above the cursor at top, excluding ends of a file
set scrolloff=5

" Highlight 80th chatacter of a line
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" Incremental search - moves as you type
" set incsearch

" Wrap searches
set wrapscan

" Case insensitive search for lowercase, case sensitive for upper
" http://stackoverflow.com/a/2288438
set ignorecase
set smartcase

" history buffer to 1000 lines
set history=1000

" Set swap and backup dir
set backupdir=/tmp
set directory=/tmp


""" Cursor

" Show the cursor position all the time
set ruler

" Show horizontal line that the cursor is on
" set cursorline

" Change cursorline highlight from underline to colour bar
" hi Search ctermbg=DarkGray cterm=none
" <leader>c to toggle cursorline highlight
" nnoremap <Leader>c :set cursorline!<CR>

" Highlight search term in all buffers
set hlsearch
" Toggle search term highlight
nmap <silent> <leader>/ :silent set invhlsearch<CR>

" highlight matches when jumping to text
" from greg0ire/more-instantly-better-vim
" This rewires n and N to do the highlighing...
" nnoremap <silent> n   n:call HLNext(0.4)<cr>
" nnoremap <silent> N   N:call HLNext(0.4)<cr>
"
" function! HLNext (blinktime)
  " let [bufnum, lnum, col, off] = getpos('.')
  " let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  " let target_pat = '\c\%#'.@/
  " let blinks = 3
  " for n in range(1,blinks)
    " let ring = matchadd('ErrorMsg', target_pat, 101)
    " redraw
    " exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 700) . 'm'
    " call matchdelete(ring)
    " redraw
    " exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 700) . 'm'
  " endfor
" endfunction

" Mouse

" Let pasting from middle click buffer work properly
" set paste


" Set title to Vim for xterm systems
set title

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set wildchar=<Tab> wildmenu wildmode=full


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

" remap ; to : and : to ;
" nnoremap ; :
" nnoremap : ;

" Make backspace work like most other apps
set backspace=eol,indent,start

" Shift-space as Esc - for gvim, vim requires mapping in terminal emulator config
" ..but doesn't work in gvim??
inoremap <S-Space> <Esc>
inoremap <C-c> <Esc>

" ` for one button save
map ` :w<CR>
" ¬ for one button save and exit
map ¬ :wq<CR>

" Backspace in normal mode
" (beeps on blank line due to l)
noremap <BS> i<BS><Esc>li

" Enter in normal to add a line below and escape back to normal
nnoremap <CR> i<CR><Esc>

" S pace from normal to insert with a space
nnoremap <Space> i <Esc>l


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
" noremap <leader><leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>


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

" inoremap <C-d> <Home>
" inoremap <C-c> <End>

" Fix Ctrl-left/right for jumping backwards/forwads a Word
noremap <silent> <Esc>Oc W
noremap <silent> <Esc>Od B
inoremap <silent> <Esc>Oc <C-O>W
inoremap <silent> <Esc>Od <C-O>B
" noremap [5D <C-Left>
" noremap [5C <C-Right>
" inoremap <ESC>[5D <C-left>
" inoremap <ESC>[5C <C-Right>

" Map numpad keys to numbers
imap <Esc>Oq 1
imap <Esc>Or 2
imap <Esc>Os 3
imap <Esc>Ot 4
imap <Esc>Ou 5
imap <Esc>Ov 6
imap <Esc>Ow 7
imap <Esc>Ox 8
imap <Esc>Oy 9
imap <Esc>Op 0
imap <Esc>On .
imap <Esc>OR *
imap <Esc>OQ /
imap <Esc>Ol +
imap <Esc>OS -


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
nnoremap <silent><leader>J m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader>K m`:silent -g/\m^\s*$/d<CR>``:noh<CR>

" :WW to sudo save file if it has opened as RO
" command W silent execute 'write !sudo tee ' . shellescape(@%, 1) . ' >/dev/null'
command! WW silent execute 'w !sudo tee %'
" after, vim indicates file hasn't saved and wants to reload
" but it has saved so you're safe to reload


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
" map <TAB> za
" interferes with <C-I> movement

" folding is on by default. setting a high fold start level stops this
set foldlevel=20


" Diff with saved file
" :diffsaved, :diffoff
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


" Make shift-insert work like in Xterm
" inoremap <MiddleMouse> <S-Insert>
" inoremap <MiddleMouse> <S-Insert>


""" Gvim
if has('gui_running')

set guifont=terminus\ 8
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guiheadroom=0 "make gvim not leave bottom border to gtk default background colour - doesn't work?! ARGH

endif


"" Alt-i, Alt-a - insert/append just one character
"" http://vim.wikia.com/wiki/Insert_a_single_character
" Since I have switched to Neovim in which Meta key bindings works even in the terminal, I used <M-i> and <M-a> as the shortcuts.
" If you are using original Vim on a terminal, you could use the trick provided by Tim Pope in his rsi.vim plugin to make the meta key work.
" let s:insert_char_pre = ''
" let s:insert_leave = ''
"
" autocmd InsertCharPre * execute s:insert_char_pre
" autocmd InsertLeave   * execute s:insert_leave
"
" " basic layer
" function! s:QuickInput (operator, insert_char_pre)
" let s:insert_char_pre = a:insert_char_pre
" let s:insert_leave = 'call <SID>RemoveFootprint()'
" call feedkeys(a:operator, 'n')
" endfunction
"
" function! s:RemoveFootprint()
" let s:insert_char_pre = ''
" let s:insert_leave = ''
" let s:char_count = 0
" endfunction
"
" " secondary layer
" function! QuickInput_Count (operator, count)
" let insert_char_pre = 'call <SID>CountChars('.a:count.')'
" call <SID>QuickInput(a:operator, insert_char_pre)
" endfunction
"
" let s:char_count = 0
" function! s:CountChars (count)
" let s:char_count += 1
" if s:char_count == a:count
  " call feedkeys("\<Esc>")
" endif
" endfunction
"
" " secondary layer
" function! QuickInput_Repeat (operator, count)
" let insert_char_pre = 'let v:char = repeat(v:char, '.a:count.') | call feedkeys("\<Esc>")'
" call <SID>QuickInput(a:operator, insert_char_pre)
" endfunction
"
" nnoremap i :<C-u>execute 'call ' v:count? 'QuickInput_Count("i", v:count)' : "feedkeys('i', 'n')"<CR>
" nnoremap a :<C-u>execute 'call ' v:count? 'QuickInput_Count("a", v:count)' : "feedkeys('a', 'n')"<CR>
"
" nnoremap <Plug>InsertAChar :<C-u>call QuickInput_Repeat('i', v:count1)<CR>
" nnoremap <Plug>AppendAChar :<C-u>call QuickInput_Repeat('a', v:count1)<CR>
"
" nmap <A-i> <Plug>InsertAChar
" nmap <M-a> <Plug>AppendAChar



" ACEJUMP
" Based on emacs' AceJump feature (http://www.emacswiki.org/emacs/AceJump).
" AceJump based on these Vim plugins:
"     EasyMotion (http://www.vim.org/scripts/script.php?script_id=3526)
"     PreciseJump (http://www.vim.org/scripts/script.php?script_id=3437)
" Type AJ mapping, followed by a lower or uppercase letter.
" All words on the screen starting with that letter will have
" their first letters replaced with a sequential character.
" Type this character to jump to that word.

highlight AceJumpGrey ctermfg=darkgrey guifg=lightgrey
highlight AceJumpRed ctermfg=darkred guibg=NONE guifg=black gui=NONE

function! AceJump ()
  " store some current values for restoring later
  let origPos = getpos('.')
  let origSearch = @/

  " prompt for and capture user's search character
  echo "AceJump to words starting with letter: "
  let letter = nr2char(getchar())
  " return if invalid key, mouse press, etc.
  if len(matchstr(letter, '\k')) != 1
    echo ""
    redraw
    return
  endif
  " redraws here and there to get past 'more' prompts
  redraw
  " row/col positions of words beginning with user's chosen letter
  let pos = []

  " monotone all text in visible part of window (dark grey by default)
  call matchadd('AceJumpGrey', '\%'.line('w0').'l\_.*\%'.line('w$').'l', 50)

  " loop over every line on the screen (just the visible lines)
  for row in range(line('w0'), line('w$'))
    " find all columns on this line where a word begins with our letter
    let col = 0
    let matchCol = match(' '.getline(row), '.\<'.letter, col)
    while matchCol != -1
      " store any matching row/col positions
      call add(pos, [row, matchCol])
      let col = matchCol + 1
      let matchCol = match(' '.getline(row), '.\<'.letter, col)
    endwhile
  endfor

  if len(pos) > 1
    " jump characters used to mark found words (user-editable)
    let chars = 'abcdefghijlkmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.;"[]<>{}|\\'

    if len(pos) > len(chars)
      " TODO add groupings here if more pos matches than jump characters
    endif

    " trim found positions list; cannot be longer than jump markers list
    let pos = pos[:len(chars)]

    " jumps list to pair jump characters with found word positions
    let jumps = {}
    " change each found word's first letter to a jump character
    for [r,c] in pos
      " stop marking words if there are no more jump characters
      if len(chars) == 0
        break
      endif
      " 'pop' the next jump character from the list
      let char = chars[0]
      let chars = chars[1:]
      " move cursor to the next found word
      call setpos('.', [0,r,c+1,0])
      " create jump character key to hold associated found word position
      let jumps[char] = [0,r,c+1,0]
      " replace first character in word with current jump character
      exe 'norm r'.char
      " change syntax on the jump character to make it highly visible
      call matchadd('AceJumpRed', '\%'.r.'l\%'.(c+1).'c', 50)
    endfor
    call setpos('.', origPos)

    " this redraw is critical to syntax highlighting
    redraw

    " prompt user again for the jump character to jump to
    echo 'AceJump to words starting with "'.letter.'" '
    let jumpChar = nr2char(getchar())

    " get rid of our syntax search highlighting
    call clearmatches()
    " clear out the status line
    echo ""
    redraw
    " restore previous search register value
    let @/ = origSearch

    " undo all the jump character letter replacement
    norm u

    " if the user input a proper jump character, jump to it
    if has_key(jumps, jumpChar)
      call setpos('.', jumps[jumpChar])
    else
      " if it didn't work out, restore original cursor position
      call setpos('.', origPos)
    endif
  elseif len(pos) == 1
    " if we only found one match, just jump to it without prompting
    " set position to the one match
    let [r,c] = pos[0]
    call setpos('.', [0,r,c+1,0])
  elseif len(pos) == 0
    " no matches; set position back to start
    call setpos('.', origPos)
  endif
  " turn off all search highlighting
  call clearmatches()
  " clean up the status line and return
  echo ""
  redraw
  return
endfunction

nnoremap <Leader>f :call AceJump()<CR>


" mode specific cursors, vte method
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


" provide hjkl movements in Insert mode via the <Alt> modifier key
" https://stackoverflow.com/questions/1737163/traversing-text-in-insert-mode
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

" Alt-b/w for backward/forward word in Insert mode
inoremap <A-b> <C-o>b
inoremap <A-w> <C-o>w


" If you select one or more lines, you can use < and > for shifting them sidewards. Unfortunately you immediately lose the selection afterwards. You can use gv to reselect the last selection (see :h gv), thus you can work around it like this:
xnoremap <  <gv
xnoremap >  >gv


" make CTRL-K list diagraphs before each digraph entry
inoremap <expr> <C-K> ShowDigraphs()

function! ShowDigraphs ()
    digraphs
    call getchar()
    return "\<C-K>"
endfunction

" But also consider the hudigraphs.vim and betterdigraphs.vim plugins,
" which offer smarter and less intrusive alternatives
