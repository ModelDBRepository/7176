//genesis
//
// $Id: utility.g 1.7 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Purkinje tutorial
//'
//' (C) 1998-2002 BBF-UIA
//'
//' see our site at http://www.bbf.uia.ac.be/ for more information regarding
//' the Purkinje cell and genesis simulation software.
//'
//'
//' functional ideas ... Erik De Schutter, erik@bbf.uia.ac.be
//' genesis coding ..... Hugo Cornelis, hugo@bbf.uia.ac.be
//'
//' general feedback ... Reinoud Maex, Erik De Schutter
//'
//////////////////////////////////////////////////////////////////////////////


// utility.g : various general utility functions

int include_utility

if ( {include_utility} == 0 )

	include_utility = 1


///
/// SH:	CountArguments
///
/// PA:	args..:	any number of arguments
///
/// RE:	Number of arguments
///
/// DE:	Determine the number of given arguments
///

function CountArguments

	//- return argument count

	return {argc}
end


///
/// SH:	LastArgument
///
/// PA:	args..:	any number of arguments
///
/// RE:	Last given argument
///
/// DE:	Give last argument
///

function LastArgument

	//- return last argument

	return {argv {argc}}
end


///
/// SH:	NumberOfElements
///
/// PA:	path..:	path with elements ending in '/'
///
/// RE:	Number of elements in the given path
///
/// DE:	Determine the number of elements in the given path
///	The {path} argument can include part of wildcard specification
///

function NumberOfElements(path)

str path

	//- enumerate all elements with a wildcard

	return {CountArguments {el {path}#[]}}
end


end


