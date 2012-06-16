#!/usr/bin/ruby

#
# Takes a block of text on stdin.  Each line is a descriptor for a unit test case.
# The line will be converted into the name of a unit test case method.
# The text of the line is down-cased and underscored and prepended with the word 'test'
#


input = STDIN.read
cases = input.split(/\n/).map do |x| x.strip.downcase.gsub(/\s+/,'_') end

cases.each do |x| 
	%|def test_#{x}\n  flunk "implement me"\nend\n|.each_line do |l|
		puts "  #{l}"
	end
	puts
end
