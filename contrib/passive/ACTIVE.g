//genesis - Purkinje cell version M9 genesis2 master script
// Copyright: Theoretical Neurobiology, Born-Bunge Foundation - UA, 1998-1999.
//
// $Id: ACTIVE.g 1.2 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Purkinje tutorial
//'
//' (C) 1998-2002 BBF-UIA
//'
//' see our site at http://bbf-www.uia.ac.be/ for more information regarding
//' the Purkinje cell and genesis simulation software.
//'
//'
//' functional ideas ... Erik De Schutter, erik@bbf.uia.ac.be
//' genesis coding ..... Hugo Cornelis, hugo@bbf.uia.ac.be
//'
//' general feedback ... Reinoud Maex, Erik De Schutter
//'
//' contributed by Dieter Jaeger
//'
//////////////////////////////////////////////////////////////////////////////

//- give header

echo "-------------------------------------------------------------------------"
echo
echo "Purkinje tutorial, version " -n
// $Format: "echo \"$ProjectVersion$ ($ProjectDate$)\""$
echo "Release1.3.2 (Thu, 04 Apr 2002 12:46:38 +0200)"
echo "                       Simulation script"
echo
echo "-------------------------------------------------------------------------"

//- include default definitions

include defaults.g
include fileio_act.g

//- include Purkinje cell constants

include Purk_const

//- cell path of cell to simulate

str cellpath =  "/Purkinje"

//- cell that is read from pattern file

include cell.g

//- set default output rate

int outputRate = 10

//- set default chanmode for solver : normalized

int iChanMode = 5

//- set default mode : in vitro

int iVVMode = 0

//- set default for current : current clamp on

int iCurrentMode = 1

//- in vivo : parallel cell firing rate

float phertz = 25

//- in vivo : basket cell firing rate

float ihertz = 1

//- speed of climbing fiber volley (in sec)

float delay = 0.00020

//- strength of climging fiber synapses

float strength = 1.0

//- speed of climbing fiber volley (in steps == delay / dt)
//- this variable is set later on when dt is defined in an other module

int delaysteps = 0.00020 / 1

//! The tabchannels need an update when changing from
//! little-endian to big-endian. I don't see a way to figure this out from
//! the script level. I used the hosttype in the HOSTTYPE shell variable as a
//! guideline for an update of the tabchannels, but that didn't work on all
//! systems.

//- include the utility module, it is needed by multiple others modules,
//- but since I do not like multiple includes, I include it here.

include utility.g

//- include the config module

include config.g

//- include the script for saving the tabchannels

include Purk_chansave.g

//- default we do not update the config file

int bUpdateConfig = 0

// determine the hosttype for the config file

//str confighost = {ConfigHostType {cellfile} {cellpath}}

// if the config file does not correspond with OS

//if ( {getenv HOSTTYPE} != confighost )

        // give diagnostics

//      echo Config file created on {confighost},
//      echo now working on {getenv HOSTTYPE}.

        // ensure that all elements are made in the library

//      ce /library

        // make prototypes of channels

//      make_Purkinje_chans

        // remember to update the config file

//      bUpdateConfig = 1

// else we inform the user of cpu format

//else

// give diagnostics

//echo Config file created on {getenv HOSTTYPE} system,
//echo assuming byte order is correct

//end


/* userprefs is for loading the preferred set of prototypes into
** the library and assigning new values to the defaults.
** A customised copy of userprefs.g usually lives in  the local
** directory where the simulation is going to be run from */

//- include scripts to create the prototypes

include Purk_chanload
include Purk_cicomp
include Purk_syn

include info.g
include bounds.g
include config.g
include control.g
include xgraph.g
include xcell.g


//- ensure that all elements are made in the library

ce /library

//- make prototypes of channels and synapses

make_Purkinje_chans
make_Purkinje_syns

//- set the firing frequencies at the library level
//- this forces the hsolve object to reserve space for these fields

setfield /library/GABA frequency {ihertz}
setfield /library/non_NMDA frequency {phertz}

//- add fields to the library elements to respect the vivo / vitro mode

addfield /library/GABA freqmode -description "frequency operation mode"
addfield /library/non_NMDA freqmode -description "frequency operation mode"

//- set the added fields to the current vivo/vitro mode

setfield /library/GABA freqmode {iVVMode}
setfield /library/non_NMDA freqmode {iVVMode}

//- add fields to distinguish between inhibition and excitation

addfield /library/GABA synmode -description "synaptic mode"
addfield /library/non_NMDA synmode -description "synaptic mode"

//- set field to "in" for inhibition

setfield /library/GABA synmode "in"

//- set field to "ex" for excitation

setfield /library/non_NMDA synmode "ex"

//- make prototypes of compartements and spines

make_Purkinje_comps
make_Purkinje_spines

//- read cell data from .p file

readcell {cellfile} {cellpath}

// if the config file needs updating

//if (bUpdateConfig)

        // update the config file

//      ConfigWrite {cellfile} {cellpath}
//end

//- read configuration file

ConfigRead {cellfile} {cellpath}

//- initialize actions

ActionsInit

//- initialize boundaries

BoundsInit "bounds.txt"

//- set simulation clocks

int i, j

for (i = 0; i <= 8; i = i + 1)
	setclock {i} {dt}
end

//- set the output clock

setclock 9 {dt * outputRate}

//- set clock for refresh elements

setclock 10 {dt * 239}

//- set delay in steps for climbing fiber

delaysteps = {delay / dt}

//- setup the hines solver

echo preparing hines solver {getdate}
ce {cellpath}
create hsolve solve

//- We change to current element solve and then set the fields of the parent
//- (solve) to get around a bug in the "." parsing of genesis

ce solve

setfield . \
        path "../##[][TYPE=compartment]" \
        comptmode 1 \
        chanmode {iChanMode} \
        calcmode 0 \
	storemode 1

/*
setfield . \
        path "../b#[][TYPE=compartment],../main[][TYPE=compartment]" \
        comptmode 1 \
        chanmode {iChanMode} \
        calcmode 0
*/


//- create all info widgets

InfoCreate

//- create all settings widgets

SettingsCreate

//- setup the solver with all messages from the settings

call /Purkinje/solve SETUP

//- Use method to Crank-Nicolson

setmethod 11

//- go back to simulation element

ce /Purkinje

makefileoutput

//- set colorscale

xcolorscale rainbow3

//- create the xcell widget

XCellCreate

//- create the graph widget

XGraphCreate

//- set default state

XCellReset

//- reset graph

XGraphReset

//- create the control panel

ControlPanelCreate

//- reset all elements

reset

//- check the simulation

//maxwarnings 10000

//check

//- to further initialize all elements (e.g. colors of xcell element)
//- we do one step in the simulation and then a reset

step 1

//- update the firing frequencies for stellate and parallel fibers

UpdateFrequencies

//- reset all elements

reset

//! now it's up to the user to do simulations...


