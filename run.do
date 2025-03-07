vlib work
vlog  reg_mux.v DSP.v testbench.v
vsim -voptargs=+acc work.testbench
add wave *
run -all
#quit -sim
