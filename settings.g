//genesis
//
// $Id: settings.g 1.8.2.2.1.1.1.1.1.1.3.4.1.1.1.2 Thu, 04 Apr 2002 12:46:38 +0200 hugo $
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


// settings.g : control panel settings

int include_settings

if ( {include_settings} == 0 )

	include_settings = 1


include actions.g


//v normal path for xcell script

str cbXCell


///
/// SH:	SettingsBasket
///
/// DE:	display and handle settings for basket firing
///	synaptic strength
///

function SettingsBasket

	//- give an informational message

	echo "Settings for basket axon"

	//- show settings form

	xshow /settings/basket
end


///
/// SH:	SettingsBasketHide
///
/// DE:	Hide settings form for basket axon experiment
///

function SettingsBasketHide

	//- give an informational message

	echo "Hiding settings for basket axons"

	//- show settings form

	xhide /settings/basket
end


///
/// SH:	SettingsBasketSetStrength
///
/// PA:	value.:	new strength/level for synapses
///
/// DE:	Set the strength/level for basket synapses
///

function SettingsBasketSetStrength(value)

float value

	//- give an informational message

	echo "Setting strength for basket synapses to "{value}

	//- set global variable

	basketLevel = {value}
end


///
/// SH:	SettingsBasketCreate
///
/// PA:	path..:	path of parent to contain the form
///
/// DE:	create the form for the settings for basket axon firing
///

function SettingsBasketCreate(path)

str path

	//- give an informational message

	echo "Creating form for basket axons"

	//- retreive registered values for geometry

	int xgeom = {getfield /settings/globals xgeom}
	int ygeom = {getfield /settings/globals ygeom}
	int wgeom = {getfield /settings/globals wgeom}
	int hgeom = {getfield /settings/globals hgeom}

	//- create form

	create xform {path}basket [{xgeom},{ygeom},350,95]

	//- make it the current element

	pushe {path}basket

	//- create title label

	create xlabel heading \
		-label "Basket axon settings"

	//- create dialog for synaptic strength

	create xdialog strength \
		-value {basketLevel} \
		-title "Relative synaptic strength" \
		-script "SettingsBasketSetStrength <v>"

	//- create a button for closing the window

	create xbutton close \
		-title "Done" \
		-script "SettingsBasketHide"

	//- go to previous current element

	pope
end


///
/// SH:	SettingsClimbing
///
/// DE:	display and handle settings for climbing fiber firing
///	delay parameter
///	synaptic strength
///

function SettingsClimbing

	//- give an informational message

	echo "Settings for climbing fiber"

	//- show settings form

	xshow /settings/climbing
end


///
/// SH:	SettingsClimbingHide
///
/// DE:	Hide settings form for climbing fiber experiment
///

function SettingsClimbingHide

	//- give an informational message

	echo "Hiding settings for climbing fiber"

	//- show settings form

	xhide /settings/climbing
end


///
/// SH:	SettingsClimbingSetDelay
///
/// PA:	value.:	new delay between synapses (in msec)
///
/// DE:	Set the delay between consecutive synapses for climbing fiber volley
///

function SettingsClimbingSetDelay(value)

float value

	//- give an informational message

	echo "Setting delay between climbing fiber synapses to "{value}" msec"

	//- set global variable

	delay = {value * 1.0e-3}
end


///
/// SH:	SettingsClimbingSetStrength
///
/// PA:	value.:	new strength for synapses
///
/// DE:	Set the strength for climbing fiber synapses
///

function SettingsClimbingSetStrength(value)

float value

	//- give an informational message

	echo "Setting strength for climbing fiber synapses to "{value}

	//- set global variable

	strength = {value}
end


///
/// SH:	SettingsClimbingCreate
///
/// PA:	path..:	path of parent to contain the form
///
/// DE:	create the form for the settings for climbing fiber firing
///

function SettingsClimbingCreate(path)

