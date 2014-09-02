filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Vim improvements
Plugin 'wincent/Command-T'
Plugin 'Lokaltog/powerline'
Plugin 'ervandew/supertab'
Plugin 'altercation/vim-colors-solarized'
Plugin 'AndrewRadev/splitjoin.vim'

" tpope
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-dispatch'

Plugin 'emilford/vim-sweeter-vest'

" Languages / Syntax
Plugin 'Syntastic'
Plugin 'jnwhiteh/vim-golang'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'beyondmarc/glsl.vim'
Plugin 'rosstimson/bats.vim'
Plugin 'othree/html5.vim'
Plugin 'wting/rust.vim'
Plugin 'nosami/Omnisharp'
Plugin 'cespare/vim-toml'

call vundle#end()
