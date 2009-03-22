require 'fileutils'
include FileUtils

class FindTags
  def find_tags(dir=nil)
    dir ||= "."
    return nil if File.expand_path(dir) == "/" # hit the top
    cd dir
    entries = Dir["tags"]
    return File.expand_path(entries.first) unless entries.empty?
    find_tags ".." # Recurse upward
  end
end

start = ARGV.shift
start = File.dirname(start) if start
tags_file = FindTags.new.find_tags(start)
print tags_file if tags_file
