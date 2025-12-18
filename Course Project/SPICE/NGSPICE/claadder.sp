*cla_adder
.include TSMC_180nm.txt
.param LAMBDA = 0.09u
.param SUPPLY = 1.8v
.param W = {20*LAMBDA}
.param WIDTH_N = {W}
.param WIDTH_P = {2*W} 
.global gnd Vdd

VDD Vdd gnd DC 'SUPPLY'


* Input Signals (a4a3a2a1a0 = 11100 && b4b3b2b1b0 = 11110 expected output ===>  c5 = 1 s4s3s2s1s0 = 11010)
Va0 a0_in gnd 0V
Va1 a1_in gnd 0V
Va2 a2_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns) 
Va3 a3_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns)
Va4 a4_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns)

Vb0 b0_in gnd 0V
Vb1 b1_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns)
Vb2 b2_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns)
Vb3 b3_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns)
Vb4 b4_in gnd PULSE(0 1.8 0ns 0ns 0ns 5ns 10ns) 

Vb8 c0 gnd 0V

VS clk gnd PULSE (0 1.8 1ns 0ns 0ns 3ns 6ns)

.subckt inverter ip op vdd gnd S=1
.param w_p = {2*W}
.param w_n = {W}

Minv1 op ip vdd vdd CMOSP W={S*w_p} L={2*LAMBDA} 
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p} 
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}

Minv2 op ip gnd gnd CMOSN W={S*w_n} L={2*LAMBDA} 
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n} 
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}
.ends inverter

.subckt TSPC_DFF D Q clk Vdd gnd S=1
.param w_p={3*W}
.param w_n={3*W}
* Master Stage
Md1 c1 D Vdd Vdd CMOSP W={S*w_p} L={2*LAMBDA}
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p} 
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}
Md2 x clk c1 Vdd CMOSP W={S*w_p} L={2*LAMBDA}
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p}
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}
Md3 x D gnd gnd CMOSN W={S*w_n} L={2*LAMBDA}
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n} 
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}

* Slave Stage
Md4 y_temp1 clk Vdd Vdd CMOSP W={S*w_p} L={2*LAMBDA}
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p} 
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}
Md44 y x y_temp1 Vdd CMOSP W={S*w_p} L={2*LAMBDA}
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p} 
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}
Md5 y x c2 gnd CMOSN W={S*w_n} L={2*LAMBDA}
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n} 
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}
Md6 c2 clk gnd gnd CMOSN W={S*w_n} L={2*LAMBDA}
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n} 
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}

* Output Stage
Md7 q_bar y Vdd Vdd CMOSP W={S*w_p} L={2*LAMBDA}
+ AS={S*5*w_p*LAMBDA} PS={10*LAMBDA+S*2*w_p} 
+ AD={S*5*w_p*LAMBDA} PD={10*LAMBDA+S*2*w_p}
Md8 q_bar clk c3 gnd CMOSN W={S*w_n} L={2*LAMBDA}
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n}
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}
Md9 c3 y gnd gnd CMOSN W={S*w_n} L={2*LAMBDA}
+ AS={S*5*w_n*LAMBDA} PS={10*LAMBDA+S*2*w_n} 
+ AD={S*5*w_n*LAMBDA} PD={10*LAMBDA+S*2*w_n}

* Final Output Inversion
Xinvv q_bar q vdd gnd inverter
.ends TSPC_DFF

.subckt load in vdd gnd
Ml1 dont_care in vdd vdd CMOSP W={width_P} L={2*LAMBDA} 
+AS={5*width_P*LAMBDA} PS={10*LAMBDA+2*width_P} 
+AD={5*width_P*LAMBDA} PD={10*LAMBDA+2*width_P}
Ml2 dont_care in gnd gnd CMOSN W={width_N} L={2*LAMBDA} 
+AS={5*width_N*LAMBDA} PS={10*LAMBDA+2*width_N} 
+AD={5*width_N*LAMBDA} PD={10*LAMBDA+2*width_N}
.ends load

.subckt NAND ai bi nand_op vdd gnd S=1
.param W_p = {2*W}
.param W_n = {2*W}

M3 nand_op ai Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M4 nand_op bi Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M5 nand_op ai n1 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

M6 n1 bi gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

.ends NAND

*Subcircuit for GENERATE 
.subckt generate ai bi gi vdd gnd S=1
.param W_p = {2*W}
.param W_n = {2*W}

M3 gen_bar ai Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M4 gen_bar bi Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M5 gen_bar ai n1 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

M6 n1 bi gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Xgen gen_bar gi vdd gnd inverter
.ends generate

*Subcircuit for propagate
.subckt propagate ai bi pi vdd gnd S=1
 .param W_p = {2*W}
 .param W_n = {W}

X1 ai ai_bar vdd gnd inverter

M1 c1 ai Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M2 pi bi ai Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M3 pi ai bi Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

M4 c1 ai gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

M5 pi bi c1 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

