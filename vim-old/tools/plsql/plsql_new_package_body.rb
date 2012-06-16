#!/usr/bin/env ruby 

line = gets
pattern = /(\w*)(\.*)(\w*)\s*_newPackageBody/
pack_name = pattern.match(line)[1] + pattern.match(line)[2] + 
  pattern.match(line)[3]


if !(pack_name == "")
	output =<<-CODE
CREATE OR REPLACE PACKAGE BODY #{pack_name} 
/**********************************************************************************************                   
	Package Name  : #{pack_name}
	Author        : Atomic Object LLC. (AUTHOR)
	Date          : #{Date.today.strftime('%m-%d-%Y')}	 
	Purpose       : 
***********************************************************************************************/
IS
/* Constants */

/* Variables */

/* Exceptions */

/* Types (records, collections, cursor variables) */

/* Public Programs */

/* Private Programs */

END #{pack_name};
/
	CODE
	print output
end

