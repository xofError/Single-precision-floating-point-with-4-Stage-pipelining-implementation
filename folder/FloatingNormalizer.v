module Stage4_Normalize (
  input  wire        clk,
  input  wire        rst,
  input  wire [24:0] sum_man, // 23 bits for mantisa 1 bit for overflow, 1 bit for sign 
  input  wire [7:0]  exp_in, // the common exponent before normalization. 8 bits
  input  wire        sum_sign,

  output reg  [31:0] result
);
  // leading-zero count

  
  reg [7:0]  exp_adj; // Adjusted exponent after normalization
  reg [23:0] norm_man;// Normalized mantissa with implicit leading 1
  reg [4:0]  shift; // Number of left shifts needed (0–23)


  // Purpose: Count how many zeros precede the first ‘1’ in the 24-bit vector val.
  // Starts at the MSB (i=23) and works down to LSB (i=0).
  /* 
    Example: val=0000_0000_0000_0000_0000_1011 → returns 20
    That means you must shift left by 20 to bring that ‘1’ into bit‐23.
  */
  function integer leading_zeros;
    input [23:0] val;
    integer i;
    begin
      leading_zeros = 0;
      for (i = 23; i >= 0; i = i - 1) begin
        if (val[i] == 1'b1) begin
          leading_zeros = 23 - i;
          i = -1; // exit loop manually
        end
      end
    end
  endfunction

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      result <= 0;
    end else begin
      if (sum_man[24]) begin
        // overflow from addition
        exp_adj   = exp_in + 1;
        norm_man  = sum_man[24:1]; // shift right by 1 , can be replaced by wire assignment norm_man >> 1
      end else begin
        /*
        If no overflow, we may have a result like 0.01101... (bit 23 = 0).
          Compute shift = leading_zeros(sum_man[23:0]).
          Adjust exponent: exp_adj = exp_in − shift.
          Left-shift mantissa by shift to bring first ‘1’ into bit 23.
        */
        shift     = leading_zeros(sum_man[23:0]);
        exp_adj   = exp_in - shift;
        norm_man  = sum_man[23:0] << shift;
      end
      result <= { sum_sign, exp_adj, norm_man[22:0] };
    end
  end
endmodule
