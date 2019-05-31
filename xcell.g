//genesis
//
// $Id: xcell.g 1.1.1.6.1.5.2.6.1.1.2.1.2.2.1.2 Thu, 04 Apr 2002 12:35:02 +0200 hugo $
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


// xcell.g : xcell functionality

int include_xcell

if ( {include_xcell} == 0 )

	include_xcell = 1


//////////////////////////////////////////////////////////////////////////////
//o
//o xcell library : future enhancements
//o -----------------------------------
//o
//o The main major idea for future enhancement is to have a library for xcell
//o	displays where each display can have its own output mode.
//o
//o
//o 1. Requirements
//o ---------------
//o
//o Because the number of possible outputs is finite, the idea is to mirror 
//o	the output mode of an xcell display in its path.
//o
//o	e.g.: 
//o		/xcells/Vm............:	gives Vm output
//o		/xcells/CaP/Ik........:	gives Ik for CaP channel
//o		/xcells/Cap/Gk........:	gives Gk for CaP channel
//o		/xcells/CaP/Ek........:	gives Ek for CaP channel
//o		.	.	.	.	.	.
//o		.	.	.	.	.	.
//o
//o The xcell displays are created only when they are needed. This gives less
//o	overhead at setup time (mainly because the messages don't have to be 
//o	created) and at run time (because each visible xcell display doesn't
//o	have to go through an enormous amount of messages). Opportunity must
//o	be given to delete/hide xcells. If necessary / possible the messages
//o	should be deleted to increase performance. When an xcell display is 
//o	hidden, it should be disabled such that it doesn't receive any PROCESS
//o	actions anymore.
//o
//o Graphs plotting the values associated with particular compartments are 
//o	different in there path hierarchy : One graph is created for each of
//o	Ik,Gk,Ek and for Vm and [Ca2+]. Perhaps this can also give a nicer 
//o	name to the different plots (e.g. b1s14_16 instead of
//o	b1s14_16_Ca_pool_Ca etc).
//o	The link between the xcell displays and the plotting graphs is as
//o	follows : if a click occures inside an xcell display, we ask the user
//o	first which output parameter he wants, this defaults to the xcell's 
//o	display output parameter.
//o
//o	Besides this we still have to provide a possibility to have a plot
//o	without any xcell display where we can type the compartment name to
//o	plot.
//o	As with xcell displays, opportunity must be given to delete graphs. 
//o	If possible any messages should be deleted to increase performance.
//o
//o The config file/module should be able to reflect a particular situation.
//o	This situation should then be created at initialization. To specify
//o	this situation an enumeration of xcell displays and xgraphs is given
//o	with their output parameters. 
//o
//o	e.g. :
//o
//o		.	.	.
//o		.	.	.
//o		xCellElements 1600	(old values)
//o		XCell Vm		(creates /xcells/Vm)
//o		XCell CaP Ik		(creates /xcells/CaP/Ik)
//o		XGraph CaP Ek		(creates /xgraphs/CaP/Ek)
//o		XGraph Vm soma[0]	(creates /xgraphs/Vm plotting soma Vm)
//o		.	.	.
//o		.	.	.
//o
//o	In the long run it should be possible to save such a configuration 
//o	from the tutorial itself (without having to run the configuration 
//o	script). Perhaps a seperate file for this configuration from which the
//o	name is given in the config file is better. This lets one choose 
//o	between different output modes easily by changing the config file.
//o
//o At this moment I don't see any interference with the boundaries settings,
//o	but I could be wrong on that.
//o
//o
//o 2. Implementation
//o -----------------
//o
//o A seperate library is needed asking for a particular output mode. Part of
//o	this is present in the actual xcell code. The same applies for asking
//o	the user for a particular compartment to plot. This code is partly 
//o	present in the xgraph code.
//o
//o
//////////////////////////////////////////////////////////////////////////////


//v bool to indicate first toggle for tabchannel has been created

int bButtonsCreated = 0

//v bool for communication between XCellAddElectrode and XCellCBAddPlot

int bXCellAddElectrodeResult = 0

//v basename for library file of all channels

str strXCLibrary = "XCLib"


///
/// SH:	XCellElectrodeName
///
/// PA:	path..:	path to the clicked compartment
///
/// RE:	name for electrode
///
/// DE:	Associate an electrode name with {path} for registered xcell parameters
///	The electrode name will have a fairly descriptive name (ie from the 
///	electrode name you can make out which field from which compartment is
///	recorded.
///

function XCellElectrodeName(path)

str path

	//- get the registered xcell output source

	str xcOutputSource = {getfield /xcell outputSource}

	//- get the registered xcell output value

	str xcOutputValue = {getfield /xcell outputValue}

	//- get the registered xcell output flags

	int xcOutputFlags = {getfield /xcell outputFlags}

	//- get the electrode name

	str electrode = {XGraphPlotTitle \
				{path} \
				{xcOutputSource} \
				{xcOutputValue} \
				{xcOutputFlags}}

	//- return electrode name

	return {electrode}
end


///
/// SH:	XCellAddElectrode
///
/// PA:	path..:	path to the clicked compartment
///	name..:	name for electrode
///	color.:	color for the electrode
///
/// RE:	1 if successfull
///	0 if failed (the electrode already exists)
///
/// DE:	Associate an electrode with {path} for registered xcell parameters
///
/// Electrode prototype is /electrodes/draw/proto {xshape}
///
/// The electrode is created within 
///	/electrodes/draw/{name}.......:	always
///	/xcell/draw/{name}............:	when electrodes visible
///					in xcell display
///

function XCellAddElectrode(path,name,color)