str path

	//- give an informational message

	echo "Creating form for climbing fiber"

	//- retreive registered values for geometry

	int xgeom = {getfield /settings/globals xgeom}
	int ygeom = {getfield /settings/globals ygeom}
	int wgeom = {getfield /settings/globals wgeom}
	int hgeom = {getfield /settings/globals hgeom}

	//- create form

	create xform {path}climbing [{xgeom},{ygeom},350,120]

	//- make it the current element

	pushe {path}climbing

	//- create title label

	create xlabel heading \
		-label "Climbing fiber settings"

	//- create dialog for delay between synapses

	create xdialog delay \
		-value {delay * 1000} \
		-title "Delay between synapses (msec) : " \
		-script "SettingsClimbingSetDelay <v>"

	//- create dialog for synaptic strength

	create xdialog strength \
		-value {strength} \
		-title "Relative synaptic strength" \
		-script "SettingsClimbingSetStrength <v>"

	//- create a button for closing the window

	create xbutton close \
		-title "Done" \
		-script "SettingsClimbingHide"

	//- go to previous current element

	pope
end


///
/// SH:	SettingsIClamp
///
/// DE:	display and handle settings for current clamp
///

function SettingsIClamp

	//- give an informational message

	echo "Settings for current clamp experiment"

	//- show the form for current clamping

	//! this still uses a hard coded path

	xshow /settings/iClamp
end


///
/// SH:	SettingsIClampSetGenerator
///
/// DE:	Set the generator settings to respect the global variables
///	vars :	{iClampCurrentBase}
///		{iClampCurrentOffset}
///		{iClampCurrentWidth}
///		{iClampCurrentPeriod}
///
/// NO:	This function has become obsolete, it has been recoded in actions.g .
///

// function SettingsIClampSetGenerator

// 	//- set fields of generator

// 	setfield /settings/iClamp/current \
// 		level1 {{iClampCurrentBase + iClampCurrentOffset} * 1.0e-9} \
// 		baselevel {iClampCurrentBase * 1.0e-9} \
// 		width1 {iClampCurrentWidth * 1.0e-3} \
// 		delay2 {iClampCurrentPeriod * 1.0e-3} \
// 		ctecurrent {iClampCurrentBase * 1.0e-9} \
// 		delay1 0 \
// 		level2 0 \
// 		width2 0 \
// 		trig_mode 0
// end


///
/// SH:	SettingsIClampCreateGenerator
///
/// PA:	path..:	path of parent to contain the object
///
/// DE:	create the pulse generator for current injection experiments
///	A message to the soma of the cell is created, so the solver
///	must not yet be set up.
///
/// NO:	This function has become obsolete, it has been recoded in actions.g .
///

// function SettingsIClampCreateGenerator(path)

// str path

// 	//- go to the given element

// 	pushe {path}

// 	//- create the pulsegen object

// 	create pulsegen current

// 	//- set fields for pulse generator

// 	setfield ^ \
// 		level1 2.0e-9 \
// 		width1 30 \
// 		delay1 0 \
// 		level2 0 \
// 		width2 0 \
// 		delay2 0 \
// 		baselevel 0 \
// 		trig_mode 0

// 	//- add a field for a constant current

// 	addfield ^ ctecurrent \
// 		-description "Constant current"

// 	//- set this field to something sensefull

// 	setfield ^ ctecurrent 2.0e-9

// 	//- create a disabled compartment for messaging the solver

// 	create compartment messenger

// 	//- add a message from the messenger to the soma of the cell

// 	addmsg messenger {cellpath}/soma INJECT inject

// 	//- set the fields for current clamp to registered globals

// 	//SettingsIClampSetGenerator
// 	ActionIClampSetGenerator /actions/iClamp/

// 	//- go to previous current element

// 	pope
// end


///
/// SH: SettingsIClampHide
///
/// DE:	hide the IClamp settings window
///

function SettingsIClampHide

	//- hide the window

	//! this uses still a hard coded path

	xhide /settings/iClamp
end


///
/// SH:	SettingsIClampSetCurrent
///
/// PA:	level.:	value in nA for current
///
/// DE:	set the current for the pulse generator and for cte current
///

function SettingsIClampSetCurrent(level)

float level

	if (level <= 10)

		//- give diagnostics

		echo "Setting base current to "{level}" nA"

		//- set global variable

		iClampCurrentBase = {level}

		//- set the fields for current clamp to registered globals

		ActionIClampSetGenerator /actions/iClamp/

	else
		//- give diagnostics

		echo "Base current above 10 nA not allowed."

		//- reset dialog

		setfield /settings/iClamp/level \
			value {iClampCurrentBase}
	end
