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


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""" VimScript Manager
call plug#begin('~/.vim/plugged')

  """ Startup
  " Plug 'mhinz/vim-startify'

  " Brings :checkhealth from Neovim to :CheckHealth in Vim
  Plug 'rhysd/vim-healthcheck'

  " Defaults everyone can agree on
  Plug 'tpope/vim-sensible'


  """ Find things easily
  " fzf - populate a menu with things and f*i*l*t*e*r live with ripgrep
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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

  "  Lightning fast left-right movement in Vim
  Plug 'unblevable/quick-scope'

  " File navigation
  " Jump to word using characters <leader>w (like f in vimium)
  " Plug 'Lokaltog/vim-easymotion'
  " let g:EasyMotion_leader_key = '<leader>'

  " Plug 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'


  """ Coding

  " Provide insert mode nuto-completion for quotes, parens, brackets, etc.
  " Plug 'Raimondi/delimitMate'
  " Plug 'jiangmiao/auto-pairs'

  " Add/remove comments with ease
  " gcc or gc<motion>
  " or <leader>__
  " Plug 'tomtom/tcomment_vim'
  " Plug 'tpope/vim-commentary'
  Plug 'numToStr/Comment.nvim'


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
  Plug 'junegunn/vim-easy-align'
  " Start interactive EasyAlign for a motion/text object (i.e. gaip)
  nmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign in visual mode (i.e. vipga=)
  xmap ga <Plug>(EasyAlign)

  " Display sections in sidebar
  " Plug 'yazug/vim-taglist-plus'
  " required ctags installed


  " Enhanced autocompletion
  "Plug 'Shougo/neocomplcache'
  " Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

  " https://github.com/neoclide/coc.nvim
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  let g:coc_disable_startup_warning = 1

  " Visual help

  " Highlight yanked text
  " Plug 'sunaku/vim-highlightedyank'

  " Visually highlight matching opening & closing tags
  " Plug 'Valloric/MatchTagAlways'
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
  " <LEADER>ig
  " Plug 'nathanaelkane/vim-indent-guides'
  "let g:indent_guides_enable_on_vim_startup = 1
  Plug 'Yggdroot/indentLine'


  " Syntax highlighting and help

  " Colour parent and tags to indicate their depth
  " Plug 'luochen1990/rainbow'
  " let g:rainbow_active = 1

  Plug 'thiagoalessio/rainbow_levels.vim'
  " Creating a mapping to turn it on and off:
  map <leader>l :RainbowLevelsToggle<cr>
  " Or automatically turning it on for certain file types:
  " au FileType javascript,python,php,xml,yaml :RainbowLevelsOn
  " hi! RainbowLevel0 ctermbg=240 guibg=#585858
