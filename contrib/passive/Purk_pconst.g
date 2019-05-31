//genesis  - Purkinje cell M9 genesis2.1 script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

//
// $Id: Purk_pconst.g 1.2 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
//

//////////////////////////////////////////////////////////////////////////////
//'
//' Purkinje tutorial
//'
//' see our site at http://www.bbf.uia.ac.be/ for more information regarding
//' the Purkinje cell and genesis simulation software.
//'
//' contributed by Dieter Jaeger
//'
//////////////////////////////////////////////////////////////////////////////


/* This file defines important simulation parameters, including gmax
** and Ek for all channels.  Everything uses SI units. */
/* All channels are eliminated by zeroing their conductances. */
/* The '/dt' should be removed from the synchan conductances when using
** recent genesis versions (i.e. >= genesis 2.2 */

echo Using Purkinje 2M9 preferences. Crank Nicholson method.
/* variables controlling hsolve integration */
float dt = 2.0e-5
int tab_xdivs = 149; int tab_xfills = 2999
/* The model is quite sensitive to these values in NO_INTERP (caclmode=0) */
float tab_xmin = -0.10; float tab_xmax = 0.05; float Ca_tab_max = 0.300
// only used for proto channels
float GNa = 1, GCa = 1, GK = 1, Gh = 1
/* cable parameters */
float CM = 0.0164 		// *9 relative to passive
// float CM = 0.01		// default for most cell types
float RMs = 1.000 		// /3.7 relative to passive comp
float RMd = 3.0
// float RMd = 0.3			// this is simulating lots of active conductances

float RA = 2.50
// float RA = 1.00 		// value found experimentally in some cell types
/* preset constants */
float ELEAK = -0.0800 		// Ek value used for the leak conductance
float EREST_ACT = -0.080 	// Vm value used for the RESET
/* concentrations */
float CCaO = 2.4000 		//external Ca as in normal slice Ringer
float CCaI = 0.000040		//internal Ca in mM
//diameter of Ca_shells
float Shell_thick = 0.20e-6
float CaTau = 0.00010	 	// Ca_concen tau
/* Currents: Reversal potentials in V and max conductances S/m^2 */
/* Codes: s=soma, m=main dendrite, t=thick dendrite, d=spiny dendrite */
float ENa = 0.045
float GNaFs = 0.0
float GNaPs = 0.0
float ECa = 0.0125*{log {CCaO/CCaI}} // 0.135 V
float GCaTs = 0
float GCaTm = 0
float GCaTt = 0
float GCaTd = 0
float GCaPm = 0
float GCaPt = 0
float GCaPd = 0
float EK = -0.085
float GKAs = 0
float GKAm = 0
float GKdrs = 0
float GKdrm = 0
float GKMs = 0
float GKMm = 0
float GKMt = 0
float GKMd = 0
float GKCm = 0
float GKCt = 0
float GKCd = 0
float GK2m = 0
float GK2t = 0
float GK2d = 0
float Eh = -0.030
float Ghs = 0
/* synapses: */
float E_GABA = -0.080
float G_GABA = 70.0/dt
float GB_GABA = 20.0/dt
float E_non_NMDA = 0.000
float G_par_syn = 750.0/dt
float G_cli_syn = 150.0/dt
