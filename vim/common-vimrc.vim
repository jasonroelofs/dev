" line/char info in lower right of screen
:set ruler

"Color scheme (use tab-completion to learn other options)
:colorscheme koehler

" syntax highlighting
:syntax on

" Pathogen
call pathogen#runtime_append_all_bundles()

"Share the system clipboard
:set clipboard=unnamed
:set incsearch
:set background=dark

" Omnicompletion
:set completefunc=rubycomplete#Complete

" Tab config
:set tabstop=2
:set shiftwidth=2
:set backspace=indent,eol,start
:set expandtab

" ignorecase and smartcase allow for easier searching
:set ignorecase
:set smartcase

" From http://items.sjbach.com/319/configuring-vim-right
:runtime macros/matchit.vim
:set title
:set scrolloff=2
:set wildmenu
:set wildmode=list:longest
:set expandtab

:set completeopt=longest,menu


" Do not highlight search match
:set nohlsearch
:map ,hl :set hlsearch<CR>
:map ,nhl :set nohlsearch<CR>

" Can clear out all crazy extra whitespace in a file
:map ,s :%s/\s\+$//<CR>

" Kill bells
:set vb t_vb=


" Set the ctags file
:set tags=tags

" Remap F1 to be 'write' instead of 'help', because I keep bumping it
:map <F1> :w<CR>
" Remap F2 to be 'write', just like any good editor
:map <F2> :w<CR>

"
" Editing shortcuts and mappings
"
" Format entire buffer with indents
:map ,i mzggvG='z
:map \ft :retab<CR>

"Buffer next,previous
:noremap  :bn
:noremap  :bp
"
"Buffer delete
:noremap  :bd

" Format paragraph
:noremap Q gqj

" Typo fixits
:cabbr W w
:cabbr Q q

" Manually activate xml syntax highlighting
:cabbr xmlon set syn=xml


" Make ',e' (in normal mode) give a prompt for opening files
" in the same dir as the current buffer's file.
if has("unix")
  map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
  map ,e :e <C-R>=expand("%:p:h") . "\\" <CR>
endif

" Make ',l' change vim's working directory to that of the current buffer
if has("unix")
  map ,l :cd <C-R>=expand("%:p:h") . "/" <CR><CR>
else
  map ,l :cd <C-R>=expand("%:p:h") . "\" <CR><CR>
endif


" Camel-hump case boundary detection
map ,w cv/[a-z][A-Z^\n^ ^\t^(^[^.^_]<CR>

map ,nw :set nowrap<CR>
map ,dw :set wrap<CR>

"Vertical split then hop to new buffer
:noremap ,v :vsp
"Make current window the only one
:noremap ,o :only
"Apply next/previous-word-occurance (* and #) to CTRL-mousewheel
:noremap <C-MouseUp> *
:noremap <C-MouseDown> #
"Kill the current buffer but keep its window open (useful for keeping splits)
:noremap ,kb :sp:bn:bd

" Shortcut to make the current file executable
:command! Chmod !chmod +x %

" ~/snip is a junk file; call it a customized clipboard
" Write to snip.  Either uses current visual selection, or entire buffer
:noremap  \ws :w! ~/snip<cr>
" Read contents of snip into current buffer
:noremap  \rs :r ~/snip<cr>
" Edit the snip file
:noremap  \es :e ~/snip<cr>
" Append to the snip file
:noremap  \as :w! >> ~/snip<cr>

" Activate and process ftplugin scripts
:filetype off
:filetype plugin on
:filetype indent on 

:noremap ,hex :set bin<CR>:%!xxd<CR>:set syn=xxd<CR>
:noremap ,nohex :%!xxd -r<CR>:set nobin<CR>

:noremap \pe :!p4 edit %<CR>

map <F9> :only<CR>:w<CR>:!rake 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>
map <F10> :only<CR>:w<CR>:!rake test:units 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>
map <F11> :only<CR>:w<CR>:!rake test:integration 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>
map <F12> :only<CR>:w<CR>:!rake test:migration 2>&1 \| tee ~/tmp/.rubyrun.out<CR>:sp ~/tmp/.rubyrun.out<CR><CR>