hi! RainbowLevel1 ctermbg=239 guibg=#4e4e4e
hi! RainbowLevel2 ctermbg=238 guibg=#444444
hi! RainbowLevel3 ctermbg=237 guibg=#3a3a3a
hi! RainbowLevel4 ctermbg=236 guibg=#303030
hi! RainbowLevel5 ctermbg=235 guibg=#262626
hi! RainbowLevel6 ctermbg=234 guibg=#1c1c1c
hi! RainbowLevel7 ctermbg=233 guibg=#121212
  hi! RainbowLevel8 ctermbg=232 guibg=#080808


  " Highlights operator characters for every language
  Plug 'Valloric/vim-operator-highlight'

  " A plugin to color colornames and codes
  Plug 'chrisbra/Colorizer'
  autocmd VimEnter * ColorToggle

  " Plug 'vim-syntastic/syntastic'
  " set statusline+=%#warningmsg#
  " set statusline+=%{SyntasticStatuslineFlag()}
  " set statusline+=%*

  " let g:syntastic_always_populate_loc_list = 1
  " let g:syntastic_auto_loc_list = 1
  " let g:syntastic_check_on_open = 1
  " let g:syntastic_check_on_wq = 0

  Plug 'w0rp/ale'
  let g:airline#extensions#ale#enabled = 1
  let g:ale_completion_enabled = 1

  " HTML5
  Plug 'othree/html5.vim'

  " Faust syntax highlighting
  " Plug 'gmoe/vim-faust'

  " Plug 'ap/vim-css-color.git'

  " Plug 'cakebaker/scss-syntax.vim'

  " Plug 'pangloss/vim-javascript'

  " Plug 'mxw/vim-jsx'

  " TypeScript
  " Plug 'HerringtonDarkholme/yats.vim'

  " Plug 'jparise/vim-graphql'

  " Plug 'StanAngeloff/php.vim'

  Plug 'chase/nginx.vim'

  " Arch Linux package definition file
  Plug 'Firef0x/PKGBUILD.vim'

  " Python coding style formatting
  " Plug 'tell-k/vim-autopep8'


  """ Lua related scripts
  " For vim-session and vim-lua-inspect and lua.vim (?)
  " Plug 'xolox/vim-misc'
  " Plug 'xolox/vim-lua-inspect'
  " Plug 'vim-scripts/lua.vim'

  " indent plugin, doensn't indent right when functions don't have a specific
  " linebreak format
  " Plug 'tbastos/vim-lua'
  "
  " Plug 'wsdjeg/vim-lua'
  " Plug 'idbrii/vim-lua'

  " indent and syntax plugin, doesn't unindent when functions are commented
  " out
  "Plug 'marcuscf/vim-lua'

  " badly opinionated formatting
  " Plug 'andrejlevkovitch/vim-lua-format'
  " autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
  " autocmd BufWrite *.lua call LuaFormat()
  "
  Plug 'https://gist.github.com/bonsaiviking/8845871.git'

  " Plug 'intrntbrn/awesomewm-vim-tmux-navigator'


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

  " Most recently used start screen
  Plug 'yegappan/mru'

  " Quick theme change
  Plug 'chxuan/change-colorscheme'
  nnoremap <silent> <F9> :PreviousColorScheme<cr>
  inoremap <silent> <F9> <esc> :PreviousColorScheme<cr>
  nnoremap <silent> <F10> :NextColorScheme<cr>
  inoremap <silent> <F10> <esc> :NextColorScheme<cr>
  nnoremap <silent> <F11> :RandomColorScheme<cr>
  inoremap <silent> <F11> <esc> :RandomColorScheme<cr>
  nnoremap <silent> <F12> :ShowColorScheme<cr>
  inoremap <silent> <F12> <esc> :ShowColorScheme<cr>

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
  " let g:airline_statusline_ontop=0

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
  Plug 'jistr/vim-nerdtree-tabs'
  map <Leader>o <plug>NERDTreeTabsToggle<CR>

  " Plug 'benatkin/vim-move-between-tabs'
  " tN and tP

  Plug 'maxmeyer/vim-tabreorder'
  " alt-pgup and alt-pgdown

  Plug 'vim-scripts/Tabmerge'
  " :Tabmerge [tab number/$] [top|bottom|left|right]

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
  " Plug 'vim-scripts/toggle_mouse'

  " ctrl/shift mouse click+drag over text copies/moves said text
  Plug 'vim-scripts/xemacs-mouse-drag-copy'


  " Synax for the sxhkd hotkey daemon
  " Plug 'baskerville/vim-sxhkdrc'
  " Plug 'kovetskiy/sxhkd-vim'


  """ Colour theme
  " Plug 'BlackSea'

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
  if !has('nvim')
    set ttymouse=xterm2
  endif
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
" set laststatus=2

" Notification message space
" set cmdheight= 1

" Always keep extra lines above the cursor at top, excluding ends of a file
set scrolloff=50

" Highlight 80th chatacter of a line
highlight ColorColumn ctermbg=darkgrey
call matchadd('ColorColumn', '\%81v', 100)

" Incremental search - moves as you type
" set incsearch

" Wrap searches
set wrapscan

" Case insensitive search for lowercase, case sensitive for upper
" http://stackoverflow.com/a/2288438
set ignorecase
set smartcase

" Disable automatic comment on new line
" set formatoptions-=r formatoptions-=c formatoptions-=o
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" history buffer to 1000 lines
set history=1000

" Set swap and backup dir
set backupdir=/tmp
set directory=/tmp

set ttimeoutlen=100 " wait up to 100ms after Esc for special key


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
set viminfo='10,\"100,:20,%,n~/.viminfo.old


""" Key settings and bindings
" N.b. I have urxvt pass shift-space as an esc


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



" Instead of stumbling into ex mode, repeat the last macro used.
nnoremap Q @@

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
  " return if invalid key, mouse press, etcj
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




" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
" set nobackup
" set nowritebackup

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>



" Move buffer to existing or new tab
" https://vim.fandom.com/wiki/Move_current_window_between_tabs
function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>




" remap ; to : and : to ;
" nmap ; :
" nnoremap : ;
" nnoremap ; :
" vnoremap : ;
" vnoremap ; :
noremap <Leader>; :<CR>