str path
str name
int color

	//- set default result

	int bResult = 0

	//- give diagnostics

	echo "Adding electrode for "{name}

	//- copy the prototype electrode

	copy /electrodes/draw/proto /electrodes/draw/{name}

	//- set field for identification and color

	setfield ^ \
		ident "record" \
		pixcolor {color}

	//- set the translation of the electrode

	setfield ^ \
		tx {getfield {path} x} \
		ty {getfield {path} y} \
		tz {getfield {path} z}

	//- if the electrodes toggle is set

	if ( {getfield /xcell/electrodes state} )

		//- copy the electrode to the xcell window

		copy ^ /xcell/draw/{name}
	end

	//- set success

	bResult = 1

	//- set the result in a global

	bXCellAddElectrodeResult = {bResult}

	//- return result

	return {bResult}
end


///
/// SH:	XCellPrepareElectrodes
///
/// DE:	Prepare electrodes
///

function XCellPrepareElectrodes

	//- create a container

	create xform /electrodes

	//- disable the form

	disable ^

	//- create a draw

	create xdraw /electrodes/draw

	//- create an electrode prototype shape

	create xshape /electrodes/draw/proto \
		-linewidth 1 \
		-textmode nodraw \
		-pixcolor red \
		-coords [-40e-7,0,90e-7][0,0,0][-20e-7,0,100e-7][-30e-7,0,95e-7][-40e-7,0,150e-7][-140e-7,0,100e-7]

	//- add a field for identification

	addfield ^ \
		ident -description "Identification"

	//- set the field

	setfield ^ \
		ident "prototype"
end


///
/// SH:	XCellRemoveElectrode
///
/// PA:	path..:	path to the clicked compartment
///
/// DE:	Remove the electrode associated with {path}
///

function XCellRemoveElectrode(path)

str path

	//- get the registered xcell output source

	str xcOutputSource = {getfield /xcell outputSource}

	//- get the registered xcell output value

	str xcOutputValue = {getfield /xcell outputValue}

	//- get the registered xcell output flags

	int xcOutputFlags = {getfield /xcell outputFlags}

	//- get the electrode title

	str plotTitle = {XGraphPlotTitle \
				{path} \
				{xcOutputSource} \
				{xcOutputValue} \
				{xcOutputFlags}}

	//- if the electrode exists

	if ( {exists /electrodes/draw/{plotTitle}} )

		//- give diagnostics

		echo "Removing electrode "{plotTitle}

		//- remove the electrode

		delete /electrodes/draw/{plotTitle}

		//- if the electrodes toggle is set

		if ( {getfield /xcell/electrodes state} )

			//- delete the electrode from the xcell window

			delete /xcell/draw/{plotTitle}

			//- update the draw widget

			//xflushevents
			xupdate /xcell/draw

			//! to get around a bug that does not update 
			//! the deleted electrodes :
			//! hide and show the parent form

			xhide /xcell
			xshow /xcell
		end

	//- else

	else
		//- give diagnostics

		echo "No electrode named "{plotTitle}
	end
end


///
/// SH:	XCellRemoveElectrodes
///
/// DE:	Remove all electrodes
///