end


///
/// SH:	SettingsIClampSetOffset
///
/// PA:	offset:	value in nA for pulse offset
///
/// DE:	set offset for current pulses
///

function SettingsIClampSetOffset(offset)

float period

	if (offset <= 10)

		//- give diagnostics

		echo "Setting pulse offset to "{offset}" nA"

		//- set global variable

		iClampCurrentOffset = {offset}

		//- set the fields for current clamp to registered globals

		ActionIClampSetGenerator /actions/iClamp/

	else
		//- give diagnostics

		echo "Pulse Amplitude above 10 nA not allowed."

		//- reset dialog

		setfield /settings/iClamp/offset \
			value {iClampCurrentOffset}
	end
end


///
/// SH:	SettingsIClampSetPeriod
///
/// PA:	period:	value in msec for period
///
/// DE:	set period for current pulses
///

function SettingsIClampSetPeriod(period)

float period

	//- give diagnostics

	echo "Setting pulse period to "{period}" msec"

	//- if the period is smaller than the width

	if (iClampCurrentWidth <= period)

		//- set global variable

		iClampCurrentPeriod = {period}

		//- set the fields for current clamp to registered globals

		ActionIClampSetGenerator /actions/iClamp/

	//- else period is greater than width

	else
		//- notice the user

		echo "Period must be greater than width"
	end
end


///
/// SH:	SettingsIClampSetTarget
///
/// PA:	width.:	value in msec for width of pulses
///
/// DE:	set width for width of pulses
///

function SettingsIClampSetTarget(target)

str target

	//- give diagnostics

	echo "Setting current clamp target to compartment" \
		{cellpath}"/"{target}

	//- if exists 

	if ( {exists {{cellpath} @ "/" @ {target}}} )

		//- set global variable

		iClampCurrentTarget = {target}

		//- set the fields for current clamp to registered globals

		ActionIClampSetGenerator /actions/iClamp/

	//- else 

	else
		//- notice the user

		echo "Compartment not found"
	end
end


///
/// SH:	SettingsIClampSetWidth
///
/// PA:	width.:	value in msec for width of pulses
///
/// DE:	set width for width of pulses
///

function SettingsIClampSetWidth(width)

float width

	//- give diagnostics

	echo "Setting pulse width to "{width}" msec"

	//- if the period is smaller than the width

	if (width <= iClampCurrentPeriod)

		//- set global variable

		iClampCurrentWidth = {width}

		//- set the fields for current clamp to registered globals

		ActionIClampSetGenerator /actions/iClamp/

	//- else period is greater than width

	else
		//- notice the user

		echo "Period must be greater than width"
	end
end


///
/// SH:	SettingsIClampSwitch
///
/// DE:	Enable/disable current clamp according to {iCurrentMode}
///	Enabling the current clamp mode means adding a message from the pulse
///	generator to the soma of the Purkinje cell. A look is made to the 
///	state of the toggle button to make difference between constant current
///	and current pulses
///
/// NO:	This function has become obsolete, current switching is now done in
///	in actions.g .
///

function SettingsIClampSwitch

	//- if current clamp is enabled

	if (iCurrentMode != 0)

		//- if pulse train toggle button is clicked

		if ( {getfield /settings/iClamp/pulse state} == 1)

			//- give some info

			echo "Switching to current pulses"

			//- add message from generator to soma 
			//- for current pulses

			addmsg /settings/iClamp/current \
				/settings/iClamp/messenger \
				INJECT output

		//- else

		else

			//- give some info

			echo "Switching to constant current"

			//- from generator to soma for constant current

			addmsg /settings/iClamp/current \
				/settings/iClamp/messenger \
				INJECT ctecurrent
		end

		//- reset the pulse generator

		call /settings/iClamp/current RESET

	//- else current clamp is disabled

	else

		//- give some info

		echo "Switching off current injection"

		//- delete outgoing message from the pulse generator

		deletemsg /settings/iClamp/current 0 -outgoing

		//- clear the inject field of the messenger object

		setfield /settings/iClamp/messenger \
			inject 0
	end
