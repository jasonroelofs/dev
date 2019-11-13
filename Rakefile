require 'fileutils'
include FileUtils

desc "Install everything"
task :install do
  sh "mkdir -p ~/._backup"

  %w(vim vimrc gvimrc gitconfig gitignore profile prompt alias gemrc pryrc).each do |name|
    path = File.join(ENV["HOME"], ".#{name}")
    if (File.file?(path) || File.directory?(path)) && !File.symlink?(path)
      sh %Q(mv ~/.#{name} ~/._backup/#{name})
    end

    if !File.symlink?(path)
      sh %Q(ln -s `pwd`/#{name} ~/.#{name})
    end
  end

  puts "Setting up Python for MacVim + deoplete. Python3 required"
  sh "python3 -m pip install pynvim"

  puts "Install Vundle for vim plugin management"
  sh "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"

  [
    # Enable Bundles in Mail
    "defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist EnableBundles -bool true",
    "defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist BundleCompatibilityVersion -int 4"
  ].each do |option|
    sh option
  end

  puts "", "Ready! Jump into vim and run :BundleInstall to get all plugins", ""
end
