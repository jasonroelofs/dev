"""""""""""""""""""""""""""
""" Vim Global Configs  """
"""""""""""""""""""""""""""

set nocompatible
set encoding=utf-8
set title
set hidden

filetype off
call plug#begin()

" Vim improvements
Plug 'Lokaltog/powerline'
Plug 'altercation/vim-colors-solarized'

" tpope
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

" Languages / Syntax
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Go
Plug 'fatih/vim-go'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'

call plug#end()

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

" Close all other splits than mine
:map <leader>o :only<CR>

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

" Keep scratch buffer from showing up in autocomplete calls
set completeopt-=preview

""""""""""""""""""""""""""""
""" File Type Assoc      """
""""""""""""""""""""""""""""
au BufRead,BufNewFile {Gemfile,Rakefile,*.rake} set ft=ruby
au BufNewFile,BufRead *.json set ft=javascript
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.vp,*.fp,*.gp,*.vs,*.fs,*.gs,*.tcs,*.tes,*.cs,*.vert,*.frag,*.geom,*.tess,*.shd,*.gls,*.glsl set filetype=glsl330

""""""""""""""""""""""""""""
""" Plugin Configuration """
""""""""""""""""""""""""""""

""" Powerline """
let g:Powerline_symbols='fancy'
let g:Powerline_themer='skwp'
let g:Powerline_colorscheme='skwp'

""" Syntastic """
set statusline+=%#warningmsg#
set statusline+=%*

let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 0

" Disable automatic checking on :w for some filetypes that are
" just annoyingly slow to run.
let g:syntastic_mode_map = { "passive_filetypes": ["slim", "sass", "scss"] }

""""""""""""""""""""""""""
""" CoC Config """""""""""
""""""""""""""""""""""""""

" https://github.com/neoclide/coc.nvim?tab=readme-ov-file

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)
