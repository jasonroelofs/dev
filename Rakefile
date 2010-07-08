require 'fileutils'
include FileUtils

desc "Install everything"
task :everything => [:vim, :git, :shell] 

desc "Install .vim" 
task :vim do
  sh %q(mv ~/.vim ~/.vim_bak) if File.directory?("~/.vim")
  sh %q(ln -s `pwd`/vim ~/.vim)
  sh %q(echo "source ~/.vim/common-vimrc.vim" >> ~/.vimrc)
  sh %q(echo "source ~/.vim/common-gvimrc.vim" >> ~/.gvimrc)
end

desc "Install git configs"
task :git do
  %w(gitconfig gitignore).each do |file|
    sh %Q(mv ~/.#{file} ~/.#{file}_bak) if File.exists?("~/.#{file}")
    sh %Q(ln -s `pwd`/#{file} ~/.#{file})
  end
end

desc "Install shell customizations"
task :shell do
  sh %q(mv ~/.alias ~/.alias_bak) if File.exists?("~/.alias")
  sh %q(ln -s `pwd`/alias ~/.alias)
end
