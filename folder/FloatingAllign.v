module Stage2_Align (
  input  wire        clk,
  input  wire        rst,
  input  wire [23:0] A_man,
  input  wire [23:0] B_man,
  input  wire [7:0]  exp_diff,
  input  wire        A_bigger,
  input  wire [7:0]  A_exp,
  input  wire [7:0]  B_exp,

  output reg  [23:0] A_man_aligned,
  output reg  [23:0] B_man_aligned,
  output reg  [7:0]  exp_out
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      {A_man_aligned,B_man_aligned,exp_out} <= 0;
    end else if (A_bigger) begin
      A_man_aligned <= A_man;
      B_man_aligned <= B_man >> exp_diff;
      exp_out       <= A_exp;
    end else begin
      A_man_aligned <= A_man >> exp_diff;
      B_man_aligned <= B_man;
      exp_out       <= B_exp;
    end
  end
endmodule
