"""""""""""""""""""""""""""
""" Vim Global Configs  """
"""""""""""""""""""""""""""

set nocompatible
set encoding=utf-8
set title
set hidden

filetype off
source ~/.vim/bundles.vim

filetype plugin indent on

let mapleader=","

" Share system clipboard
set clipboard=unnamed

" Look and Feel
syntax on
colorscheme koehler
set background=dark
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

" Command for running `par` to format blocks of text
map <leader>f {!}par w80qrg<cr>

""""""""""""""""""""""""""""
""" File Type Assoc      """
""""""""""""""""""""""""""""
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.vp,*.fp,*.gp,*.vs,*.fs,*.gs,*.tcs,*.tes,*.cs,*.vert,*.frag,*.geom,*.tess,*.shd,*.gls,*.glsl set filetype=glsl330

""""""""""""""""""""""""""""
""" Plugin Configuration """
""""""""""""""""""""""""""""

""" CommandT """
" Keybindings configured in gvimrc
let g:CommandTMaxHeight=20
let g:CommandTMatchWindowAtTop=1

""" Powerline """
let g:Powerline_symbols='fancy'
let g:Powerline_themer='skwp'
let g:Powerline_colorscheme='skwp'

""" Omnisharp """
let g:Omnisharp_stop_server=0

""" Sweeter Vest """
let g:clear_each_run = 1

" Run the current file with F5
noremap <F5> :SweeterVestRunFile<CR>
noremap <F6> :SweeterVestRunContext<CR>

""" YouCompleteMe """
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'rb': 1, 'go': 1, 'rs': 1, 'js': 1, 'coffee': 1 }
