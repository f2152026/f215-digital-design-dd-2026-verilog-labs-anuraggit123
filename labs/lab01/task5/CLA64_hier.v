module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [16:0] c;

  genvar i;

  // Generate and propagate
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // Carry into bit 0
  assign #(2) c[0] = cin;

  // Carry calculation for every bit
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_carry
      assign #(2) c[i+1] =
          g[4*i+3] |
          (p[4*i+3] & g[4*i+2]) |
          (p[4*i+3] & p[4*i+2] & g[4*i+1]) |
          (p[4*i+3] & p[4*i+2] & p[4*i+1] & g[4*i]) |
          (p[4*i+3] & p[4*i+2] & p[4*i+1] & p[4*i] & c[i]);
    end
  endgenerate

  // 16 four-bit CLA blocks
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_cla
      cla4 FA (
        .a(a[4*i+3:4*i]),
        .b(b[4*i+3:4*i]),
        .cin(c[i]),
        .sum(sum[4*i+3:4*i]),
        .cout()
      );
    end
  endgenerate

  assign #(2) cout = c[16];

endmodule