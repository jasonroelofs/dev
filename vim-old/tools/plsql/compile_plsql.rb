filename =  ARGV[0]

arr = []
arr << "set serveroutput on;\nset timing on;\n"
arr << File.open(filename).readlines
arr << "/\nshow errors;\nexit;"

File.open(filename,'w') do |file|
	arr.each do |line|
		file.write line
	end
end
