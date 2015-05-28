require 'fileutils'
include FileUtils

desc "Install everything"
task :install do
  sh "mkdir -p ~/._backup"

  %w(vim vimrc gvimrc gitconfig gitignore profile prompt alias gemrc).each do |name|
    path = File.join(ENV["HOME"], ".#{name}")
    if (File.file?(path) || File.directory?(path)) && !File.symlink?(path)
      sh %Q(mv ~/.#{name} ~/._backup/#{name})
    end

    if !File.symlink?(path)
      sh %Q(ln -s `pwd`/#{name} ~/.#{name})
    end
  end
end