M6 bi ai_bar pi gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}


.ends propagate

.subckt c2_computation g0 g1 p0 p1 c2 vdd gnd S=1
.param W_p = {2*W}
.param W_n = {W}

Mc11 j_c11 g1 Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc12 c2_bar p1 j_c11 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc13 c2_bar g0 j_c11 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc14 c2_bar g1 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc15 c2_bar p1 j_c12 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc16 j_c12 g0 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Xc2_comp c2_bar c2 vdd gnd inverter
.ends c2_computation

.subckt c3_computation g0 g1 g2 p0 p1 p2 c3 vdd gnd s=1
.param W_p = {2*W}
.param W_n = {W}

Mc21 j_c21 g2 Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc22 c3_bar p2 j_c21 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc23 j_c22 g1 j_c21 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc24 c3_bar p1 j_c22 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc25 c3_bar g0 j_c22 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}



Mc26 c3_bar g2 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc27 c3_bar p2 j_c23 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc28 j_c23 g1 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc29 j_c23 p1 j_c24 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc210 j_c24 g0 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Xc3_comp c3_bar c3 vdd gnd inverter
.ends c3_computation

.subckt c4_computation g0 g1 g2 g3 p0 p1 p2 p3 c4 vdd gnd s=1
.param W_p = {2*W}
.param W_n = {W}

Mc31 j_c31 g3 Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc32 c4_bar p3 j_c31 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc33 j_c32 g2 j_c31 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc34 c4_bar p2 j_c32 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc35 j_c33 g1 j_c32 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc36 c4_bar p1 j_c33 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc37 c4_bar g0 j_c33 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}



Mc311 c4_bar g3 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n}
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc312 c4_bar p3 j_c34 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc313 j_c34 g2 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc314 j_c34 p2 j_c35 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc315 j_c35 g1 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc316 j_c35 p1 j_c36 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc317 j_c36 g0 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Xc4_comp c4_bar c4 vdd gnd inverter
.ends c4_computation

.subckt c5_computation g0 g1 g2 g3 g4 p0 p1 p2 p3 p4 c5 vdd gnd s=1
.param W_p = {2*W}
.param W_n = {W}

Mc41 j_c41 g4 Vdd Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc42 c5_bar p4 j_c41 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc43 j_c42 g3 j_c41 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc44 c5_bar p3 j_c42 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc45 j_c43 g2 j_c42 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc46 c5_bar p2 j_c43 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc47 j_c44 g1 j_c43 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc48 c5_bar p1 j_c44 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc49 c5_bar g0 j_c44 Vdd CMOSP W={S*W_p} L={2*LAMBDA}
+ AS={S*5*W_p*LAMBDA} PS={10*LAMBDA+S*2*W_p} 
+ AD={S*5*W_p*LAMBDA} PD={10*LAMBDA+S*2*W_p}

Mc411 c5_bar g4 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n}
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc412 c5_bar p4 j_c45 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc413 j_c45 g3 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc414 j_c45 p3 j_c46 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc415 j_c46 g2 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc416 j_c46 p2 j_c47 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc417 j_c47 g1 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc418 j_c47 p1 j_c48 gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Mc419 j_c48 g0 gnd gnd CMOSN W={S*W_n} L={2*LAMBDA}
+ AS={S*5*W_n*LAMBDA} PS={10*LAMBDA+S*2*W_n} 
+ AD={S*5*W_n*LAMBDA} PD={10*LAMBDA+S*2*W_n}

Xc5_comp c5_bar c5 vdd gnd inverter
.ends c5_computation

*Outputs from the first DFF
X1 a0_in a0 clk Vdd gnd TSPC_DFF S=1  
X2 a1_in a1 clk Vdd gnd TSPC_DFF S=1
X3 a2_in a2 clk Vdd gnd TSPC_DFF S=1
X4 a3_in a3 clk Vdd gnd TSPC_DFF S=1
X14 a4_in a4 clk Vdd gnd TSPC_DFF S=1

X5 b0_in b0 clk Vdd gnd TSPC_DFF S=1
X6 b1_in b1 clk Vdd gnd TSPC_DFF S=1
X7 b2_in b2 clk Vdd gnd TSPC_DFF S=1
X8 b3_in b3 clk Vdd gnd TSPC_DFF S=1
X15 b4_in b4 clk Vdd gnd TSPC_DFF S=1

*Generate
Xg0 a0 b0 g0 vdd gnd generate s=1
Xg1 a1 b1 g1 vdd gnd generate s=1
Xg2 a2 b2 g2 vdd gnd generate s=1
Xg3 a3 b3 g3 vdd gnd generate s=1
Xg4 a4 b4 g4 vdd gnd generate s=1

*Propagate
Xp0 a0 b0 p0 vdd gnd propagate s=1
Xp1 a1 b1 p1 vdd gnd propagate s=1
Xp2 a2 b2 p2 vdd gnd propagate s=1
Xp3 a3 b3 p3 vdd gnd propagate s=1
Xp4 a4 b4 p4 vdd gnd propagate s=1

