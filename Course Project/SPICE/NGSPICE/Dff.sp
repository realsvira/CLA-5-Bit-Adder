**D-Flipflop - Tpcq Test
.include TSMC_180nm.txt
.param SUPPLY=1.8
.global gnd vdd
.param LAMBDA=0.09u
.param width_N=1.8u
.param width_P=2*width_N

.subckt INV in out vdd gnd
M_N out in gnd gnd CMOSN W={width_N} L={2*LAMBDA}
+ AS={5*width_N*LAMBDA} PS={10*LAMBDA+2*width_N} AD={5*width_N*LAMBDA} PD={10*LAMBDA+2*width_N}
M_P out in vdd vdd CMOSP W={width_P} L={2*LAMBDA}
+ AS={5*width_P*LAMBDA} PS={10*LAMBDA+2*width_P} AD={5*width_P*LAMBDA} PD={10*LAMBDA+2*width_P}
.ends INV

VDD vdd gnd 1.8
Vin in gnd PULSE(0 1.8 0 0.1n 0.1n 7.5n 15n)
Vclk clk gnd PULSE(0 1.8 2n 0.1n 0.1n 5n 10n)

M1N w12 in gnd gnd CMOSN W={width_N} L={LAMBDA}
+ AS={5*width_N*LAMBDA} PS={10*LAMBDA+2*width_N} AD={5*width_N*LAMBDA} PD={10*LAMBDA+2*width_N}
M2P w12 clk w23 vdd CMOSP W={width_P*2} L={LAMBDA}
+ AS={5*2*width_P*LAMBDA} PS={10*LAMBDA+2*2*width_P} AD={5*2*width_P*LAMBDA} PD={10*LAMBDA+2*2*width_P}
M3P w23 in vdd vdd CMOSP W={width_P*2} L={2*LAMBDA}
+ AS={5*2*width_P*LAMBDA} PS={10*LAMBDA+2*2*width_P} AD={5*2*width_P*LAMBDA} PD={10*LAMBDA+2*2*width_P}
M4N w45 clk gnd gnd CMOSN W={width_N*2} L={LAMBDA}
+ AS={5*2*width_N*LAMBDA} PS={10*LAMBDA+2*2*width_N} AD={5*2*width_N*LAMBDA} PD={10*LAMBDA+2*2*width_N}
M5N w56 w12 w45 gnd CMOSN W={width_N*2} L={LAMBDA}
+ AS={5*2*width_N*LAMBDA} PS={10*LAMBDA+2*2*width_N} AD={5*2*width_N*LAMBDA} PD={10*LAMBDA+2*2*width_N}
M6P w56 clk vdd vdd CMOSP W={width_P} L={LAMBDA}
+ AS={5*width_P*LAMBDA} PS={10*LAMBDA+2*width_P} AD={5*width_P*LAMBDA} PD={10*LAMBDA+2*width_P}
M7N w78 w56 gnd gnd CMOSN W={width_N*2} L={LAMBDA}
+ AS={5*2*width_N*LAMBDA} PS={10*LAMBDA+2*2*width_N} AD={5*2*width_N*LAMBDA} PD={10*LAMBDA+2*2*width_N}
M8N qn clk w78 gnd CMOSN W={width_N*2} L={LAMBDA}
+ AS={5*2*width_N*LAMBDA} PS={10*LAMBDA+2*2*width_N} AD={5*2*width_N*LAMBDA} PD={10*LAMBDA+2*2*width_N}
M9P qn w56 vdd vdd CMOSP W={width_P} L={2*LAMBDA}
+ AS={5*width_P*LAMBDA} PS={10*LAMBDA+2*width_P} AD={5*width_P*LAMBDA} PD={10*LAMBDA+2*width_P}
XINV1 qn q vdd gnd INV

.tran 0.1n 50n
.meas tran clk_50_rise WHEN v(clk)=0.9 RISE=3
.meas tran q_50_rise WHEN v(q)=0.9 RISE=2
.meas tran Tpcq_rise param='q_50_rise - clk_50_rise'
.meas tran clk_50_fall WHEN v(clk)=0.9 RISE=5
.meas tran q_50_fall WHEN v(q)=0.9 FALL=2
.meas tran Tpcq_fall param='q_50_fall - clk_50_fall'
.end