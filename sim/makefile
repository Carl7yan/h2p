###################################################
## File name : makefile													 ##
## Author    : CKY														   ##
## Function  : As a script for emulating ahb2apb ##
###################################################

help:
	@echo "==================================================";
	@echo "Usage:";
	@echo "  > make regress         - run all tests";
	@echo "  > make test_index      - run individual test[see list below]";
	@echo "  > make clean           - run CLEAN script";
	@echo "  > make summary         - generate summary";
	@echo "";
	@echo "  ---------------------------------------------   ";
	@echo "  test_index   test_name ";
	@echo "  ---------------------------------------------   ";
	@echo "  t1           ahbl_mst_single_read32";
	@echo "  t2           ahbl_mst_single_write32_apb_slv_nrdy";
	@echo "  t3           ahbl_mst_burst";
	@echo "  t4           ahbl_mst_burst_apb_slv_slverr";
	@echo "  t5           ahbl_mst_tight_transfer ";
	@echo "==================================================";

##############################
#Makefile variables
#############################

COV_CMD = -cm line+cond+fsm+tgl+branch -cm_tgl -cm_linecontassign  \
					-cm_cond allops+anywidth +event -cm_noseqconst -debug_all

SEED=`date +%N`

VCS_CMD_RAND		 = vcs +vcdpluson -full64  -sverilog -ntb_opts uvm-1.1 \
									 -cm assert  +define  \
									 +nospecify +notimingcheck +vip \
								   -timescale=1ns/1ns +vcs+lic+wait -full64 +vcsd +memcbk \
					  	     -debug_pp -Mupdate +ntb_solver_array_size_warn=100000 \
									 +${SEED} -R

SIM_COV = -cm line+cond+fsm+tgl+branch

DESIGN_FILES		 = ../rtl/*.v

TESTBENCH_FILES	 = +incdir+../dv/vip/ahbl_mst/ \
									 +incdir+../dv/vip/apb_slv/ \
									 +incdir+../dv/env/ \
									 +incdir+../dv/tc/ \
									 ../dv/vip/ahbl_mst/ahbl_mst_pkg.sv \
					 				 ../dv/vip/apb_slv/apb_slv_pkg.sv \
									 ../dv/env/ahb2apb_pkg.sv \
									 ../dv/tb/reset_if.sv \
									 ../dv/tb/ahb2apb_tb.sv \
									 ../dv/env/ahb2apb_base_test.sv \
									 ../dv/seqlib/ahbl_mst_seqlib.sv \
									 ../dv/seqlib/apb_slv_seqlib.sv \
									 ../dv/tc/test_lib.sv

SIM_CMD = ${VCS_CMD_RAND} ${DESIGN_FILES} ${TESTBENCH_FILES} ${SIM_COV} +DUMP_VPD

###########################
##Makefile targets
###########################
regress:all_tests summary

all_tests: t1 t2 t3 t4 t5

#Bogus targets  -> map to real testnames
t1: SEED ahbl_mst_single_read32
t2: SEED ahbl_mst_single_write32_apb_slv_nrdy
t3: SEED ahbl_mst_burst
t4: SEED ahbl_mst_burst_apb_slv_slverr
t5: SEED ahbl_mst_tight_transfer

SEED:
	@echo "***SEED:${SEED}***";

ahbl_mst_single_read32:
	${SIM_CMD} +VPD_FILENAME=../sim/VPD/$@_${SEED}.vpd +UVM_TESTNAME=$@ -l ../sim/LOG/$@_${SEED}.log -o ../sim/SIMV/$@_${SEED}sim
ahbl_mst_single_write32_apb_slv_nrdy:
	${SIM_CMD} +VPD_FILENAME=../sim/VPD/$@_${SEED}.vpd +UVM_TESTNAME=$@ -l ../sim/LOG/$@_${SEED}.log -o ../sim/SIMV/$@_${SEED}sim
ahbl_mst_burst:
	${SIM_CMD} +VPD_FILENAME=../sim/VPD/$@_${SEED}.vpd +UVM_TESTNAME=$@ -l ../sim/LOG/$@_${SEED}.log -o ../sim/SIMV/$@_${SEED}sim
ahbl_mst_burst_apb_slv_slverr:
	${SIM_CMD} +VPD_FILENAME=../sim/VPD/$@_${SEED}.vpd +UVM_TESTNAME=$@ -l ../sim/LOG/$@_${SEED}.log -o ../sim/SIMV/$@_${SEED}sim
ahbl_mst_tight_transfer:
	${SIM_CMD} +VPD_FILENAME=../sim/VPD/$@_${SEED}.vpd +UVM_TESTNAME=$@ -l ../sim/LOG/$@_${SEED}.log -o ../sim/SIMV/$@_${SEED}sim

summary:
	perl gen_summary.pl | tee summary.log

merge:
	urg -full64 -dir ./SIMV/*.vdb -dbname merged -parallel -report ./urgReport

clean:
	rm -r csrc merged.vdb urgReport  LOG SIMV VPD *.log *.key *.h


