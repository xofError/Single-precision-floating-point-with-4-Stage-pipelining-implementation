// ================================
// Stage3_Adder (updated to take B_sign_eff)
// ================================
module Stage3_Adder (
  input  wire        clk,
  input  wire        rst,
  input  wire [23:0] A_man_aligned,
  input  wire [23:0] B_man_aligned,
  input  wire        A_sign,
  input  wire        B_sign_eff,   // <-- now using the effective B sign

  output reg  [24:0] sum_man,
  output reg         sum_sign
);
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      {sum_man, sum_sign} <= 0;
    end else begin
      if (A_sign == B_sign_eff) begin
        // same effective sign → add
        sum_man  <= {1'b0, A_man_aligned} + {1'b0, B_man_aligned};
        sum_sign <= A_sign;
      end else begin
        // different effective signs → subtract
        if ({1'b0,A_man_aligned} >= {1'b0,B_man_aligned}) begin
          sum_man  <= {1'b0, A_man_aligned} - {1'b0, B_man_aligned};
          sum_sign <= A_sign;
        end else begin
          sum_man  <= {1'b0, B_man_aligned} - {1'b0, A_man_aligned};
          sum_sign <= B_sign_eff;
        end
      end
    end
  end
endmodule

