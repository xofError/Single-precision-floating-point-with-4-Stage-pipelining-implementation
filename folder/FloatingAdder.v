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
  wire same_sign = (A_sign == B_sign_eff);
  reg  [24:0] temp_result;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      sum_man  <= 0;
      sum_sign <= 0;
    end else begin
      if (same_sign) begin
        // Perform addition
        temp_result <= A_man_aligned + B_man_aligned;
        sum_sign <= A_sign;  // Both signs are the same
      end else begin
        // Perform subtraction: larger - smaller
        if (A_man_aligned >= B_man_aligned) begin
          temp_result <= A_man_aligned - B_man_aligned;
          sum_sign <= A_sign;  // A is larger → A's sign
        end else begin
          temp_result <= B_man_aligned - A_man_aligned;
          sum_sign <= B_sign_eff;  // B is larger → B's sign
        end
      end

      sum_man <= temp_result;
    end
  end
endmodule


