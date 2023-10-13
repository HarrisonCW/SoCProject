onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+cpu -L xpm -L microblaze_v11_0_8 -L xil_defaultlib -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L lmb_v10_v3_0_11 -L lmb_bram_if_cntlr_v4_0_20 -L blk_mem_gen_v8_4_5 -L iomodule_v3_1_7 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cpu xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {cpu.udo}

run -all

endsim

quit -force
