module Stage4_Normalize (
  input  wire        clk,
  input  wire        rst,
  input  wire [24:0] sum_man,
  input  wire [7:0]  exp_in,
  input  wire        sum_sign,

  output reg  [31:0] result
);
  // leading-zero count
  function [4:0] lzc(input [23:0] v);
    integer i;
    begin
      lzc = 0;
      for (i=23; i>=0; i=i-1) begin
        if (v[i]) begin
          lzc = lzc;
        end else begin
          lzc = lzc + 1;
        end
      end
    end
  endfunction

  reg [7:0]  exp_adj;
  reg [23:0] norm_man;
  reg [4:0]  shift;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      result <= 0;
    end else begin
      if (sum_man[24]) begin
        // overflow from addition
        exp_adj   = exp_in + 1;
        norm_man  = sum_man[24:1];
      end else begin
        shift     = lzc(sum_man[23:0]);
        exp_adj   = exp_in - shift;
        norm_man  = sum_man[23:0] << shift;
      end
      result <= { sum_sign, exp_adj, norm_man[22:0] };
    end
  end
endmodule
