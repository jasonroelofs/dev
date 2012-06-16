"""""""""""""""""""""""""""
""" Vim Global Configs  """
"""""""""""""""""""""""""""

runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

set nocompatible
set encoding=utf-8
set title

let mapleader=","

" Share system clipboard
set clipboard=unnamed

" Look and Feel
syntax on
colorscheme koehler
set background=dark
set number
set ruler

" Turn off error / visual bell
set noerrorbells
set visualbell t_vb=

set history=200
set undolevels=1000

set fileformats=unix,dos,mac

" Search settings
set nohlsearch
set incsearch
set ignorecase
set smartcase

" Tabbing and indenting
set autoindent smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set copyindent
set preserveindent

filetype on
filetype indent on
filetype plugin on

" Command Tab completion
set wildmenu
set wildmode=list:longest

set backspace=2
set showmatch

" Highlight extraneous whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Custom File types handling
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,config.ru,*.rake} set ft=ruby
au BufNewFile,BufRead *.json set ft=javascript

"""""""""""""""""""""""""""
""" Global key mappings """
"""""""""""""""""""""""""""

noremap ; :
noremap j gj
noremap k gk

" Typo fixits
:cabbr W w
:cabbr Q q

" Clear out all extra whitespace in a file
:map <leader>s :%s/\s\+$//<CR>

" Format entire buffer with indents
:map <leader>i mzggvG='z
:map \ft :retab<CR>

" Ctrl-h/j/k/l for easy window movement
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Buffer management
noremap  :bn
noremap  :bp
noremap  :bd

" Make ',e' (in normal mode) give a prompt for opening files
" in the same dir as the current buffer's file.
if has("unix")
  map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
else
  map <leader>e :e <C-R>=expand("%:p:h") . "\\" <CR>
endif

""""""""""""""""""""""""""""
""" Plugin Configuration """
""""""""""""""""""""""""""""

""" NERDTree """
" Start in NerdTree if no file given on boot
autocmd vimenter * if !argc() | NERDTree | endif
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHijackNetrw = 0
let NERDTreeMouseMode=2
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.class$', '\.o', '\~$']

""" Powerline """
let g:Powerline_symbols='fancy'
let g:Powerline_themer='skwp'
let g:Powerline_colorscheme='skwp'
