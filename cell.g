//genesis
//
// $Id: cell.g 1.10.1.3.2.4.1.2 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
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

int include_cell

if ( {include_cell} == 0 )

	include_cell = 1


// multiple cell files defined with last one that will be read in
// make no assumptions a good working of the tutorial when changing the cell
// file. Try and see.

// cell without spines

str cellfile = "Purk2M9.p"

// cell with spines

str cellfile = "Purk2M9s.p"

// cut off from previous cell
// this cell can automatically fire even without external activation

//str cellfile = "psmall.p"


end


