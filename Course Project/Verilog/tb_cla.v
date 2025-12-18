module cla_5bit_tb;
    reg [4:0] a_in, b_in;
    reg cin, clk;
    wire [4:0] sum;
    wire cout;

    cla_5bit uut (.cout(cout),.sum(sum),.a_in(a_in),.b_in(b_in),.cin(cin),.clk(clk));

    initial begin
        clk = 0;
        forever #7 clk = ~clk;
    end

    initial begin
        $dumpfile("cla_adder.vcd");
        $dumpvars(0, cla_5bit_tb);

        a_in = 0;
        b_in = 0;
        cin = 0;
        #100;     
        
        @(posedge clk);
        a_in = 5'b00001;
        b_in = 5'b00001;
        #100;    
        
        @(posedge clk);
        a_in = 5'b01111;
        b_in = 5'b00001;
        #100;
        
        @(posedge clk);
        a_in = 5'b10101;
        b_in = 5'b01010;
        #100;
        
        @(posedge clk);
        a_in = 5'b10000;
        b_in = 5'b01111;
        #100;

        @(posedge clk);
        a_in = 5'b11111;
        b_in = 5'b11111;
        #100;
        
        #100;
        
        $finish;
    end

    initial begin
        $monitor("Time=%0t a_in=%b b_in=%b cin=%b sum=%b cout=%b",
                 $time, a_in, b_in, cin, sum, cout);
    end
endmodule