function XCellRemoveElectrodes

	//- give diagnostics

	echo "Removing all electrodes"

	//- loop over all registered electrode

	str electr

	foreach electr ( {el /electrodes/draw/#[][ident=record]} )

		//! because of a bug in the wildcard parsing
		//! we can stil get the prototype here.
		//! we must check this by name of the element

		//- if it is not the prototype

		if ( {getpath {electr} -tail} != "proto" )

			//- delete the electrode to the xcell window

			delete {electr}
		end
	end

	//- update the state of the electrodes

	callfunc XCellSetupElectrodes {getfield /xcell/electrodes state}
end


///
/// SH:	XCellSetupElectrodes
///
/// PA:	state.:	0 if electrodes should be invisible
///		1 if electrodes should be visible
///
/// DE:	Show/hide the electrodes
///

function XCellSetupElectrodes(state)

int state

	//- loop over all electrodes in the xcell window

	str electr

	foreach electr ( {el /xcell/draw/#[][ident=record]} )

		//- remove the electrode

		delete {electr}
	end

	//- if the electrodes should be visible

	if (state)

		//- give diagnostics

		echo "Showing electrodes"

		//- loop over all registered electrode

		foreach electr ( {el /electrodes/draw/#[][ident=record]} )

			//- get the tail of the name

			str tail = {getpath {electr} -tail}

			//! because of a bug in the wildcard parsing
			//! we can stil get the prototype here.
			//! we must check this by name of the element

			if ( {tail} != "proto" )

				//- copy the electrode to the xcell window

				copy {electr} /xcell/draw/{tail}
			end
		end

	//- else

	else

		//- give diagnostics

		echo "Hiding electrodes"
	end

	//- update the draw widget

	xflushevents
	xupdate /xcell/draw

	//! to get around a bug that does not update the deleted electrodes :
	//! hide and show the parent form
	//! for some reason it is not necessary here, but it is above 
	//! (removal of electrodes).

//	xhide /xcell
//	xshow /xcell
end


///
/// SH:	XCellSetupGraph
///
/// PA:	state.:	0 if graph should be invisible
///		1 if graph should be visible
///
/// DE:	Show/hide the graph
///

function XCellSetupGraph(state)

int state

	//- if the graph should be visible

	if (state)

		//- show the graph

		xshow /xgraphs

	//- else

	else
		//- hide the graph

		xhide /xgraphs
	end
end


///
/// SH:	XCellSwitchChanMode
///
/// PA:	state.:	0 for absolute chanmode (chanmode 4)
///		1 for normalized chanmode (chanmode 5)
///
/// DE:	Switch between normalized and absolute channel mode
///	Sets the solver in {cellpath}/solve in chanmode 4 or 5.
///	Sets the min/max color values for the xcell display
///	Notifies graph for new chanmode
///

function XCellSwitchChanMode(state)

int state

	//- if state is not zero

	if (state)

		//- switch to chanmode 5

		iChanMode = 5

		setfield {cellpath}/solve \
			chanmode {iChanMode}

	//- else

	else
		//- switch to chanmode 4

		iChanMode = 4

		setfield {cellpath}/solve \
			chanmode {iChanMode}
	end

	//- get name for boundary element

	str bound = {BoundElementName \
			{getfield /xcell outputSource} \
			{getfield /xcell outputValue} \
			{iChanMode}}

	//- set field for boundaries

	setfield /xcell \
		boundElement {bound}

	//- set new boundaries from element

	callfunc XCellSetBoundaries {bound}

	//- notify graph new chanmode

	XGraphSwitchChanMode {state}
end


///
/// SH:	XCellDeleteMessages
///
/// DE:	Delete the messages from the xcell
///	If no messages are setup, none will be deleted and the function
///	will cleanly return.
///

function XCellDeleteMessages

	//- count the number of incoming messages

	int iCount = {getmsg /xcell/draw/xcell1 -incoming -count}

	//- if the count is not zero

	if (iCount)

		//- retreive the number of elements from the config

		int iElements = {getfield /config xCellElements}

		//- loop for the number of elements / messages

		int i

		for (i = 0; i < iElements; i = i + 1)

			//- delete the first message

			deletemsg /xcell/draw/xcell1 {0} -incoming
		end
	end
end


///
/// SH:	XCellSetupMessages
///
/// PA:	source:	message source in {cellpath}
///	value.:	message value within {source}
///
/// DE:	Setup the messages between the solver and xcell
///	The solver is assumed to be {cellpath}/solve .
///

function XCellSetupMessages(source,value)

str source
str value

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- give diagnostics

	echo "Setting up messages to xcell for "{source}", "{value}

	str element
//
//	foreach element ( { el { wPath } } )

//		if ( {exists {element}/{source}} )

//			echo Exists : {element}/{source}

//		else

//			echo Non existent : {element}/{source}
//		end
//		break
//	end

	//- loop over all elements in the xcell object

	str element

	foreach element ( { el { wPath } } )

		//- if the source elements exists

		if ( {exists {element}/{source}} )

			//echo Exists : {element}/{source}

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element}/{source} \
					{value}}

		//- else the element does not exist

		else

			//echo Non existent : {element}/{source}

			//- add a dummy message

			addmsg /config /xcell/draw/xcell1 COLOR z
		end
	end

	//- set number of compartments in the xcell object

	setfield /xcell/draw/xcell1 \
		nfield {getfield /config xCellElements}

	//- give diagnostics

	echo "Messages to xcell ok."
end


///
/// SH:	XCellSetupCompMessages
///
/// PA:	source:	message source in {cellpath} (not used)
///	value.:	message value within {source}
///
/// DE:	Setup the messages between the solver and xcell for compartments
///	The solver is assumed to be {cellpath}/solve .
///

function XCellSetupCompMessages(source,value)

str source
str value

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- give diagnostics

	echo "Setting up messages to xcell for (compartments), "{value}

	//- loop over all elements in the xcell object

	str element

	foreach element ( { el { wPath } } )

		//- if the source elements exists

		if ( {exists {element}} )

			//echo Exists : {element}

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element} \
					{value}}

		//- else the element does not exist

		else

			//echo Non existent : {element}

			//- add a dummy message

			addmsg /config /xcell/draw/xcell1 COLOR z
		end
	end

	//- set number of compartments in the xcell object

	setfield /xcell/draw/xcell1 \
		nfield {getfield /config xCellElements}

	//- give diagnostics

	echo "Messages to xcell ok."
end


///
/// SH:	XCellSetupExcIGEMessages
///
/// PA:	source:	message source in {cellpath}
///	value.:	message value within {source}
///
/// DE:	Setup the messages between the solver and xcell
///	The solver is assumed to be {cellpath}/solve .
///

function XCellSetupExcIGEMessages(source,value)

str source
str value

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- give diagnostics

	echo "Setting up messages to xcell for " \
		{source}", "{value}

	//- loop over all elements in the xcell object

	str element

	foreach element ( { el { wPath } } )

		//- get the spine that gives messages to the element

		str spine = {getmsg {element} -outgoing -destination 7}

		//- get tail of spine

		str spineTail = {getpath {spine} -tail}

		//- get head of spine for use with solver's flat space

		str spineHead = {getpath {spine} -head}

		//- if we are handling a spine

		if ( {strncmp {spineTail} "spine" 5} == 0 )

			//- default index is zero

			source = "head[0]/par"

			//- if an index is available

			if ( {strlen {spineTail}} != 5 )

				//- get index of synapse

				int synapseIndex \
					= {substring \
						{spineTail} \
						6 \
						{{strlen {spineTail}} - 1}}

				//- make source string with index

				source = "head[" @ {synapseIndex} @ "]/par"
			end

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{spineHead}{source} \
					{value}}

		//- else if we can find a climbing fiber input

		elif ( {exists {element}/climb } )

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element}/climb \
					{value}}

		//- else the element does not exist

		else
			//- add a dummy message

			addmsg /config /xcell/draw/xcell1 COLOR z
		end
	end

	//- set number of compartments in the xcell object

	setfield /xcell/draw/xcell1 \
		nfield {getfield /config xCellElements}

	//- give diagnostics

	echo "Messages to xcell ok."
end


