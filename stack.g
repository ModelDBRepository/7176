//genesis
//
// $Id: stack.g 1.3 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
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


// stack.g : a simple stack implementation

int include_stack

if ( {include_stack} == 0 )

	include_stack = 1


include utility.g


extern StackCreate
extern StackPop
extern StackPush
extern StackTopElement
extern StackTop


///
/// SH:	StackCreate
///
/// PA:	path..:	path to contain stack elements ending in '/'
///
/// DE:	Create a stack
///

function StackCreate(path)

str path

	//- create stack container

	create neutral {path}stack

	//- add field for number of elements

	addfield {path}stack \
		elements -description "Number of elements -1 in stack"

	//- initialize field

	setfield {path}stack elements -1
end


///
/// SH:	StackDelete
///
/// PA:	path..:	path with stack elements ending in '/'
///
/// DE:	Delete stack
///

function StackDelete(path)

str path

	//- delete stack container

	delete {path}stack
end


///
/// SH:	StackNumberOfElements
///
/// PA:	path..:	path with stack elements ending in '/'
///
/// RE: number of values in stack
///
/// DE:	Get number of values in stack
///

function StackNumberOfElements(path)

str path

	return {{getfield {path}stack elements} + 1}
end


///
/// SH:	StackPop
///
/// PA:	path..:	path with stack elements ending in '/'
///
/// RE: value of previous top of stack
///
/// DE:	Pop value onto stack
///

function StackPop(path)

str path

	str top
	str val

	//- get number of elements in stack

	int iElements = {StackNumberOfElements {path}}

	//- if no underflow

	if (iElements > 0)

		//- get stack top

		top = {StackTopElement {path}}

		//- get value of stacktop

		val = {getfield {top} value}

		//- delete top

		delete {top}

		//- adjust element count

		setfield {path}stack \
			elements {{getfield {path}stack elements} - 1}

	//- else

	else
		//- set empty result

		val = ""
	end

	//- return value

	return {val}
end


///
/// SH:	StackPush
///
/// PA:	path..:	path with stack elements ending in '/'
///	val...: value to push
///
/// DE:	Push value onto stack
///

function StackPush(path,val)

str path
str val

	//- get stack top

	str top = {StackTopElement {path}}

	//- create new element 

	str new = {{top} @ "/1"}

	create neutral {new}

	//- set value

	addfield {new} value

	setfield {new} value {val}

	//- adjust element count

	setfield {path}stack \
		elements {{getfield {path}stack elements} + 1}
end


///
/// SH:	StackTopElement
///
/// PA:	path..:	path with stack elements ending in '/'
///
/// RE: top of stack
///
/// DE:	Get top of stack
///

function StackTopElement(path)

str path

	//- get stack top

	str top = {LastArgument {el {path}##}}

	//- return element

	return {top}
end


///
/// SH:	StackTop
///
/// PA:	path..:	path with stack elements ending in '/'
///
/// RE: value of top of stack
///
/// DE:	Get top value of stack
///

function StackTop(path)

str path

	//- get stack top

	str top = {StackTopElement {path}}

	//- get value of stacktop

	str val = {getfield {top} value}

	//- return value

	return {val}
end


end