*Comutation of C1 C2 C3 C4 and C5
Xc1 a0 b0 c1 vdd gnd generate s=1
Xc2 g0 g1 p0 p1 c2 vdd gnd c2_computation S=1
Xc3 g0 g1 g2 p0 p1 p2 c3 vdd gnd c3_computation s=1
Xc4 g0 g1 g2 g3 p0 p1 p2 p3 c4 vdd gnd c4_computation s=1
Xc5 g0 g1 g2 g3 g4 p0 p1 p2 p3 p4 c5 vdd gnd c5_computation s=1

*Sum
Xs0 p0 c0 s0 vdd gnd propagate s=1
Xs1 p1 c1 s1 vdd gnd propagate s=1
Xs2 p2 c2 s2 vdd gnd propagate s=1
Xs3 p3 c3 s3 vdd gnd propagate s=1
Xs4 p4 c4 s4 vdd gnd propagate s=1

*Outputs from the DFF's
X9 s0 s0_out clk Vdd gnd TSPC_DFF S=1
X10 s1 s1_out clk Vdd gnd TSPC_DFF S=1
X11 s2 s2_out clk Vdd gnd TSPC_DFF S=1
X12 s3 s3_out clk Vdd gnd TSPC_DFF S=1
X16 s4 s4_out clk Vdd gnd TSPC_DFF S=1

X13 c4 c4_out clk Vdd gnd TSPC_DFF S=1
X17 c5 c5_out clk Vdd gnd TSPC_DFF S=1
x34 c5_out vdd gnd load


.tran 10ps 30ns

* .measure: .measure tran result TRIG v(node) VAL=value RISE/FALL=occurrence TARG v(node) VAL=value RISE/FALL=occurrence
.measure tran delay_dff_in
+TRIG v(clk) VAL=0.9 RISE=1
+TARG v(a2) VAL=0.9 RISE=1

.measure tran delay_cla
+TRIG v(a2) VAL=0.9 RISE=1
+TARG v(s4) VAL=0.9 RISE=1

.measure tran delay_dff_out
+TRIG v(clk) VAL=0.9 RISE=2
+TARG v(s4_out) VAL=0.9 RISE=1

* .param: Calculate total from sum of other measurements
.measure tran total_delay param = (delay_dff_in + delay_cla + delay_dff_out)

.control
run
set color0 = black
set xbrushwidth = 3
set hcopypscolor=1
set curplottitle = "Saumya_2024102044_CLAADDER"

* plot: plot v(node1) offset+v(node2)
plot v(a0_in) 2+v(a1_in) 4+v(a2_in) 6+v(a3_in) 8+v(a4_in) 10+v(b0_in) 12+v(b1_in) 14+v(b2_in) 16+v(b3_in) 18+v(b4_in) 20+v(clk)
hardcopy adder_final_input_signals.ps v(a0_in) 2+v(a1_in) 4+v(a2_in) 6+v(a3_in) 8+v(a4_in) 10+v(b0_in) 12+v(b1_in) 14+v(b2_in) 16+v(b3_in) 18+v(b4_in) 20+v(clk)

plot v(s0) 2+v(s1) 4+v(s2) 6+v(s3) 8+v(s4) 10+v(c5) 12+v(clk)
hardcopy adder_final_sum_carry.ps v(s0) 2+v(s1) 4+v(s2) 6+v(s3) 8+v(s4) 10+v(c5) 12+v(clk)

plot v(g0) 2+v(g1) 4+v(g2) 6+v(g3) 8+v(g4) 10+v(clk)
hardcopy adder_final_generate_signals.ps v(g0) 2+v(g1) 4+v(g2) 6+v(g3) 8+v(g4) 10+v(clk)

plot v(p0) 2+v(p1) 4+v(p2) 6+v(p3) 8+v(p4) 10+v(clk)
hardcopy adder_final_propagate_signals.ps v(p0) 2+v(p1) 4+v(p2) 6+v(p3) 8+v(p4) 10+v(clk)

plot v(a0) 2+v(a1) 4+v(a2) 6+v(a3) 8+v(a4) 10+v(b0) 12+v(b1) 14+v(b2) 16+v(b3) 18+v(b4) 20+v(clk)
hardcopy adder_final_input_dff_outputs.ps v(a0) 2+v(a1) 4+v(a2) 6+v(a3) 8+v(a4) 10+v(b0) 12+v(b1) 14+v(b2) 16+v(b3) 18+v(b4) 20+v(clk)

plot v(s0_out) 2+v(s1_out) 4+v(s2_out) 6+v(s3_out) 8+v(s4_out) 10+v(c5_out) 12+v(clk)
hardcopy adder_final_output_dff_outputs.ps v(s0_out) 2+v(s1_out) 4+v(s2_out) 6+v(s3_out) 8+v(s4_out) 10+v(c5_out) 12+v(clk)
.endc