///
/// SH:	XCellSetupInhIGEMessages
///
/// PA:	source:	message source in {cellpath}
///	value.:	message value within {source}
///
/// DE:	Setup the messages between the solver and xcell
///	The solver is assumed to be {cellpath}/solve .
///

function XCellSetupInhIGEMessages(source,value)

str source
str value

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- give diagnostics

	echo "Setting up messages to xcell for " \
		{source}", "{value}

	//- loop over all elements in the xcell object

	str element

	foreach element ( { el { wPath } } )

		//- if we are handling a stellate cell

		if ( {exists {element}/stell} )

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element}/stell \
					{value}}

		//- else if we can find a stellate 1 cell

		elif ( {exists {element}/stell1 } )

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element}/stell1 \
					{value}}

		//- else if we can find a basket cell

		elif ( {exists {element}/basket } )

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{element}/basket \
					{value}}

		//- else no inhibitory channel exists

		else
			//- add a dummy message

			addmsg /config /xcell/draw/xcell1 COLOR z
		end
	end

	//- set number of compartments in the xcell object

	setfield /xcell/draw/xcell1 \
		nfield {getfield /config xCellElements}

	//- give diagnostics

	echo "Messages to xcell ok."
end


///
/// SH:	XCellSetupSpineVmMessages
///
/// PA:	source:	message source in {cellpath}
///	value.:	message value within {source}
///
/// DE:	Setup the messages between the solver and xcell
///	The solver is assumed to be {cellpath}/solve .
///

function XCellSetupSpineVmMessages(source,value)

str source
str value

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- give diagnostics

	echo "Setting up spine compartment messages to xcell for " \
		{source}", "{value}

	//- loop over all elements in the xcell object

	str element

	foreach element ( { el { wPath } } )

		//- get the spine that gives messages to the element

		str spine = {getmsg {element} -outgoing -destination 7}

		//- get tail of spine

		str spineTail = {getpath {spine} -tail}

		//- get head of spine for use with solver's flat space

		str spineHead = {getpath {spine} -head}

		//- if we are handling a spine

		if ( {strncmp {spineTail} "spine" 5} == 0 )

			//- default index is zero

			source = "head[0]"

			//- if an index is available

			if ( {strlen {spineTail}} != 5 )

				//- get index of synapse

				int synapseIndex \
					= {substring \
						{spineTail} \
						6 \
						{{strlen {spineTail}} - 1}}

				//- make source string with index

				source = "head[" @ {synapseIndex} @ "]"
			end

			//echo {spineHead}{source} {value}

			//- find solve field and add the message

			addmsg {cellpath}/solve /xcell/draw/xcell1 \
				COLOR {findsolvefield \
					{cellpath}/solve \
					{spineHead}{source} \
					{value}}

		//- else the element does not exist

		else
			//- add a dummy message

			addmsg /config /xcell/draw/xcell1 COLOR z
		end
	end

	//- set number of compartments in the xcell object

	setfield /xcell/draw/xcell1 \
		nfield {getfield /config xCellElements}

	//- give diagnostics

	echo "Messages to xcell ok."
end


///
/// SH:	XCellSetupButtons
///
/// PA:	widget:	name of toggled widget
///	mode..:	output mode of xcell
///		1	comp. Vm
///		2	channel with IGE
///		3	excitatory channel with IGE
///		4	spine comp. Vm
///		5	nernst E
///		6	Calcium concen Ca
/// 		7	inhibitory channel with IGE
///
/// DE:	Display the buttons according to the output mode
///

function XCellSetupButtons(widget,mode)

