filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Vim improvements
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/powerline'
Plugin 'ervandew/supertab'
Plugin 'altercation/vim-colors-solarized'
Plugin 'emilford/vim-sweeter-vest'

" tpope
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'

" Languages / Syntax
Plugin 'scrooloose/Syntastic'
Plugin 'fatih/vim-go'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'othree/html5.vim'
Plugin 'wting/rust.vim'
Plugin 'cespare/vim-toml'
Plugin 'slim-template/vim-slim'

call vundle#end()
