#!/usr/bin/ruby 

#
# "break-out declaration"
#
# Eg:
#   Input: 
#     InstrumentResponse instResponse = something();
#   Output: 
#     InstrumentResponse instResponse = null;
#     instResponse = something();

s = STDIN.gets

# store leading whitespace
if s =~ /^(\s+)/
  lws = $1
else
  lws = ""
end

# trim
s.gsub!(/(^\s*|\s*$)/, "")

arr = s.split
type = arr.shift
name = arr.shift

output =<<MARKER
#{type} #{name} = null;
try
{
\t#{name} #{arr.join(" ")}
}
catch (Exception ex)
{
}
MARKER

output.each_line do |x|
  puts "#{lws}#{x}"
end
