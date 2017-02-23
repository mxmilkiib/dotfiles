" Vim confiruration file
" milk <dotconfig@milkmiruku.com>

""" Init pathogen
"call pathogen#runtime_append_all_bundles()
"call pathogen#helptags()

" Neobundle script manager
filetype off                   " Required!
filetype plugin indent off     " Required!

if has('vim_starting')
  if &compatible
    " Use Vim defaults instead of 100% vi compatibility
    set nocompatible
  endif

    set runtimepath+=~/.vim/bundle/neobundle.vim
" set runtimepath+=~/.vim/bundle/neobundle.vim/,/usr/share/vim/vim72
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" call neobundle#end()

" Let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'


" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

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

" NeoBundle 'ap/vim-css-color.git'

NeoBundle 'chrisbra/Colorizer'

autocmd VimEnter * ColorToggle


" NeoBundle 'cakebaker/scss-syntax.vim'
" NeoBundle 'vim-scripts/Better-CSS-Syntax-for-Vim' - fuxks with scss :(

NeoBundle 'pangloss/vim-javascript'

" NeoBundle 'StanAngeloff/php.vim'

NeoBundle 'Valloric/MatchTagAlways'

" NeoBundle 'hallettj/jslint.vim'
" NeoBundle 'joestelmach/lint.vim'

" NeoBundle 'sleistner/vim-jshint'
NeoBundle 'wookiehangover/jshint.vim'

NeoBundle 'baskerville/vim-sxhkdrc'

NeoBundle 'chase/nginx.vim'

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

" Open files and buffers
NeoBundle 'wincent/Command-T'

" File navigation
" Jump to word using characters <leader>w (like f in vimium)
" NeoBundle 'Lokaltog/vim-easymotion'
" let g:EasyMotion_leader_key = '<leader>'

" NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'

NeoBundle 'svermeulen/vim-extended-ft'

NeoBundle 'myusuf3/numbers.vim'
nnoremap <leader>n :NumbersToggle<CR>

" Startup

" NeoBundle 'mhinz/vim-startify'


" Large interface

" Tiling buffer window manager
" Ctrl-j/k/space/...
NeoBundle 'spolu/dwm.vim'


" New staus line tool
" NeoBundle 'Lokaltog/powerline'
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
NeoBundle 'bling/vim-airline'


" Manage multiple files with ease
NeoBundle 'scrooloose/nerdtree'
" \p - toggle nerdtree
" nmap <silent> <leader>p :NERDTreeToggle<CR>
" Close Vim if only NERDtree buffer is open
" https://github.com/scrooloose/nerdtree/issues/21
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | en

" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <leader>p :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction



augroup AuNERDTreeCmd
  autocmd!
augroup end

if has('gui_running')
  " autocmd! NERDTreeHijackNetrw 
  autocmd! NERDTreeTabs
  autocmd! NERDTree
endif

" Tabs
NeoBundle 'jistr/vim-nerdtree-tabs'
map <Leader>o <plug>NERDTreeTabsToggle<CR>

NeoBundle 'benatkin/vim-move-between-tabs'
NeoBundle 'maxmeyer/vim-tabreorder'


" Manage tab workspaces
" NeoBundle 'sjbach/lusty'


" Minimal GUI
NeoBundle 'junegunn/goyo.vim'
" NeoBundle 'amix/vim-zenroom2'


" Doesn't work right with Awesome
NeoBundle 'xolox/vim-misc'
" NeoBundle 'xolox/vim-lua-inspect'


" Zen coding like - see emmet.io
NeoBundle 'mattn/emmet-vim'


" Yank ring
" NeoBundle 'vim-scripts/YankRing.vim'
" 2p, paste sedonc last delete


" Git integration
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'


" NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'mhinz/vim-signify'


""" to sort

" Open files easily
"NeoBundle 'git://git.wincent.com/command-t.git'


