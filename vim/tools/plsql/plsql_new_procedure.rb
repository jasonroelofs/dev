#!/usr/bin/env ruby 

line = gets
pattern = /(\w*)(\.*)(\w*)\s*_newProcedure/
proc_name = pattern.match(line)[1] + pattern.match(line)[2] + 
  pattern.match(line)[3]


if !(proc_name == "")
	output =<<-CODE
    PROCEDURE #{proc_name} (
       <param> <datatype>
    ) IS
    /**********************************************************************************************                   
      Procedure Name: #{proc_name} 
      Author        : Atomic Object LLC. (AUTHOR)
      Date          : #{Date.today.strftime('%m-%d-%Y')}	 
      Purpose       : 
      Parameters    : 
    ***********************************************************************************************/
    BEGIN
        -- Put your code here
    		NULL;
    EXCEPTION
        WHEN OTHERS THEN
					NULL;
    END #{proc_name};
	CODE
  print output
end

