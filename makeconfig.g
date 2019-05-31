//genesis - Purkinje cell version M9 genesis2 master script
//
// $Id: makeconfig.g 1.3.3.1.1.2 Thu, 04 Apr 2002 12:46:38 +0200 hugo $
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


//- give header

echo "--------------------------------------------------------------------------"
echo
echo "Purkinje tutorial, version " -n
// $Format: "echo \"$ProjectVersion$ ($ProjectDate$)\""$
echo "Release1.3.2 (Thu, 04 Apr 2002 12:46:38 +0200)"
echo "                      Configuration script"
echo
echo "--------------------------------------------------------------------------"

//- include default definitions

include defaults.g

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

//- set default for current : no current

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
//! the script level. I use the hosttype in the HOSTTYPE shell variable as a
//! guideline for an update of the tabchannels.

//- include the utility module, it is needed by multiple others modules,
//- but since I do not like multiple includes, I include it here.

include utility.g

//- include the config module

include config.g

//- ensure that all elements are made in the library

ce /library


/* userprefs is for loading the preferred set of prototypes into
** the library and assigning new values to the defaults.
** A customised copy of userprefs.g usually lives in  the local
** directory where the simulation is going to be run from */

//- include scripts to create the prototypes

include Purk_chansave.g
include Purk_cicomp 
include Purk_syn 

include info.g
include config.g
include control.g
include xcell.g
include xgraph.g


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

//- add fields to distinguish between inhibition excitation

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

//- update the config file

ConfigWrite {cellfile} {cellpath}

//- exit from genesis

exit