str widget
int mode

	//echo setupbuttons : {widget} {mode}

	//- set the heading for the xcell form

	setfield /xcell/heading \
		title {getfield /xcell outputDescription}

	//- comp. Vm
	//- or spine comp. Vm
	//- or nernst E
	//- or Calcium concen Ca

	if (mode == 1 || mode == 4 || mode == 5 || mode == 6)

		//- hide I,G toggles

		xhide /xcell/Ik
		xhide /xcell/Gk

		//- show I,G labels

		xshow /xcell/noIk
		xshow /xcell/noGk

		//- show E label

		xhide /xcell/Ek
		xshow /xcell/noEk

	//- channel with IGE
	//- or excitatory channel with IGE
	//- or inhibitory channel with IGE

	elif (mode == 2 || mode == 3 || mode == 7)

		//- hide I,G labels

		xhide /xcell/noIk
		xhide /xcell/noGk

		//- show I,G toggles

		xshow /xcell/Ik
		xshow /xcell/Gk

		//- get widget tail

		str channel = {getpath {widget} -tail}

		//- for a calcium channel

		if ( {channel} == "CaP" || {channel} == "CaT")

			//- show Ek toggle

			xhide /xcell/noEk
			xshow /xcell/Ek

		//- else 

		else
			//- hide Ek toggle

			xshow /xcell/noEk
			xhide /xcell/Ek
		end

	//- else there is something wrong

	else
		//- give diagnostics

		echo "XCellSetupButtons : Wrong output mode for XCell"
	end

	//- loop over all toggle buttons in the xcell

	str toggle

	foreach toggle ( {el /xcell/#[][TYPE=xtoggle]} )

		//- isolate the tail

		str toggleTail = {getpath {toggle} -tail}

		//- if the toggle is not for graph, 
		//-	electrodes or abs/norm output

		if (toggleTail != "graph" \
			&& toggleTail != "electrodes" \
			&& toggleTail != "chanmode")

			//- unset the toggle

			setfield {toggle} \
				state 0
		end
	end

	//- set the toggle that has been pressed

	setfield {widget} \
		state 1

	//- set the toggle for the channel mode

	setfield /xcell/{getfield /xcell channelMode} \
		state 1

end


///
/// SH:	XCellSetOutput
///
/// PA:	widget:	name of toggled widget
///
/// RE: output mode
///	1	comp. Vm
///	2	channel with IGE
///	3	excitatory channel with IGE
///	4	spine comp. Vm
///	5	nernst E
///	6	Calcium concen Ca
///	7	inhibitory channel with IGE
///
/// DE:	Setup messages for update of xcell, setup buttons, do a reset
///

function XCellSetOutput(widget)

str widget

	//- set the field for output

	setfield /xcell \
		output {widget}

	//- delete all messages from the xcell

	XCellDeleteMessages

	//- default we should not continue

	int bContinue = 0

	//v strings for construction of messages

	str msgSource
	str msgValue
	str msgDescription

	//= mode for setting up buttons
	//=
	//= 1	comp. Vm
	//= 2	channel with IGE
	//= 3	excitatory channel with IGE
	//= 4	spine comp. Vm
	//= 5	nernst E
	//= 6	Calcium concen Ca
	//= 7	inhibitory channel with IGE

	int flButtons = 0

	//- get the parameter attribute for the widget

	str parameters = {getfield {widget} parameters}

	//- if we are dealing with compartments

	if (parameters == "Vm")

		//- the description is compartmental voltage

		msgDescription = "Compartmental voltage"

		//- the source is empty

		msgSource = ""

		//- the value is Vm

		msgValue = "Vm"

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 1

	//- if we are dealing with spine compartments

	elif (parameters == "spineVm")

		//- the description is spiny voltage

		msgDescription = "Spiny voltage"

		//- the source is the head of the spine

		msgSource = "head"

		//- the value is Vm

		msgValue = "Vm"

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 4

	//- if we are dealing with nernst

	elif (parameters == "E")

		//- the description is Nernst

		msgDescription = "Nernst"

		//- the source is Ca_nernst

		msgSource = "Ca_nernst"

		//- the value is E

		msgValue = "E"

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 5

	//- if we are dealing with concentration

	elif (parameters == "Ca")

		//- the description is compartmental Ca conc.

		msgDescription = "Compartmental [Ca2+]"

		//- the source is Ca_pool

		msgSource = "Ca_pool"

		//- the value is Ca

		msgValue = "Ca" 

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 6

	//- if we are dealing with channels

	elif (parameters == "IGE")

		//- the description is the channel with registered mode

		msgDescription \
			= {getpath {widget} -tail} \
				@ " " \
				@ {getfield \
					/xcell/{getfield /xcell channelMode} \
					description}

		//- the source is slash + the widget tail

		msgSource = {getpath {widget} -tail}

		//- the value is registered in /xcell

		msgValue = {getfield /xcell channelMode}

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 2

	//- if we are dealing with exc channels

	elif (parameters == "excIGE")

		//- the description is the channel with registered mode

		msgDescription \
			= "Excitatory " \
				@ {getfield \
					/xcell/{getfield /xcell channelMode} \
					description}

		//- the source is not relevant

		msgSource = "excitatory"

		//- the value is registered in /xcell

		msgValue = {getfield /xcell channelMode}

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 3

	//- if we are dealing with inh channels

	elif (parameters == "inhIGE")

		//- the description is the channel with registered mode

		msgDescription \
			= "Inhibitory " \
				@ {getfield \
					/xcell/{getfield /xcell channelMode} \
					description}

		//- the source is not relevant

		msgSource = "inhibitory"

		//- the value is registered in /xcell

		msgValue = {getfield /xcell channelMode}

		//- remember to continue

		bContinue = 1

		//- set flags for buttons

		flButtons = 7

	//- else somebody messed up the code

	else
		//- give diagnostics

		echo "Somebody messed up the code"
		echo "XCell module bug"
	end

	//- if we should continue

	if (bContinue)

		//- if we are handling compartments

		if (flButtons == 1)

			//- setup messages for compartments

			XCellSetupCompMessages {msgSource} {msgValue}

		//- else if we are handling spine compartments

		elif (flButtons == 4)

			//- setup messages for spines

			XCellSetupSpineVmMessages {msgSource} {msgValue}

		//- else if we are handling exc channels

		elif (flButtons == 3)

			//- setup messages for those channels

			XCellSetupExcIGEMessages {msgSource} {msgValue}

		//- else if we are handling inh channels

		elif (flButtons == 7)

			//- setup messages for those channels

			XCellSetupInhIGEMessages {msgSource} {msgValue}

		//- else we are handling normal messages

		else
			//- setup messages

			XCellSetupMessages {msgSource} {msgValue}
		end
	end

	//- register output description

	setfield /xcell \
		outputDescription {msgDescription}

	//- set up buttons correctly

	XCellSetupButtons {widget} {flButtons}

	//- get name of boundary element

	str bound = {BoundElementName {msgSource} {msgValue} {iChanMode}}

	//- register the output parameters and boundary element

	setfield /xcell \
		outputSource {msgSource} \
		outputValue {msgValue} \
		outputFlags {flButtons} \
		outputDescription {msgDescription} \
		boundElement {bound}

	//- set boundaries for xcell

	callfunc XCellSetBoundaries {bound}

	//- reset the simulation

	reset

	//- notify graph of switched output units

	callfunc XGraphNextPlotMode {msgValue}

	//- return the output mode

	return {flButtons}
end


///
/// SH:	XCellSetBoundaries
///
/// PA:	bound.:	boundary element
///
/// RE:	Success of operation
///
/// DE:	Set boundaries from the given element, update color widgets
///

function XCellSetBoundaries(bound)

str bound

	//v result var

	int bResult

	//- if the element with the boundaries exists

	if ( {exists {bound}} )

		//- give diagnostics

		echo "Setting xcell color boundaries from "{bound}

		//- set the fields for dimensions

		setfield /xcell/draw/xcell1 \
			colmin {getfield {bound} xcellmin} \
			colmax {getfield {bound} xcellmax}

		//- set config values in color widgets

		callfunc XCellShowConfigure

		//- set result : ok

		bResult = 1

	//- else

	else
		//- set result : failure

		bResult = 0
	end

	//- return result

	return {bResult}
end


///
/// SH:	XCellSetChannelMode
///
/// PA:	widget:	name of toggled widget
///
/// DE:	Set the channel mode
///

function XCellSetChannelMode(widget)

str widget

	//- isolate the tail of the toggled widget

	str widgetTail = {getpath {widget} -tail}

	//- set the channelmode field

	setfield /xcell \
		channelMode {widgetTail}

	//- update the output messages

	XCellSetOutput {getfield /xcell output}
end


///
/// SH:	XCellCancelConfigure
///
/// DE:	Hide the configure window
///

function XCellCancelConfigure

	//- hide the configure window

	xhide /xcell/configure
end


///
/// SH:	XCellSetConfigure
///
/// DE:	Set xcell config as in the configuration window
///

function XCellSetConfigure

	//- set color min

	setfield /xcell/draw/xcell1 \
		colmin {getfield /xcell/colormin value}

	//- set color max

	setfield /xcell/draw/xcell1 \
		colmax {getfield /xcell/colormax value}
end


///
/// SH: XCellShowConfigure
///
/// DE:	Show configuration window for xcell
///

function XCellShowConfigure

	//- set color min value

	setfield /xcell/colormin \
		value {getfield /xcell/draw/xcell1 colmin}

	//- set color max value

	setfield /xcell/colormax \
		value {getfield /xcell/draw/xcell1 colmax}
/*
	//- pop up the configuration window

	xshow /xcell/configure
*/
end


///
/// SH:	XCellCreateToggle
///
/// PA:	name..:	name of widget to create
///
/// DE:	Create a channel toggle button in the xcell form.
///	The button is only created if it does not exist yet.
///

function XCellCreateToggle(name)

str name

	//- if the widget does not exist yet

	if ( ! {exists /xcell/{name}} )

		//- if there are already channels created

		if (bButtonsCreated)

			//- create a toggle button beneath previous

			create xtoggle /xcell/{name} \
				-xgeom 90% \
				-wgeom 10% \
				-script "XCellSetOutput <w>"

		//- else 

		else
			//- create toggle button at upper right

			create xtoggle /xcell/{name} \
				-xgeom 90% \
				-ygeom 5% \
				-wgeom 10% \
				-script "XCellSetOutput <w>"

			//- remember that buttons are created

			bButtonsCreated = 1
		end

		//- add field for parameters

		addfield ^ \
			parameters -description "parameters for messages"

		//- set the parameter field to channels

		setfield ^ \
			parameters "IGE"
	end
end


///
/// SH:	XCellCreateChannelLibrary
///
/// DE:	Create library of Purkinje channels in /library
///

function XCellCreateChannelLibrary

	//v number of channels

	int iChannels = 0

	//- create neutral container

	create neutral /tmp

	//- loop over all purkinje channels found in the library

	str channel

	foreach channel ( {el /library/Purk_#/#[][TYPE=tabchannel]} )

		//- isolate the name of the channel

		str tail = {getpath {channel} -tail}

		//- if the element does not exist

		if ( ! {exists /tmp/{tail}} )

			//- create library element

			create neutral /tmp/{tail}

			//- increment number of channels

			iChannels = {iChannels + 1}
		end
	end

	//- open the library file

	openfile {strXCLibrary}".u" w

	//- loop over all create elements

	foreach channel ( {el /tmp/#[]} )

		//- write tail of channel to the lib file

		writefile {strXCLibrary}".u" {getpath {channel} -tail}

		//- delete the neutral element

		delete {channel}
	end

	//- close the lib file

	closefile {strXCLibrary}".u"

	//- sort the lib file

	sh "sort <"{strXCLibrary}".u >"{strXCLibrary}".s"

	//- open the library file

	openfile {strXCLibrary}".s" r

	//- loop over all channels

	int i

	for (i = 0; i < iChannels; i = i + 1)

		//- read a channel

		channel = {readfile {strXCLibrary}".s" -linemode}

		//- create a neutral element

		create neutral /tmp/{channel}
	end

	//- close the lib file

	closefile {strXCLibrary}".s"
end


///
/// SH:	XCellCreateButtons
///
/// DE:	Create the xcell buttons and toggles.
///	Looks at the library to check which tabchannels are present
///

function XCellCreateButtons

	//- create toggle buttons per compartment

	create xtoggle /xcell/comp \
		-xgeom 70% \
		-ygeom 5% \
		-wgeom 20% \
		-title "Comp. Vm" \
		-script "XCellSetOutput <w>"
	addfield ^ \
		parameters -description "parameters for messages"
	setfield ^ \
		parameters "Vm"

	create xtoggle /xcell/Caconcen \
		-title "Comp. Ca" \
		-xgeom 70% \
		-wgeom 20% \
		-script "XCellSetOutput <w>"
	addfield ^ \
		parameters -description "parameters for messages"
	setfield ^ \
		parameters "Ca"

	create xtoggle /xcell/channelSpines \
		-xgeom 70% \
		-wgeom 20% \
		-title "Exc. chan." \
		-script "XCellSetOutput <w>"
	addfield ^ \
		parameters -description "parameters for messages"
	setfield ^ \
		parameters "excIGE"
	create xtoggle /xcell/channelSpinesInh \
		-xgeom 70% \
		-wgeom 20% \
		-title "Inh. chan." \
		-script "XCellSetOutput <w>"
	addfield ^ \
		parameters -description "parameters for messages"
	setfield ^ \
		parameters "inhIGE"
//	create xtoggle /xcell/compSpines \
//		-xgeom 70% \
//		-wgeom 20% \
//		-title "Spine comp." \
//		-script "XCellSetOutput <w>"
//	addfield ^ \
//		parameters -description "parameters for messages"
//	setfield ^ \
//		parameters "spineVm"
//	create xtoggle /xcell/nernst \
//		-xgeom 70% \
//		-wgeom 20% \
//		-script "XCellSetOutput <w>"
//	addfield ^ \
//		parameters -description "parameters for messages"
//	setfield ^ \
//		parameters "E"

	//- create a label as seperator

	create xlabel /xcell/sep1 \
		-xgeom 70% \
		-ygeom 3:last.bottom \
		-wgeom 20% \
		-title ""

	//- create toggle buttons for Ik,Gk,Ek

	create xtoggle /xcell/Ik \
		-xgeom 70% \
		-ygeom 1:sep1 \
		-wgeom 20% \
		-script "XCellSetChannelMode <w>"
	create xtoggle /xcell/Gk \
		-xgeom 70% \
		-wgeom 20% \
		-script "XCellSetChannelMode <w>"
	create xtoggle /xcell/Ek \
		-xgeom 70% \
		-wgeom 20% \
		-script "XCellSetChannelMode <w>"

	//- add descriptions

	addfield /xcell/Ik \
		description -description "Description of output"
	addfield /xcell/Gk \
		description -description "Description of output"
	addfield /xcell/Ek \
		description -description "Description of output"

	//- set descriptions

	setfield /xcell/Ik \
		description "current"
	setfield /xcell/Gk \
		description "conductance"
	setfield /xcell/Ek \
		description "reversal potential"

	create xlabel /xcell/noIk \
		-xgeom 70% \
		-ygeom 4:sep1 \
		-wgeom 20% \
		-title "No Ik"
	create xlabel /xcell/noGk \
		-xgeom 70% \
		-ygeom 3:last.bottom \
		-wgeom 20% \
		-title "No Gk"
	create xlabel /xcell/noEk \
		-xgeom 70% \
		-ygeom 3:last.bottom \
		-wgeom 20% \
		-title "No Ek"

	//- create a library of all channels

	XCellCreateChannelLibrary

	//- loop over all purkinje channels found in the library

	str channel

	foreach channel ( {el /tmp/#[]} )

		//- isolate the name of the channel

		str tail = {getpath {channel} -tail}

		//- create a toggle if necessary

		XCellCreateToggle {tail}
	end
/*
	//- create a label as seperator

	create xlabel /xcell/sep2 \
		-xgeom 70% \
		-ygeom 3:Ek \
		-wgeom 20% \
		-title ""
*/
	//- create toggle to show graph

	create xtoggle /xcell/graph \
		-xgeom 70% \
		-ygeom 6:draw.bottom \
		-wgeom 30% \
		-title "" \
		-onlabel "Graph" \
		-offlabel "No Graph" \
		-script "XCellSetupGraph <v>"

	//- create toggle to show recording electrodes

	create xtoggle /xcell/electrodes \
		-xgeom 70% \
		-ygeom 4:last.bottom \
		-wgeom 30% \
		-title "" \
		-onlabel "Electrodes" \
		-offlabel "No Electrodes" \
		-script "XCellSetupElectrodes <v>"

	//- create label as seperator

	create xlabel /xcell/sep3 \
		-xgeom 70% \
		-ygeom 6:graph.top \
		-wgeom 30% \
		-title ""

	//- create toggle to change normalized / absolute output

	create xtoggle /xcell/chanmode \
		-xgeom 70% \
		-ygeom 6:last.top \
		-wgeom 30% \
		-title "" \
		-onlabel "Normalized" \
		-offlabel "Absolute" \
		-script "XCellSwitchChanMode <v>"

	//- create label with normalized / absolute description

	create xlabel /xcell/chanlabel \
		-xgeom 70% \
		-ygeom 6:chanmode.top \
		-wgeom 30% \
		-title "Output mode :"

/*
	//- create a label as seperator

	create xbutton /xcell/config \
		-xgeom 70% \
		-wgeom 30% \
		-title "Configure" \
		-script "XCellShowConfigure"
*/
end


///
/// SH:	XCellCreateColorDialogs
///
/// DE:	Create the xcell color dialogs at the bottom
///

function XCellCreateColorDialogs

	//- create color min dialog

	create xdialog /xcell/colormax \
		-xgeom 0:parent.left \
		-ygeom 5:draw.bottom \
		-wgeom 70% \
		-title "Color maximum (red)  : " \
		-script "XCellSetConfigure"

	//- create color max dialog

	create xdialog /xcell/colormin \
		-xgeom 0:parent.left \
		-ygeom 0:last.bottom \
		-wgeom 70% \
		-title "Color minimum (blue) : " \
		-script "XCellSetConfigure"
end


///
/// SH:	XCellCreateHeadings
///
/// DE:	Create the xcell headings for the draw and buttons
///

function XCellCreateHeadings

	//- create header label

	create xlabel /xcell/heading [0,0,70%,5%] \
		-title "Comp. voltage"

	//- create buttons label

	create xlabel /xcell/outputs \
		-xgeom 0:last.right \
		-ygeom 0 \
		-wgeom 30% \
		-hgeom 5% \
		-title "Possible outputs"
end


///
/// SH:	XCellCreateDraw
///
/// DE:	Create the xcell draw
///

function XCellCreateDraw

	//- create draw within form

	create xdraw /xcell/draw [0,5%,70%,80%] \
		-wx 2e-3 \
		-wy 2e-3 \
		-transform ortho3d \
		-bg white

	//- set dimensions for draw

	setfield /xcell/draw \
		xmin -1.5e-4 \
		xmax 1.5e-4 \
		ymin -0.4e-4 \
		ymax 3.1e-4

	//- set projection mode

	setfield /xcell/draw \
		transform y

	//- retreive the wildcard from the config file

	str wPath = {getfield /config xCellPath}

	//- create cell display

	create xcell /xcell/draw/xcell1 \
	        -path {wPath} \
	        -colmin -0.09 \
	        -colmax 0.02 \
	        -diarange -20 

	//- set clock to use

	useclock /xcell/draw/xcell1 9
end


///
/// SH:	XCellReset
///
/// DE:	Set the default state for the xcell
///

function XCellReset

	//- default output is compartmental Vm

	setfield /xcell \
		output "/xcell/comp"

	//- default channel mode is conductance

	setfield /xcell \
		channelMode "Gk"

	//- if chanmode is 5

	if (iChanMode == 5)

		//- set widget to normalized output

		setfield /xcell/chanmode \
			state 1

	//- else

	else
		//- set widget to absolute output

		setfield /xcell/chanmode \
			state 0
	end

	//- default : graph is not visible

	setfield /xcell/graph \
		state 0

	//- default : electrodes are not visible

	setfield /xcell/electrodes \
		state 0

	//- update all output (buttons, colors)

	//! this just simulates a click on the comp. volt. button

	XCellSetOutput {getfield /xcell output}
end


///
/// SH:	XCellCBAddPlot
///
/// PA:	path..:	path to the clicked compartment
///
/// DE:	Callback to add compartment to graph
///

function XCellCBAddPlot(path)

str path

	//echo "XCellCBAddPlot : "{path}

	//- allocate next color

	callfunc "XGraphNextColor"

	//! the field cNextColor should be considered private,
	//! but read the comments below to understand why I had to
	//! read it as if it is public.
	//!
	//! With this public read it becomes more difficult to decide if the
	//! graph should do a reset (and skipping back to the default color)
	//! Modularity with genesis scripts can be tough...

	//- get allocated color

	int color = {getfield /xgraphs/graph cNextColor}

	//! genesis callfunc cannot handle strings nor can it handle ints
	//! so the return value gets lost for the if statement

	//- get name of electrode

	str electrode = {XCellElectrodeName {path}}

	//- if the electrode exists

	if ( {exists /electrodes/draw/{electrode}} )

		//- give diagnostics

		echo {electrode}" is already a recording site"

	//- else

	else
		//- add plot for clicked compartment

		callfunc "XGraphPlotCompartment" /Purkinje {path} {color}

		if ( {bXGraphPlotCompartmentResult} )

			//- add electrode for the compartment

			XCellAddElectrode {path} {electrode} {color}
		end
	end
end


///
/// SH:	XCellCBRemovePlot
///
/// PA:	path..:	path to the clicked compartment
///
/// DE:	Callback to remove compartment from graph
///

function XCellCBRemovePlot(path)

str path

	//- remove the electrode

	callfunc XCellRemoveElectrode {path}

	//- remove plot from the clicked compartment

	callfunc "XGraphRemoveCompartment" /Purkinje {path}
end


///
/// SH:	XCellCreate
///
/// DE:	Create the xcell display widget with all buttons
///	set the update clock to clock 9
///

function XCellCreate

	//- create form container

	create xform /xcell [0, 0, 500, 470]

	//- add field for output

	addfield /xcell \
		output -description "Output (toggled widget)"

	//- add field for output source

	addfield /xcell \
		outputSource -description \
				"Output source (compartment subelement)"

	//- add field for output value

	addfield /xcell \
		outputValue -description "Output value (Vm, Ik, Gk, Ek, Ca)"

	//- add field for output flags

	addfield /xcell \
		outputFlags -description "Output flags (1-7)"

	//- add field for output description

	addfield /xcell \
		outputDescription -description "Output description (Title)"

	//- add field for channel mode

	addfield /xcell \
		channelMode -description "Channel display mode (Ik, Gk, Ek)"

	//- add field for registering boundary element

	addfield /xcell \
		boundElement -description "Element with display boundaries"

	//- create the heading at the top

	XCellCreateHeadings

	//- create the draw

	XCellCreateDraw

	//- create color dialog widgets at the bottom

	XCellCreateColorDialogs

	//- create the buttons and toggles

	XCellCreateButtons

	//- prepare the electrodes

	XCellPrepareElectrodes

/*
	// create a form for configuration

	create xform /xcell/configure [250,250,300,150]

	// make it the current element

	pushe /xcell/configure

	// create label with header

	create xlabel heading \
		-label "Color configuration"

	// create color min dialog

	create xdialog colormin \
		-title "Color minimum : "

	// create color max dialog

	create xdialog colormax \
		-title "Color maximum : "

	// create done button

	create xbutton done \
		-title "Done" \
		-script "XCellSetConfigure"

	// create cancel button

	create xbutton cancel \
		-title "Cancel" \
		-script "XCellCancelConfigure"

	// pop previous element

	pope
*/

	// link the xcell and the graph for button clicks
/*
	setfield /xcell/draw/xcell1 \
		script "XCellCBAddPlot.d1 <v> ; XCellCBRemovePlot.d3 <v>"
*/

	setfield /xcell/draw/xcell1 \
		script "XCellCBRemovePlot.d3 <v>"

	//- show the output form

	xshow /xcell
end


end


