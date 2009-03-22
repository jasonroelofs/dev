#!/usr/bin/ruby

require 'fileutils'
require 'find'
require 'ostruct'

def run
	func = ARGV.shift
	from_file = ARGV.shift
	unless func and from_file
		puts "Usage: source_navigation.rb <navigation> <file>"
		exit 1
	end
	if func == 'object_def'
		obj_name = ARGV.shift
		print SourceNavigation.new.find_file_for_object_name(from_file,obj_name)
	else
		print SourceNavigation.new.go(func,from_file)
	end
end

class SourceNavigation
	include FileUtils

	def go(func,from_file)
		if func == 'object_def'
			object_def from_file
		else
			raise "No support for '#{func}' navigation." unless respond_to?(func)
			send func, FileInfo.new(from_file)
		end
	end

	def test(info)
		return info.full_file if info.is_unit_test?
    [ 
      info.proj_home + "/test/units",
      info.proj_home + "/test/functional",
      info.proj_home + "/test",
      info.proj_home
    ].each do |topdir|
      next unless File.directory?(topdir)
      Find.find(topdir) { |f|
        Find.prune if File.basename(f) =~ /^proto/
        return f if File.basename(f) == "#{info.file_without_extension}_test.rb"
      }
    end
	end

	def source(info)
		return info.full_file unless info.is_unit_test?
    [ 
      info.proj_home + "/lib",
      info.proj_home + "/app/controllers",
      info.proj_home + "/app/models",
      info.proj_home
    ].each do |topdir|
      next unless File.directory?(topdir)
      Find.find(topdir) { |f|
        Find.prune if File.basename(f) =~ /^proto/
        return f if File.basename(f,'.rb') == File.basename(info.file,'_test.rb')
      }
    end
	end

	def proj_home(info)
		info.proj_home
	end

	def objects(info)
		fname = File.join(info.proj_home,'config','objects.yml')
		return fname if File.exists?(fname)

		fname = File.join(info.src_dir,'objects.yml') 
		return fname if File.exists?(fname)

		fname = nil

		Dir["#{info.proj_home}/bin/*.yml"].each do |path|
			return path if path =~ /\.yml$/
		end

		Dir["#{info.src_dir}/*.yml"].each do |path|
			return path if path =~ /\.yml$/
		end
		
		Find.find(info.src_dir) do |path|
      Find.prune if File.basename(f) =~ /^proto/
			return path if path =~ /\.yml$/
		end
		return nil
	end

	def rakefile(info)
		File.join(info.proj_home,'Rakefile')
	end

	def object_factory(info)
		File.join(info.src_dir,'object_factory.rb')
	end

	def test_helper(info)
		File.join(info.proj_home, 'test/test_helper.rb')
	end

	def find_file_for_object_name(from_file,obj_name)
		info = FileInfo.new(from_file)
		Find.find(info.src_dir) do |f|
      Find.prune if File.basename(f) =~ /^proto/
			return f if File.basename(f) == "#{underscore obj_name}.rb"
		end
		from_file
	end

  def underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
  end

	class FileInfo
		include FileUtils
		attr_accessor :full_file, :path, :file, :file_without_extension
		attr_accessor :proj_home, :src_dir, :unit_test_dir, :offset_dir

		def initialize(full_file)
			@file_separator = '/'
			@full_file = full_file
			@path, @file = separate_path_from_file(@full_file)
			@file_without_extension = @file.sub(/\..*?$/,'')
			
			@proj_home = find_proj_home(@path)
			@src_dir = find_src_dir(@proj_home)
			@unit_test_dir = find_unit_test_dir(@proj_home)
			@offset_dir = determine_offset_dir(@path, @file, @src_dir, @unit_test_dir)
		end

		def is_unit_test?
			@file =~ /_test\.rb$/
		end

		def separate_path_from_file(fname)
			raise "Cannot parse '#{fname}'" unless fname =~ /^(.*)#{@file_separator}(.*?)$/
			return $1,$2
		end

		def find_proj_home(path)
			in_directory path do
				while pwd != '/'
					cd ".."
					return pwd if File.directory?("test") or File.directory?("testsrc")
#					return pwd if File.directory?("src") and File.directory?("test")
				end
				raise "Couldn't find your project root"
			end
		end

		def find_src_dir(proj_home)
			src_dir = File.join(proj_home, 'src')
			src_dir = File.join(proj_home, 'lib') unless File.directory?(src_dir)
			raise "No directory #{src_dir}" unless File.directory?(src_dir)
			src_dir
		end

		def find_unit_test_dir(proj_home)
			test_dir = File.join(proj_home, 'test')
			raise "No directory #{test_dir}" unless File.directory?(test_dir)
			unit_sub = File.join(test_dir, 'unit')
			test_dir = unit_sub if File.directory?(unit_sub)
			test_dir
		end

		def determine_offset_dir(path,file,src_dir,unit_test_dir)
			if file =~ /_test\.rb$/
				path.sub(/#{unit_test_dir}/,'')
			else
				path.sub(/#{src_dir}/,'').sub(/^\//,'')
			end
		end

		def in_directory(dir)
			saved_wd = pwd
			cd dir
			yield
		ensure
			cd saved_wd
		end
	end
end

run if __FILE__ == $0

#print SourceNavigation.new.find_file_for_object_name("/Users/crosby/svn/lds/src/objects.yml", "auto_pilot_model")
__END__
from_file = '/Users/crosby/svn/lds/src/draft_office.rb'
%w|source test proj_home objects rakefile object_factory test_helper object_def|.each do |func|
	print func 
	print " "
	print SourceNavigation.new.go(func,from_file)
	print "\n"
end
