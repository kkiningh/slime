module AXI_Ram #(
  parameter ADDR_BITS = 17,
  parameter DATA_BITS = 64,
  parameter STRB_BITS = DATA_BITS / 8
) (
  input clock,
  input resetn,

  // Read address
  output reg                axi_arready,
  input                     axi_arvalid,
  input [ADDR_BITS-1:0]     axi_araddr,

  // Read data
  input                     axi_rready,
  output                    axi_rvalid,
  output [DATA_BITS-1:0]    axi_rdata,

  // Write address
  output reg                axi_awvalid,
  input                     axi_awready,
  input [ADDR_BITS-1:0]     axi_awaddr,

  // Write data
  output                    axi_wready,
  input                     axi_wvalid,
  input [DATA_BITS-1:0]     axi_wdata,
  input [STRB_BITS-1:0]     axi_wstrb,

  // Write response
  output                    axi_bvalid,
  input                     axi_bready,
  output [1:0]              axi_bresp
);
  reg [DATA_BITS-1:0] mem [0:((1<<ADDR_BITS)-1)] /* verilator public */;

  // Disable write interface;
  assign axi_awvalid = 0;
  assign axi_wready = 0;
  assign axi_bvalid = 0;
  assign axi_bresp = 0;

  reg [ADDR_BITS-1:0] araddr;
  reg arvalid;
  reg [DATA_BITS-1:0] rdata;
  reg rvalid;
  always_ff @(posedge clock) begin
    if (!resetn) begin
      axi_arready <= 1'b0;
      arvalid     <= 1'b0;
      araddr      <= {ADDR_BITS{1'b0}};
      rvalid      <= 1'b0;
      rdata       <= {DATA_BITS{1'b0}};
    end else begin
      axi_arready <= 1'b0;
      axi_rvalid  <= 1'b0;
      axi_rdata   <= {DATA_BITS{1'bX}};

      // Transfer read address from AXI bus
      if (!arvalid && axi_arvalid) begin
        axi_arready <= 1'b1;
        arvalid     <= 1'b1;
        araddr      <= axi_araddr;
      end

      // Read address from mem and latch output
      if (arvalid && !rvalid) begin
        rvalid <= 1'b1;
        rdata  <= mem[araddr];
      end

      // Transfer read data to AXI bus
      if (rvalid && axi_rready) begin
        axi_rvalid <= 1'b1;
        axi_rdata  <= rdata;
        rvalid     <= 1'b0;
      end
    end
  end
endmodule
