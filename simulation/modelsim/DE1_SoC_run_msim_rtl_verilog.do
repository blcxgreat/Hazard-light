transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/centerLight.sv}
vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/meta.sv}
vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/normalLight.sv}
vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/decideWin.sv}
vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/userInput.sv}
vlog -sv -work work +incdir+C:/Users/10737/Desktop/lab4 {C:/Users/10737/Desktop/lab4/DE1_SoC.sv}