" NeoBundle 'xolox/vim-session'
" :SaveSession, :OpenSession, :RestartVim, etc.
" let g:session_autosave = 'no'

NeoBundle 'tpope/obsession.vim'

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
" NeoBundle 'Valloric/YouCompleteMe'



" Color theme
NeoBundle 'BlackSea'
colorscheme BlackSea

call neobundle#end()

" NeoBundle required
" Basic syntax highlighting
if has("syntax")
  syntax on
  filetype on
  filetype plugin on
  filetype indent on
endif

" NeoBundleCheck


""" General

" Send more characters for redraws
set ttyfast

" Enable terminal mouse support
set ttymouse=xterm2
" Enable mouse use in all modes
set mouse=a

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



" Cursor

" Show the cursor position all the time
set ruler

" Show horizontal line that the cursor is on
set cursorline

" Change cursorline highlight from underline to colour bar
:hi CursorLine term=bold cterm=bold guibg=Grey40



" Mouse

" Let pasting from middle click buffer work properly
set paste





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
" ..but doesn't work in gvim??
imap <S-Space> <Esc>
imap <C-c> <Esc>

" ` for : to avoid shift
map ` :w<CR>

" Backspace in normal mode
" (beeps on blank line due to l)
noremap <BS> i<BS><Esc>li

" Space from normal to insert with a space
nnoremap <Space> i <Esc>

" Enter in normal to add a line below and escape back to normal
nmap <CR> o<Esc>

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

  set guifont=terminus\ 8
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
  set guiheadroom=0 "make gvim not leave bottom border to gtk default background colour - doesn't work?! ARGH

endif



"" Alt-i, Alt-a - insert/append just one character
"" http://vim.wikia.com/wiki/Insert_a_single_character
" Since I have switched to Neovim in which Meta key bindings works even in the terminal, I used <M-i> and <M-a> as the shortcuts. If you are using original Vim on a terminal, you could use the trick provided by Tim Pope in his rsi.vim plugin to make the meta key work.

let s:insert_char_pre = ''
let s:insert_leave = ''

autocmd InsertCharPre * execute s:insert_char_pre
autocmd InsertLeave   * execute s:insert_leave

" basic layer
function! s:QuickInput (operator, insert_char_pre) 
    let s:insert_char_pre = a:insert_char_pre
    let s:insert_leave = 'call <SID>RemoveFootprint()'
    call feedkeys(a:operator, 'n')
endfunction 

function! s:RemoveFootprint() 
    let s:insert_char_pre = ''
    let s:insert_leave = ''
    let s:char_count = 0
endfunction 

" secondary layer
function! QuickInput_Count (operator, count) 
    let insert_char_pre = 'call <SID>CountChars('.a:count.')'
    call <SID>QuickInput(a:operator, insert_char_pre)
endfunction 

let s:char_count = 0
function! s:CountChars (count) 
    let s:char_count += 1
    if s:char_count == a:count
        call feedkeys("\<Esc>")
    endif
endfunction 

" secondary layer
function! QuickInput_Repeat (operator, count) 
    let insert_char_pre = 'let v:char = repeat(v:char, '.a:count.') | call feedkeys("\<Esc>")'
    call <SID>QuickInput(a:operator, insert_char_pre)
endfunction 

nnoremap i :<C-u>execute 'call ' v:count? 'QuickInput_Count("i", v:count)' : "feedkeys('i', 'n')"<CR>
nnoremap a :<C-u>execute 'call ' v:count? 'QuickInput_Count("a", v:count)' : "feedkeys('a', 'n')"<CR>

nnoremap <Plug>InsertAChar :<C-u>call QuickInput_Repeat('i', v:count1)<CR>
nnoremap <Plug>AppendAChar :<C-u>call QuickInput_Repeat('a', v:count1)<CR>

nmap <M-i> <Plug>InsertAChar
nmap <M-a> <Plug>AppendAChar



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
