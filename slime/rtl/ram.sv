module Ram_1RW_1C #(
  parameter ADDR_BITS = 14,
  parameter DATA_BITS = 64
) (
  input clock,
  input en,
  input wr_en,
  input [ADDR_BITS-1:0] addr,
  input [DATA_BITS-1:0] data_in,
  output reg [DATA_BITS-1:0] data_out
);
  reg [DATA_BITS-1:0] mem [0:((1<<ADDR_BITS)-1)];

  always_ff @(posedge clock) begin
    if (en) begin
      if (wr_en) begin
        mem[addr] <= data_in;
        data_out <= data_in;
      end else begin
        data_out <= mem[addr];
      end
    end
  end
endmodule