end


///
/// SH:	SettingsIClampToggleMode
///
/// DE:	toggle pulse mode for the current injection
///	If the current mode is not active (iCurrentMode is zero), 
///	nothing is done
///

function SettingsIClampToggleMode

	//- get state of toggle button

	int state = {getfield /settings/iClamp/pulse state}

	//- check if current mode is enabled

	if ( {iCurrentMode} != 0)

		//- stop current mode

		ActionIClampStop

		//- start new current with appropriate state

		ActionIClampStart {state}
	end

	//- check state of toggle button

	if ( {state} == 1)

		//- hide the offset, width and period labels

		xhide /settings/iClamp/nooffset
		xhide /settings/iClamp/nowidth
		xhide /settings/iClamp/noperiod

		//- show the offset, width and period dialogs

		xshow /settings/iClamp/offset
		xshow /settings/iClamp/width
		xshow /settings/iClamp/period
	else

		//- hide the offset, width and period dialogs

		xhide /settings/iClamp/offset
		xhide /settings/iClamp/width
		xhide /settings/iClamp/period

		//- show the offset, width and period labels

		xshow /settings/iClamp/nooffset
		xshow /settings/iClamp/nowidth
		xshow /settings/iClamp/noperiod
	end
end


///
/// SH:	SettingsIClampCreate
///
/// PA:	path..:	path of parent to contain the form (ending in /)
///
/// DE:	create the form for the settings for current clamp
///	create the pulse generator for current clamp
///

function SettingsIClampCreate(path)

str path

	//- give an informational message

	echo "Creating form for current clamping"

	//- retreive registered values for geometry

	int xgeom = {getfield /settings/globals xgeom}
	int ygeom = {getfield /settings/globals ygeom}
	int wgeom = {getfield /settings/globals wgeom}
	int hgeom = {getfield /settings/globals hgeom}

	//- create form

	create xform {path}iClamp [{xgeom},{ygeom},{wgeom},{hgeom}]

	//- make it the current element

	pushe {path}iClamp

	//- create title label

	create xlabel heading \
		-label "Current clamp settings"

	//- create dialog for current injection

	create xdialog level \
		-value {iClampCurrentBase} \
		-title "Level  (nA) : " \
		-script "SettingsIClampSetCurrent <v>"

// 	// create dialog for target element

// 	create xdialog target \
// 		-value {iClampCurrentTarget} \
// 		-title "Target comp : " \
// 		-script "SettingsIClampSetTarget <v>"

	//- create toggle button for pulse or constant

	create xtoggle pulse \
		-title ""

	//- set fields for on/off state

	setfield pulse \
		onlabel "Current pulses" \
		offlabel "Constant current"

	//- set script for toggle button

	setfield pulse \
		script "SettingsIClampToggleMode"

	//- create dialog for pulse offset

	create xdialog offset \
		-value {iClampCurrentOffset} \
		-title "Pulse amplitude (nA) : " \
		-script "SettingsIClampSetOffset <v> "

	//- create dialog for pulse width

	create xdialog width \
		-value {iClampCurrentWidth} \
		-title "Pulse width   (msec) : " \
		-script "SettingsIClampSetWidth <v>"

	//- create dialog for period between pulses

	create xdialog period \
		-value {iClampCurrentPeriod} \
		-title "Pulse period  (msec) : " \
		-script "SettingsIClampSetPeriod <v>"

	//- create a button for closing the window

	create xbutton close \
		-title "Done" \
		-script "SettingsIClampHide"

	//- create a label for no offset

	create xlabel nooffset \
		-ygeom 3:pulse \
		-title "Amplitude not available"

	//- hide the offset dialog

	xhide offset

	//- create a label for no width

	create xlabel nowidth \
		-ygeom 3:offset \
		-title "Width not available"

	//- hide the width dialog

	xhide width

	//- create label for no period

	create xlabel noperiod \
		-ygeom 3:width \
		-title "Period not available"

	//- hide the period dialog

	xhide period

	//- pop previous current element

	pope
end


