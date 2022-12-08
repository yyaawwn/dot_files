filetype off                  " required

"for YongZhou by YongZhou 
" set the runtime path to include Vundle and initialize
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this lineg



let $PAGER=''
set paste
set history=100
set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
set showcmd
color darkblue
set hlsearch
set wildmenu
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set autoindent
set nottimeout ttimeoutlen=200
set incsearch
set showmatch
"set smarttab
set shiftwidth=4
"set tabstop=4
set lbr
set tw=500
set ai
set si
set wrap
set linespace=0
set gdefault
set title 							
set smartindent 				
hi CursorColumn guibg=#333333   " highlight cursor
hi MatchParen cterm=none ctermbg=green ctermfg=blue
map j gj
map k gk
map <space> /
map <c-space> ?
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
syntax on
set so=5
set undolevels=1000
if has ('mouse')
    set mouse=a
endif

if has('statusline')
    set laststatus=2
    set number
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=\ [%{&ff}/%Y]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif
cmap W w 						
cmap WQ wq
cmap wQ wq
cmap Q q

