module PipelinedFAdd (
  input  wire        clk,
  input  wire        rst,
  input  wire [31:0] A,
  input  wire [31:0] B,
  input  wire        operation,

  output wire [31:0] result
);

  // Stage 1 outputs
  wire        A_sign1, B_sign1_eff, A_bigger1;
  wire [7:0]  A_exp1, B_exp1, diff1;
  wire [23:0] A_man1, B_man1;

  Stage1_Compare U1 (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .operation(operation),
    .A_sign(A_sign1),
    .B_sign_eff(B_sign1_eff),
    .A_exp(A_exp1),
    .B_exp(B_exp1),
    .A_man(A_man1),
    .B_man(B_man1),
    .exp_diff(diff1),
    .A_bigger(A_bigger1)
  );

  // Stage 1.5 (Special Case Handler)
  wire        bypass_1_5;
  wire [31:0] bypass_res;
  wire        sA2, sB2, A_big2;
  wire [7:0]  eA2, eB2, diff2;
  wire [23:0] mA2, mB2;

  Stage1_5_SpecialCase U1_5 (
    .clk(clk),
    .rst(rst),
    .sign_A(A_sign1),
    .sign_B_eff(B_sign1_eff),
    .exp_A(A_exp1),
    .exp_B(B_exp1),
    .man_A(A_man1),
    .man_B(B_man1),
    .exp_diff(diff1),
    .A_is_bigger(A_bigger1),
    .operation(operation),
    .bypass(bypass_1_5),
    .bypass_result(bypass_res),
    .sign_A_out(sA2),
    .sign_B_out(sB2),
    .exp_A_out(eA2),
    .exp_B_out(eB2),
    .man_A_out(mA2),
    .man_B_out(mB2),
    .exp_diff_out(diff2),
    .A_is_bigger_out(A_big2)
  );

  // Stage 2: Align Mantissas
  wire [23:0] A_man2, B_man2;
  wire [7:0]  exp2;

  Stage2_Align U2 (
    .clk(clk),
    .rst(rst),
    .A_man(mA2),
    .B_man(mB2),
    .exp_diff(diff2),
    .A_bigger(A_big2),
    .A_exp(eA2),
    .B_exp(eB2),
    .A_man_aligned(A_man2),
    .B_man_aligned(B_man2),
    .exp_out(exp2)
  );

  // Stage 3: Add/Subtract
  wire [24:0] sum3;
  wire        sum_sign3;

  Stage3_Adder U3 (
    .clk(clk),
    .rst(rst),
    .A_man_aligned(A_man2),
    .B_man_aligned(B_man2),
    .A_sign(sA2),
    .B_sign_eff(sB2),
    .sum_man(sum3),
    .sum_sign(sum_sign3)
  );

  // Stage 4: Normalize
  wire [31:0] result_stage4;

  Stage4_Normalize U4 (
    .clk(clk),
    .rst(rst),
    .sum_man(sum3),
    .exp_in(exp2),
    .sum_sign(sum_sign3),
    .result(result_stage4)
  );

  // Final result logic: check bypass
  assign result = bypass_1_5 ? bypass_res : result_stage4;

endmodule

