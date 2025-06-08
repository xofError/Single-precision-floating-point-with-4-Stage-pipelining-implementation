// ================================
// Stage1_Compare (updated)
// ================================
module Stage1_Compare (
  input  wire         clk,
  input  wire         rst,
  input  wire [31:0]  A,
  input  wire [31:0]  B,
  input  wire         operation,   // 0→add, 1→subtract

  output reg          A_sign,
  output reg          B_sign_eff,  // <-- effective B sign
  output reg  [7:0]   A_exp,
  output reg  [7:0]   B_exp,
  output reg  [23:0]  A_man,
  output reg  [23:0]  B_man,
  output reg  [7:0]   exp_diff,
  output reg          A_bigger
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      {A_sign,B_sign_eff,A_exp,B_exp,A_man,B_man,exp_diff,A_bigger} <= 0;
    end else begin
      // raw extraction
      A_sign <= A[31];
      B_sign_eff <= B[31] ^ operation;   // <-- XOR in the operation bit
      A_exp  <= A[30:23];
      B_exp  <= B[30:23];
      // build mantissas
      A_man  <= (A[30:23]==0) ? {1'b0, A[22:0]} : {1'b1, A[22:0]};
      B_man  <= (B[30:23]==0) ? {1'b0, B[22:0]} : {1'b1, B[22:0]};
      // exponent diff and bigger flag
      if (A[30:23] >= B[30:23]) begin
        exp_diff  <= A[30:23] - B[30:23];
        A_bigger  <= 1;
      end else begin
        exp_diff  <= B[30:23] - A[30:23];
        A_bigger  <= 0;
      end
    end
  end
endmodule
