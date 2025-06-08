module Stage1_5_SpecialCase (
  input  wire        clk,
  input  wire        rst,

  // Inputs from Stage 1
  input  wire        sign_A,
  input  wire        sign_B_eff,
  input  wire [7:0]  exp_A,
  input  wire [7:0]  exp_B,
  input  wire [23:0] man_A,       // includes implicit leading bit
  input  wire [23:0] man_B,
  input  wire [7:0]  exp_diff,
  input  wire        A_is_bigger,
  input  wire        operation,   // for tie-breaking zeros

  // Bypass outputs
  output reg         bypass,        // ‘1’ if we’re shortcutting
  output reg  [31:0] bypass_result, // final IEEE-754 word

  // Otherwise pass through to Stage 2
  output reg         sign_A_out,
  output reg         sign_B_out,
  output reg  [7:0]  exp_A_out,
  output reg  [7:0]  exp_B_out,
  output reg  [23:0] man_A_out,
  output reg  [23:0] man_B_out,
  output reg  [7:0]  exp_diff_out,
  output reg         A_is_bigger_out
);

  // helper wires
  wire A_zero = (exp_A == 8'd0    && man_A[22:0] == 0);
  wire B_zero = (exp_B == 8'd0    && man_B[22:0] == 0);
  wire A_inf  = (exp_A == 8'hFF   && man_A[22:0] == 0);
  wire B_inf  = (exp_B == 8'hFF   && man_B[22:0] == 0);
  wire A_nan  = (exp_A == 8'hFF   && man_A[22:0] != 0);
  wire B_nan  = (exp_B == 8'hFF   && man_B[22:0] != 0);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      bypass         <= 1'b0;
      bypass_result  <= 32'd0;
      // clear pass-through regs
      {sign_A_out, sign_B_out, exp_A_out, exp_B_out, man_A_out, man_B_out, exp_diff_out, A_is_bigger_out}
                     <= 0;
    end else begin
      // Default: no bypass; propagate inputs
      bypass            <= 1'b0;
      sign_A_out        <= sign_A;
      sign_B_out        <= sign_B_eff;
      exp_A_out         <= exp_A;
      exp_B_out         <= exp_B;
      man_A_out         <= man_A;
      man_B_out         <= man_B;
      exp_diff_out      <= exp_diff;
      A_is_bigger_out   <= A_is_bigger;

      // 1) NaN rules: if either is NaN → quiet NaN
      if (A_nan || B_nan) begin
        bypass        <= 1'b1;
        // propagate the payload of the first NaN you see
        bypass_result <= A_nan ? {1'b0, 8'hFF, man_A[22:0]} 
                               : {1'b0, 8'hFF, man_B[22:0]};
      end
      // 2) Infinity rules
      else if (A_inf || B_inf) begin
        bypass       <= 1'b1;
        if (A_inf && B_inf) begin
          // ∞ - ∞ = NaN, ∞ + ∞ = sign_A ? -Inf : +Inf
          if (operation && (sign_A ^ sign_B_eff)) begin
            bypass_result <= 32'h7FC00000; // quiet NaN
          end else begin
            bypass_result <= { sign_A, 8'hFF, 23'd0 };
          end
        end else if (A_inf) begin
          bypass_result <= { sign_A, 8'hFF, 23'd0 };
        end else begin
          bypass_result <= { sign_B_eff, 8'hFF, 23'd0 };
        end
      end
      // 3) Zero rules
      else if (A_zero || B_zero) begin
        bypass       <= 1'b1;
        // A==0, B==0 → result signed-zero (sign = op? sign_A^1 : sign_A)
        if (A_zero && B_zero) begin
          bypass_result <= { (operation ? sign_A ^ 1 : sign_A), 8'd0, 23'd0 };
        end
        // one of them is zero → just return the other
        else if (A_zero) begin
          bypass_result <= { sign_B_eff, exp_B, man_B[22:0] };
        end else begin
          bypass_result <= { sign_A, exp_A, man_A[22:0] };
        end
      end
      // else: no special case → go down main path
    end
  end

endmodule
