module cla_5bit(
    output cout,
    output reg [4:0] sum,
    input [4:0] a_in, b_in,
    input cin, clk
);
    reg [4:0] a, b;
    wire [4:0] sum_comb;

    always @(posedge clk) begin
        a <= a_in;
        b <= b_in;
    end 

    wire p4, p3, p2, p1, p0;
    wire g4, g3, g2, g1, g0;
    
    and (g4, a[4], b[4]);
    and (g3, a[3], b[3]);
    and (g2, a[2], b[2]);
    and (g1, a[1], b[1]);
    and (g0, a[0], b[0]);

    xor (p4, a[4], b[4]);
    xor (p3, a[3], b[3]);
    xor (p2, a[2], b[2]);
    xor (p1, a[1], b[1]);
    xor (p0, a[0], b[0]);

    wire c0, c1, c2, c3, c4;
    wire p0_and_cin, p1_and_g0, p1_p0_and_cin;
    wire p2_and_g1, p2_p1_and_g0, p2_p1_p0_and_cin;
    wire p3_and_g2, p3_p2_and_g1, p3_p2_p1_and_g0, p3_p2_p1_p0_and_cin;
    wire p4_and_g3, p4_p3_and_g2, p4_p3_p2_and_g1, p4_p3_p2_p1_and_g0, p4_p3_p2_p1_p0_and_cin;

    // C0 calculation
    and (p0_and_cin, p0, cin);
    or  (c0, g0, p0_and_cin);

    // C1 calculation
    and (p1_and_g0, p1, g0);
    and (p1_p0_and_cin, p1, p0, cin);
    or  (c1, g1, p1_and_g0, p1_p0_and_cin);

    // C2 calculation
    and (p2_and_g1, p2, g1);
    and (p2_p1_and_g0, p2, p1, g0);
    and (p2_p1_p0_and_cin, p2, p1, p0, cin);
    or  (c2, g2, p2_and_g1, p2_p1_and_g0, p2_p1_p0_and_cin);

    and (p3_and_g2, p3, g2);
    and (p3_p2_and_g1, p3, p2, g1);
    and (p3_p2_p1_and_g0, p3, p2, p1, g0);
    and (p3_p2_p1_p0_and_cin, p3, p2, p1, p0, cin);
    or  (c3, g3, p3_and_g2, p3_p2_and_g1, p3_p2_p1_and_g0, p3_p2_p1_p0_and_cin);

    and (p4_and_g3, p4, g3);
    and (p4_p3_and_g2, p4, p3, g2);
    and (p4_p3_p2_and_g1, p4, p3, p2, g1);
    and (p4_p3_p2_p1_and_g0, p4, p3, p2, p1, g0);
    and (p4_p3_p2_p1_p0_and_cin, p4, p3, p2, p1, p0, cin);
    or  (c4, g4, p4_and_g3, p4_p3_and_g2, p4_p3_p2_and_g1, p4_p3_p2_p1_and_g0, p4_p3_p2_p1_p0_and_cin);

    // C5 calculation (cout)
    and (p4_and_g3, p4, g3);
    and (p4_p3_and_g2, p4, p3, g2);
    and (p4_p3_p2_and_g1, p4, p3, p2, g1);
    and (p4_p3_p2_p1_and_g0, p4, p3, p2, p1, g0);
    and (p4_p3_p2_p1_p0_and_cin, p4, p3, p2, p1, p0, cin);
    or  (cout, g4, p4_and_g3, p4_p3_and_g2, p4_p3_p2_and_g1, p4_p3_p2_p1_and_g0, p4_p3_p2_p1_p0_and_cin);

    // Sum calculation
    xor (sum_comb[0], p0, cin);
    xor (sum_comb[1], p1, c0);
    xor (sum_comb[2], p2, c1);
    xor (sum_comb[3], p3, c2);
    xor (sum_comb[4], p4, c3);

    //DFF for outputs
    always @(posedge clk) begin
        sum <= sum_comb;
    end
endmodule