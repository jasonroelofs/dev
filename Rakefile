require 'fileutils'
include FileUtils

desc "Install everything"
task :everything do
  sh %q(mv ~/.vim ~/.vim_bak) if File.directory?("~/.vim")
  sh %q(ln -s `pwd`/vim ~/.vim)
  sh %q(echo "source ~/.vim/common-vimrc.vim" >> ~/.vimrc)
  sh %q(echo "source ~/.vim/common-gvimrc.vim" >> ~/.gvimrc)
end
