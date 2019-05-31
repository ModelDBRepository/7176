// genesis
//
// $Id: fileio_act.g 1.2 Thu, 04 Apr 2002 11:55:56 +0200 hugo $
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


function makefileoutput

str filename = "Purkinje_results"

create disk_out /output/plot_out
useclock /output/plot_out 9

str hstr

hstr={findsolvefield {cellpath}/solve {cellpath}/soma Vm} // 1
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

hstr={findsolvefield {cellpath}/solve {cellpath}/main[8] Vm} // 2
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/br3[0] Vm} // 3
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/br3[15] Vm} // 4
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/b3s44[8] Vm} // 5
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/b3s44[39] Vm} // 6
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

hstr={findsolvefield {cellpath}/solve {cellpath}/b3s46[15] Vm} // 7
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

hstr={findsolvefield {cellpath}/solve {cellpath}/br1[10] Vm} // 8
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/b1s19[42] Vm}  // 9
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

hstr={findsolvefield {cellpath}/solve {cellpath}/br2[8] Vm} // 10
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}
hstr={findsolvefield {cellpath}/solve {cellpath}/b2s25[34] Vm} // 11
addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

int n, i
n={getfield solve nelm_names }
for (i=0; i<{n}; i = i+1)
        addmsg {cellpath}/solve /output/plot_out SAVE itotal[{i}]
end

// hstr={findsolvefield {cellpath}/solve {cellpath}/soma/NaF Ik}
// addmsg {cellpath}/solve /output/plot_out SAVE {hstr}

enable /output
setfield /output/plot_out filename {filename} initialize 1 append 0 leave_open 1
enable /output/plot_out

end
