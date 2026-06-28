# ============================================================
#  wave.do  -  GENERIC QuestaSim waveform setup
#  Works for ANY testbench: opens the windows, logs every
#  signal, and adds them all recursively to the Wave window.
#  Nothing to edit per project.
# ============================================================

onerror {resume}
quietly WaveActivateNextPane {} 0

# Make sure the Objects and Wave windows exist and are populated.
view objects
view wave

# Record ALL signals (recursively from the loaded top) so the
# Wave window actually has data to display.  This is the step
# that is usually missing when "objects are not loaded".
log -r /*

# Add every signal (testbench + DUT internals) to the Wave window.
add wave -r /*

configure wave -namecolwidth 240
configure wave -valuecolwidth 120
configure wave -signalnamewidth 1
configure wave -timelineunits ns
update
