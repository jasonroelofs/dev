require 'fileutils'
include FileUtils

desc "Install everything"
task :everything => [:vim, :git] 

desc "Install .vim" 
task :vim do
  sh %q(mv ~/.vim ~/.vim_bak) if File.directory?("~/.vim")
  sh %q(ln -s `pwd`/vim ~/.vim)
  sh %q(echo "source ~/.vim/common-vimrc.vim" >> ~/.vimrc)
  sh %q(echo "source ~/.vim/common-gvimrc.vim" >> ~/.gvimrc)
end

desc "Install git configs"
task :git do
  sh %q(move ~/.gitconfig ~/.gitconfig_bak) if File.exists?("~/.gitconfig")
  sh %q(ln -s `pwd`/gitconfig ~/.gitconfig)
end
