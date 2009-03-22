#!/usr/bin/perl -w

while (<STDIN>)
{
	($className) = m/(\w*) _bogifyClass/;

	my $output =<< "END";
/*
 * This program is free software; you can redistribute it and/or modify it under 
 * the terms of the GNU General Public License as published by the Free Software 
 * Foundation; either version 2 of the License, or (at your option) any later 
 * version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR 
 * A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * The authors can be reached \@:
 *
 * Jason Roelofs:
 * 	jameskilton\@beyondunreal.com
 * Shawn Anderson:
 *	shawn42\@gmail.com
 *
 * Copyright (C) 2004
 */

#include <TUT/tut.h>
#include "the${className}.h"

using namespace the;

/** 
 * Put all bogus classes here to prevent namespace conflicts.
 */
namespace the
{
	/** 
	 * Test of the ${className} class
	 */
	class Bogus${className} : public ${className}
	{
		public:
			// Add member set/gets here
	};
}

namespace tut
{

	struct ${className}_Test_Data
	{
		// Test Object
		Bogus${className} testMe;
	};
	
	// Test intialization
	typedef test_group<${className}_Test_Data> testGroup;
	typedef testGroup::object testObject;
	testGroup ${className}_testGroup("${className}");

	/***************************
	 * Test Methods
	 ***************************/

	/**
	 * See that 
	 */
	template<>
	template<>
	void testObject::test<1>()
	{	
		fail("Implement Me");
  }
}
END
	print $output;
}


