#!/usr/bin/env ruby 

line = gets
pattern = /(\w*)(\.*)(\w*)\s*_newFunction/
func_name = pattern.match(line)[1] + pattern.match(line)[2] + 
  pattern.match(line)[3]


if !(func_name == "")
	output =<<-CODE
    FUNCTION #{func_name} (
       <param> <datatype>
    ) RETURN <datatype>
    /**********************************************************************************************                   
      Function Name : #{func_name} 
      Author        : Atomic Object LLC. (AUTHOR)
      Date          : #{Date.today.strftime('%m-%d-%Y')}	  
      Purpose       : 
      Parameters    : 
    ***********************************************************************************************/
    IS
        v_retval <datatype>;
    BEGIN
        -- Put code here
    		
        RETURN v_retval;
    EXCEPTION
        WHEN OTHERS THEN
					NULL;
    END #{func_name};
  CODE
	print output
end

