filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Vim improvements
Plugin 'Lokaltog/powerline'
Plugin 'ervandew/supertab'
Plugin 'altercation/vim-colors-solarized'

" tpope
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'

" Languages / Syntax
Plugin 'sheerun/vim-polyglot'

" Go
Plugin 'fatih/vim-go'
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'

call vundle#end()
