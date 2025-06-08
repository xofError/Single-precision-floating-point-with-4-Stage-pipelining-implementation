module PipelinedFAdd (
  input  wire        clk,
  input  wire        rst,
  input  wire [31:0] A,
  input  wire [31:0] B,
  input  wire        operation,  // not used until Stage 3 if you prefer, but we embedded sign logic there

  output wire [31:0] result
);
  // Stage 1
  wire        A_sign1, B_sign1, A_bigger1;
  wire [7:0]  A_exp1, B_exp1, diff1;
  wire [23:0] A_man1, B_man1;
Stage1_Compare U1 (
  .clk(clk), .rst(rst),
  .A(A), .B(B), .operation(operation),
  .A_sign(A_sign1), .B_sign_eff(B_sign1_eff),
  .A_exp(A_exp1), .B_exp(B_exp1),
  .A_man(A_man1), .B_man(B_man1),
  .exp_diff(diff1), .A_bigger(A_bigger1)
);

  // Stage 2
  wire [23:0] A_man2, B_man2;
  wire [7:0]  exp2;
  Stage2_Align   U2(clk,rst, A_man1,B_man1,diff1,A_bigger1,A_exp1,B_exp1, A_man2,B_man2,exp2);

  // Stage 3
  wire [24:0] sum3;
  wire        sum_sign3;
Stage3_Adder U3 (
  .clk(clk), .rst(rst),
  .A_man_aligned(A_man2), .B_man_aligned(B_man2),
  .A_sign(A_sign1), .B_sign_eff(B_sign1_eff),
  .sum_man(sum3), .sum_sign(sum_sign3)
);
  // Stage 4
  Stage4_Normalize U4(clk,rst, sum3,exp2,sum_sign3, result);

endmodule
