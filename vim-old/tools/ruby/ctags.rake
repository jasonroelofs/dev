desc "Generate CTags file by searching all Ruby files"
task :ctags do
  require 'find'
  ruby_files = []
  Find.find('.') do |f|
    ruby_files << f if f =~ /\.rb$/
  end
  sh %|ctags #{ruby_files.join(' ')}|
end
