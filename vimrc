"""""""""""""""""""""""""""
""" Vim Global Configs  """
"""""""""""""""""""""""""""

set nocompatible
set encoding=utf-8
set title
set hidden

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
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

" Command for running `par` to format blocks of text
map <leader>f {!}par w80qrg<cr>

" Keep scratch buffer from showing up in autocomplete calls
set completeopt-=preview

""""""""""""""""""""""""""""
""" File Type Assoc      """
""""""""""""""""""""""""""""
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,config.ru,*.rake} set ft=ruby
au BufNewFile,BufRead *.json set ft=javascript
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.vp,*.fp,*.gp,*.vs,*.fs,*.gs,*.tcs,*.tes,*.cs,*.vert,*.frag,*.geom,*.tess,*.shd,*.gls,*.glsl set filetype=glsl330
au BufRead,BufNewFile *.tpl,*.incl set ft=smarty
au BufRead,BufNewFile *.red set ft=rebol
" TEMP! Until I figure out a name for my new language
" and put together its own syntax highlighting
au BufRead,BufNewFile *.lang set ft=ruby

""""""""""""""""""""""""""""
""" Plugin Configuration """
""""""""""""""""""""""""""""

""" Ag """
set grepprg=ag\ --nogroup\ --nocolor

""" Ctrl-P """
let g:ctrlp_working_path_mode = 0
let g:ctrlp_show_hidden = 0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_use_caching = 1
let g:ctrlp_max_files = 150000
let g:ctrlp_match_window = 'top,order:ttb'
let g:ctrlp_map = '<D-p>'

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

""" Deoplete """
let g:python3_host_prog = "/usr/local/bin/python3"
let g:deoplete#enable_at_startup = 1

""" Ale """
let g:ale_linters = {}
let g:ale_fixers = {}
let g:ale_linters.javascript = ['eslint']
let g:ale_fixers.javascript = ['eslint']
let g:ale_fix_on_save = 1

" Sorbet "
if fnamemodify(getcwd(), ':p') == $HOME.'/stripe/pay-server/'
  call ale#linter#Define('ruby', {
  \ 'name': 'sorbet-lsp',
  \ 'lsp': 'stdio',
  \ 'executable': 'true',
  \ 'command': 'pay exec scripts/bin/typecheck --lsp -v',
  \ 'language': 'ruby',
  \ 'project_root': $HOME . '/stripe/pay-server',
  \ })

  let g:ale_linters.ruby = ['sorbet-lsp']
end

" Bind <leader>d to go-to-definition.
nmap <leader>d <Plug>(ale_go_to_definition)