///
/// SH: SettingsParallel
///
/// DE:	display and handle settings for parallel synchro firing
///	handles localization within xcell
///	handles settings for uniform distribution
///	handles amplitude (strength of synapses)
///

function SettingsParallel

	//- give an informational message

	echo "Settings for synchronous parallel fiber firing"

	//- show the form for current clamping

	//! this still uses a hard coded path

	xshow /settings/parallel
end


///
/// SH: SettingsParallelHide
///
/// DE:	hide the parallel settings window
///

function SettingsParallelHide

	//- hide the window

	//! this uses still a hard coded path

	xhide /settings/parallel
end


///
/// SH: SettingsParallelLocalSet
///
/// PA:	branch:	dendrite clicked on within xcell
///
/// DE:	Set local dendrites for synchronous firing
///	Resets script field for xcell widget
///

function SettingsParallelLocalSet(branch)

	//- default we give a popup

	int bPopup = 1

	//- reset field for xcell script

	setfield /xcell/draw/xcell1 \
		script {cbXCell}

	//- isolate tail from clicked membrane

	str branchTail = {getpath {branch} -tail}

	//- find opening brace for array

	int openBrace = {findchar {branchTail} "["}

	//- if the argument is from an array

	if (openBrace != -1)

		//- cut off the index and set global variable

		str branchNoIndex = {substring {branchTail} 0 {openBrace - 1}}

		//- if the branch has an associated mapping

		if ({exists /mappings/{branchNoIndex}})

			//- set synchro global

			synchroBranch = {branchNoIndex}

			//- update the label field

			setfield /settings/parallel/labelArea \
				label "Branch : "{synchroBranch}

			//- we should not give a popup

			bPopup = 0

			//- give diagnostics

			echo \
				"Synchronous parallel fiber set to" \
				{synchroBranch}
		end
	end

	//- if we should give a popup

	if (bPopup)

		//- show the popup

		xshow /settings/localFailed

	//- else the action completed

	else
		//- hide the local set action window

		xhide /settings/localSet
	end
end


///
/// SH: SettingsParallelLocalChoose
///
/// DE:	Initiate choose branch for local synchronous firing
///	This function messes with the xcell call back script
///

function SettingsParallelLocalChoose

	//- store field for xcell script

	cbXCell = {getfield /xcell/draw/xcell1 script}

	//- set field for xcell script

	setfield /xcell/draw/xcell1 \
		script "SettingsParallelLocalSet <v>"

	//- show the local set action window

	//! this still uses a hard coded path

	xshow /settings/localSet
end


///
/// SH: SettingsParallelLocalCancel
///
/// DE:	Cancel an choose area for local activation
///

function SettingsParallelLocalCancel

	//- hide the local set action window

	//! this still uses a hard coded path

	xhide /settings/localSet

	//- restore field for xcell script

	setfield /xcell/draw/xcell1 \
		script {cbXCell}
end


///
/// SH: SettingsParallelLocalFail
///
/// DE:	Hide the popup and action window for parallel activation
///

function SettingsParallelLocalFail

	//- hide the popup

	//! this still uses a hard coded path

	xhide /settings/localFailed

	//- hide the local set action window

	//! this still uses a hard coded path

	xhide /settings/localSet
end


///
/// SH: SettingsParallelSetLevel
///
/// PA:	level.:	new level for synchro activation
///
/// DE:	Set the level for synchronous parallel activation
///

function SettingsParallelSetLevel(level)

float level

	//- if setting local activation

	if (bSynchroLocal)

		//- give descriptive message

		echo "Setting local parallel fiber activation level to "{level}

		//- set new activation level

		synchroLocalLevel = {level}

	//- else setting distributed activation

	else
		//- give descriptive message

		echo "Setting distributed parallel fiber activation level to "{level}

		//- set new activation level

		synchroDistrLevel = {level}
	end
end


///
/// SH: SettingsParallelUpdateLevel
///
/// DE:	Update parallel activation level according to mode of synchro firing
///

function SettingsParallelUpdateLevel

	//- if we are in local parallel fiber mode

	if (bSynchroLocal)

		//- set value to local activation strength

		setfield /settings/parallel/level \
			value {synchroLocalLevel}

	//- else distributed firing

	else
		//- set value to distributed activation strength

		setfield /settings/parallel/level \
			value {synchroDistrLevel}
	end
