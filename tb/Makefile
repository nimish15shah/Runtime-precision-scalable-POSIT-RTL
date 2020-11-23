

makeDirs= mkdir -p out log csrc no_backup no_backup/tmp

UVM_HOME= $(VCS_HOME)/etc/uvm-1.1/src
UVM_FILE= $(UVM_HOME)/uvm.sv
UVM_DPI_FILE= $(UVM_HOME)/dpi/uvm_dpi.cc
UVM_OPTIONS= +UVM_NO_RELNOTES
UVM_command= +incdir+$(UVM_HOME) +incdir+$(UVM_DPI) $(UVM_FILE) $(UVM_DPI_FILE) $(UVM_OPTIONS)

INCDIR_0= ../src/ 
INCDIR_1= ../src/posit/

topmodule := tb

vcsBaseCommand= vcs -full64 -sverilog -timescale=1ns/10ps +notimingchecks \
								+lint=PCWM -notice -Mdir=csrc +lint=TFIPC-L -top $(topmodule)
vcsFiles= -l ./log/compile \
-o ./out/simv \
+incdir+$(INCDIR_0) \
+incdir+$(INCDIR_1) \
+incdir+$(INCDIR_2) \
 $(FNAME) 

vcsCompileCommand =  $(vcsBaseCommand) $(UVM_command) $(vcsFiles) 

# Pass FNAME name with "FNAME=xxx" command line argument
lint:
	$(makeDirs) 
	$(vcsCompileCommand)

compile: lint
	
compile_gui:
	$(makeDirs) 
	$(vcsCompileCommand) -debug_access+all

run:
	./out/simv

run_gui:
	./out/simv -gui -vpd_file ./no_backup/tmp/tb.vpd  &

###############
# wave viewer #
###############
#Shows the waveforms dumped by a similator run in gtkwave
gtkwave:
	gtkwave ./out/dump.vcd &

clean:
	\rm -rf simv* *.log *.vpd *.dump csrc *.sim *.mra *.log ucli.key session* *.db vcs.key out/simv* tmp DVEfiles vc_hdrs.h
