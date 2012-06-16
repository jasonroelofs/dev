#!/usr/bin/ruby 

#
# "enclose in try-catch"
#


lines = STDIN.readlines("\n")
exit if lines.size <= 0

# determing leading whitespace
if lines[0] =~ /^(\s+)/
  lws = $1
else
  lws = ""
end

lines.each do |x| x.gsub!(/(\s*)$/, "") end

output =  <<MARK
try
{
#{lines.join("\n")}
} 
catch(Exception ex)
{
} 
MARK

output.each_line do |x| puts "#{lws}#{x}" end