end


///
/// SH: SettingsParallelUpdateWindow
///
/// DE:	Update the settings window after a change in distributed / local mode
///

function SettingsParallelUpdateWindow

	//- if local mode is active

	if (bSynchroLocal)

		//- hide the number dialog

		xhide /settings/parallel/number

		//- show the cte number label

		xshow /settings/parallel/ctenumber

		//- set label of distributed / local

		setfield /settings/parallel/labelLocalDistr \
			label "Local"

	//- else distributed mode is active

	else

		//- show the number dialog

		xshow /settings/parallel/number

		//- hide the cte number label

		xhide /settings/parallel/ctenumber

		//- set label of distributed / local

		setfield /settings/parallel/labelLocalDistr \
			label "Distributed"
	end

	//- update parallel activation strength

	SettingsParallelUpdateLevel
end


///
/// SH: SettingsParallelToggleMode
///
/// DE:	Toggle the mode for parallel fiber synchro firing
///

function SettingsParallelToggleMode

	//- if local mode is active

	if (bSynchroLocal)

		//- give descriptive message

		echo "Setting parallel fiber mode to distributed firing"

		//- switch to distributed mode

		bSynchroLocal = 0
	else

		//- give descriptive message

		echo "Setting parallel fiber mode to local firing"

		//- switch to local mode

		bSynchroLocal = 1
	end

	//- update the settings window

	SettingsParallelUpdateWindow
end


///
/// SH: SettingsParallelSetSynapses
///
/// PA:	number:	number of synapses to activate
///
/// DE:	Set the number of synapses for synchronous parallel activation
///

function SettingsParallelSetSynapses(number)

int level

	//- give descriptive message

	echo "Setting number of synchronous parallel fibers to "{number}

	//- set new activation level

	synchroSynapses = {number}
end


///
/// SH:	SettingsParallelCreate
///
/// PA:	path..:	path of parent to contain the form
///
/// DE:	create the form for the settings for synchro parallel fiber firing
///

function SettingsParallelCreate(path)

str path

	//- give an informational message

	echo "Creating form for parallel fiber settings"

	//- retreive registered values for geometry

	int xgeom = {getfield /settings/globals xgeom}
	int ygeom = {getfield /settings/globals ygeom}
	int wgeom = {getfield /settings/globals wgeom}
	int hgeom = {getfield /settings/globals hgeom}

	//- create form

	create xform {path}parallel [{xgeom},{ygeom},350,170]

	//- make it the current element

	pushe {path}parallel

	//- create title label

	create xlabel heading \
		-label "Synchronous parallel fiber firing settings"

	//- create dialog for distributed synaptic activation

	create xdialog number \
		-title "Number   of   synapses     : " \
		-value {synchroSynapses} \
		-script "SettingsParallelSetSynapses <v>"

	//- create label for local synaptic activation

	create xlabel ctenumber \
		-ygeom 3:heading \
		-title "Number of synapses is set to 20"

	//- hide the label

	xhide ctenumber

	//- create dialog for synaptic activation strength

	//! value will be updated later on

	create xdialog level \
		-ygeom 0:number \
		-title "Relative synaptic strength : " \
		-script "SettingsParallelSetLevel <v>"

	//- create button for local/distribute firing

	create xbutton localDistr \
		-wgeom 60% \
		-title "Toggle distributed/local" \
		-script "SettingsParallelToggleMode"

	//! the label field in follwing widget is not relevant,
	//! it will be updated later on

	//- create label to indicate current state of firing

	create xlabel labelLocalDistr \
		-xgeom 0:localDistr \
		-ygeom 1:level \
		-wgeom 40% \
		-title "Distributed"

	//- create button to user choose an area in the xcell

	create xbutton chooseArea \
		-ygeom 0:localDistr \
		-wgeom 60% \
		-title "Change area from xcell" \
		-script "SettingsParallelLocalChoose"

	//- create a label to show the local branch

	create xlabel labelArea \
		-xgeom 0:chooseArea \
		-ygeom 1:localDistr \
		-wgeom 40% \
		-title "Branch : "{synchroBranch}

	//- create a button for closing the window

	create xbutton close \
		-ygeom 0:chooseArea \
		-title "Done" \
		-script "SettingsParallelHide"

	//- update the status of the local / distr label

	SettingsParallelUpdateWindow

	//- pop previous current element

	pope

	//- create form for when local set is active

	create xform {path}localSet [500,250,350,110]

	//- make it the current element

	pushe {path}localSet

	//- create title label

	create xlabel heading1 \
		-label "Click on Purkinje cell dendrite "

	create xlabel heading2 \
		-label "to select next activation site"

	create xlabel heading3 \
		-label "for local parallel fiber input"

	//- create a button to cancel the action

	create xbutton cancel \
		-title "Cancel" \
		-script "SettingsParallelLocalCancel"

	//- pop previous current element

	pope

	//- create form for when local set failed

	create xform {path}localFailed [100,250,350,90]

	//- make it the current element

	pushe {path}localFailed

	//- create title label

	create xlabel heading \
		-label "This branch does not contain enough synapses"

	//- create label with question

	create xlabel question \
		-label "Do you want to choose another branch ?"

	// following code would read better with the '@' operator but
	// that does not work very well
	// perhaps if surrounded with '{', '}' ?

	//- create 'Yes' button

	create xbutton yes \
		-wgeom 50% \
		-title "Yes" \
		-script "SettingsParallelLocalFail;SettingsParallelLocalChoose"

	//- create 'No' button

	create xbutton no \
		-xgeom 0:yes \
		-ygeom 0:question \
		-wgeom 50% \
		-title "No" \
		-script "SettingsParallelLocalFail"

	//- pop previous current element

	pope
