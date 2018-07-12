typedef enum bit[1:0] {
  STATE_HALT = 2'b00
} state_t /*verilator public*/;

module AdderGen #(
  // Index memory
  parameter IDX_ADDR_BITS = 16,
  parameter IDX_DATA_BITS = 16,

  // Data memory
  parameter ADDR_BITS = 17,
  parameter DATA_BITS = 64,
  parameter STRB_BITS = DATA_BITS / 8
) (
  input clock,
  input resetn,

  // Data - AXI Read master
  input  axi_arready,
  output axi_arvalid,
  output [ADDR_BITS-1:0] axi_araddr,

  output axi_rready,
  input  axi_rvalid,
  input  [DATA_BITS-1:0] axi_rdata
);
  localparam integer IDX_BITS = ADDR_BITS;

  // Read each address in sequence
  reg [IDX_BITS-1:0] idx;
  always_ff @(posedge clock) begin
    if (!resetn) begin
      idx <= {IDX_BITS{1'b0}};
    end else begin
      axi_arvalid <= 1'b1;

      // On arready, increment the count
      if (axi_arready) begin
        idx <= idx + 1;
      end
    end
  end

  assign axi_araddr = idx;
  assign axi_rready = 1'b1;
endmodule
