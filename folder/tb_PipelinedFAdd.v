`timescale 1ns/1ps

module tb_PipelinedFAdd();

    reg clk = 0;
    reg reset = 1;
    reg [31:0] A, B;
    reg operation; // 0: Add, 1: Sub

    wire [31:0] result;

    PipelinedFAdd dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .operation(operation),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk;

        initial begin

            $monitor("Time: %0t | A: %h | B: %h | Op: %b | Result: %h", $time, A, B, operation, result);
            $dumpfile("build/waveform.vcd");
            $dumpvars(0, tb_PipelinedFAdd);
            

        #10 reset = 0;

        // // Test 1: 13.65 + 10.2555 = 23.9055
        // A = 32'h415a6666; // 13.65
        // B = 32'h41241687; // 10.2555
        // operation = 0;
        // #50;

        // // Test 2: 13.65 - 10.2555 = 3.3945
        // A = 32'h415a6666; // 13.65
        // B = 32'h41241687; // 10.2555
        // operation = 1;
        // #50;
        // //Test 3: -13.65 + 10.2555 = -3.3945
        // A = 32'hc15a6666; // -13.65
        // B = 32'h41241687; // 10.2555
        // operation = 0;
        // #50;
        // // Test 4: -13.65 - 10.2555 = -23.9055
        // A = 32'hc15a6666; // -13.65
        // B = 32'h41241687; // 10.2555
        // operation = 1;
        // #50;

        A = 32'h7F800000;
        B = 32'hFF800000;
        operation = 0;
        #50;

        $finish;
    end

endmodule