end


///
/// SH:	SettingsVivo
///
/// DE:	display and handle settings for vivo mode
///	is dependent on vivo / vitro mode as registered in /mode element
///	vitro : 
///		no parameters
///	vivo : 
///		firing rate in Hz for parallel fibers
///		firing rate in Hz for basket cells
///

function SettingsVivo

	//- give an informational message

	echo "Settings for vivo simulation"

	//- show the form for current clamping

	//! this still uses a hard coded path

	xshow /settings/vivoVitro
end


///
/// SH: SettingsVivoHide
///
/// DE:	hide the vivo settings window
///

function SettingsVivoHide

	//- hide the window

	//! this uses still a hard coded path

	xhide /settings/vivoVitro
end


///
/// SH: UpdateFrequencies
///
/// DE:	update the frequencies for parallel fibers and stellate axons
///	The new frequencies depend on the global {iVVMode} for setting
///	or deleting the frequencies and the globals {phertz} and {ihertz}
///
/// NO: This function uses hsolve's HSAVE / HRESTORE actions to update 
///	the internals of hsolve. This means that fields of all compartments
///	and concentrations should be consistent between 
///	hsolve - normal elements.
///

function UpdateFrequencies

	//- give diagnostics

	if (iVVMode == 0)

		echo "New firing frequencies are "
		echo "  parallel fibers : "{0}
		echo "  stellate cells  : "{0}
	else
		echo "New firing frequencies are "
		echo "  parallel fibers : "{phertz}
		echo "  stellate cells  : "{ihertz}
	end

	echo "Updating synaptic firing frequencies..." -n

	//- show message to user

	xshow /settings/updateFrequencies

	//- update the update freq form

	xupdate /settings/updateFrequencies

	//- synchronize X events

	xflushevents

	echo "..." -n

	//- put the state of the solve element into the originals

	call {cellpath}/solve HSAVE

	//- loop over all channels that should be adjusted

	str element

	foreach element ( {el {cellpath}/##[][TYPE=synchan]} )

		//- for vitro mode

		if (iVVMode == 0)

			//- set element frequency to zero

			setfield {element} frequency 0

		//- for vivo mode

		else
			//- for excitatory synaptic channel

			if ( {getfield {element} synmode} == "ex")

				//- change frequency for vivo mode

				setfield {element} frequency {phertz}

			//- for inhibitory synaptic channel

			elif ( {getfield {element} synmode} == "in")

				//- change frequency for vivo mode

				setfield {element} frequency {ihertz}
			end
		end
	end

	//- update the solve object

	call {cellpath}/solve HRESTORE

	//- hide the message to the user (if it has ever been shown)

	xhide /settings/updateFrequencies

	//- update the update freq form

	xupdate /settings/updateFrequencies

	//- synchronize X events

	xflushevents

	echo "..." -n

	//- give diagnostics

	echo "done"
end


///
/// SH:	SettingsVivoPfFrequencies
///
/// PA:	paraHz:	new parallel firing frequency
///
/// DE:	set the average firing frequency in Hz for asynchronous parallel
///	firing
///	sets the globals {phertz} and calls UpdateFrequencies
///

function SettingsVivoPfFrequencies(paraHz)

float paraHz

	//- set phertz variable

	phertz = {paraHz}

	//- update the firing frequencies

	UpdateFrequencies
end


///
/// SH:	SettingsVivoScFrequencies
///
/// PA:	stelHz:	new stellate firing frequency
///
/// DE:	sets global {ihertz} and calls UpdateFrequencies
///

function SettingsVivoScFrequencies(stelHz)

float stelHz

	//- set ihertz variable

	ihertz = {stelHz}

	//- update the firing frequencies

	UpdateFrequencies
end


///
/// SH:	SettingsVivoCreate
///
/// PA:	path..:	path of parent to contain the form
///
/// DE:	create the form for the settings for vivo mode.
///	Create the form for update frequencies message.
///

function SettingsVivoCreate(path)

str path

	//- give an informational message

	echo "Creating form for vivo settings"

	//- retreive registered values for geometry

	int xgeom = {getfield /settings/globals xgeom}
	int ygeom = {getfield /settings/globals ygeom}
	int wgeom = {getfield /settings/globals wgeom}
	int hgeom = {getfield /settings/globals hgeom}

	//- set values for geometry

	wgeom = 300
	hgeom = 120

	//- create form

	create xform {path}vivoVitro [{xgeom},{ygeom},{wgeom},{hgeom}]

	//- make it the current element

	pushe {path}vivoVitro

	//- create title label

	create xlabel heading \
		-label " In vivo settings"

	//- create dialog for parallel fiber firing rate

	create xdialog parallel \
		-value {phertz} \
		-title "Parallel fiber rate (Hz) : " \
		-script "SettingsVivoPfFrequencies <v> "

	//- create dialog for stellate cell firing rate

	create xdialog stellate \
		-value {ihertz} \
		-title "Stellate cell  rate (Hz) : " \
		-script "SettingsVivoScFrequencies <v>"

	create xbutton close \
		-title "Done" \
		-script "SettingsVivoHide"

	//- pop previous current element

	pope

	//- create update frequencies form

	create xform {path}updateFrequencies [150,180,200,60]

	//- make it the current element

	pushe {path}updateFrequencies

	//- create title label

	create xlabel heading \
		-label "Reconfiguring setup"

	//- create additional message

	create xlabel message \
		-label "Please wait..."

	//- pop previous current element

	pope
end


///
/// SH:	SettingsCreate
///
/// DE: create all settings forms but keep them hidden
///	creates a neutral element named globals that has fields for all
///	settings forms
///

function SettingsCreate

	//- give an informational message

	echo "Creating all setting forms"

	//- create a parent for all setting forms

	create neutral /settings

	//- create globals element

	create neutral /settings/globals

	//- add fields for positions

	addfield ^ xgeom
	addfield ^ ygeom
	addfield ^ wgeom
	addfield ^ hgeom

	//- give some reasonable defaults for positions

	setfield ^ \
		xgeom 500 \
		ygeom 430 \
		wgeom 250 \
		hgeom 210
//		hgeom 240

	//- create the form for the basket axon firing settings

	SettingsBasketCreate /settings/

	//- create the form for the climbing fiber firing settings

	SettingsClimbingCreate /settings/

	//- create the form for current clamping

	SettingsIClampCreate /settings/

	//- create the form for parallel fiber firing settings

	SettingsParallelCreate /settings/

	//- create the form for vivo settings

	SettingsVivoCreate /settings/
end


end


