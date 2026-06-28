# ============================================================
#  GENERIC QuestaSim Makefile  -  reuse for ANY project/testbench
#  Target board: NEXYS A7 100T
#
#  Two ways to use it:
#  ------------------------------------------------------------
#  1) EDIT the default block below and run:
#         make gui
#
#  2) OVERRIDE on the command line (nothing to edit) - point it
#     at any project's files:
#         make gui SRC_DIR=Seven_Segment_Dispaly \
#                  RTL_SRCS="top_module.v decoder.v" \
#                  TB_SRC=top_module_tb.v \
#                  TB_TOP=top_module_tb
#
#  Targets:  gui | run | compile | clean
# ============================================================

# ------------------------------------------------------------
#  >>> DEFAULT PROJECT (override any of these on the command line) <<<
#  SRC_DIR  : folder holding the .v files (relative to this Makefile)
#  RTL_SRCS : design source files (space separated)
#  TB_SRC   : testbench file
#  TB_TOP   : testbench MODULE name (top of the simulation)
# ------------------------------------------------------------
SRC_DIR  ?= Seven_Segment_Dispaly
RTL_SRCS ?= top_module.v decoder.v
TB_SRC   ?= top_module_tb.v
TB_TOP   ?= top_module_tb

# Shared, generic waveform script (same folder as this Makefile)
WAVE_DO  ?= wave.do

# ------------------------------------------------------------
#  QuestaSim binaries. If vlog/vsim are not on your PATH:
#     make gui QUESTA_BIN=/opt/questasim/2024.1/bin/
# ------------------------------------------------------------
QUESTA_BIN ?=
VLIB = $(QUESTA_BIN)vlib
VLOG = $(QUESTA_BIN)vlog
VSIM = $(QUESTA_BIN)vsim
WORK = work

# Prefix every source file with its folder so vlog finds them.
SRCS = $(addprefix $(SRC_DIR)/, $(RTL_SRCS) $(TB_SRC))

.PHONY: all gui run compile clean

all: gui

# ---- Compile design + testbench into the work library ----
compile:
	$(VLIB) $(WORK)
	$(VLOG) $(SRCS)

# ---- Open QuestaSim GUI, load generic waves, run all ----
gui: compile
	$(VSIM) -gui -voptargs="+acc" $(WORK).$(TB_TOP) -do "do $(WAVE_DO); run -all; wave zoom full"

# ---- Headless run (prints any $display output) ----
run: compile
	$(VSIM) -c $(WORK).$(TB_TOP) -do "run -all; quit -f"

# ---- Remove generated simulation artifacts ----
clean:
	rm -rf $(WORK) transcript vsim.wlf vsim_stacktrace.vstf modelsim.ini *.vcd *.wlf
