import "DPI-C" function void tb_mem_init(bit [63:0] mem []);

module TBWrapper (
  input clock,
  input resetn
);
  localparam integer RAM_ADDR_BITS = 17;
  localparam integer RAM_DATA_BITS = 64;
  localparam integer RAM_STRB_BITS = RAM_DATA_BITS / 8;

  wire ram_axi_arready, ram_axi_arvalid;
  wire [RAM_ADDR_BITS-1:0] ram_axi_araddr;

  wire ram_axi_rready, ram_axi_rvalid;
  wire [RAM_DATA_BITS-1:0] ram_axi_rdata;

  wire ram_axi_awvalid;
  reg  ram_axi_awready = 0;
  reg [RAM_ADDR_BITS-1:0] ram_axi_awaddr;

  reg  ram_axi_wready = 0;
  wire ram_axi_wvalid;
  wire [RAM_DATA_BITS-1:0] ram_axi_wdata;
  wire [RAM_STRB_BITS-1:0] ram_axi_wstrb;

  wire ram_axi_bvalid;
  reg  ram_axi_bready = 0;
  wire [1:0] ram_axi_bresp;

  AdderGen #(
    .ADDR_BITS(RAM_ADDR_BITS),
    .DATA_BITS(RAM_DATA_BITS)
  ) addergen (
    .clock(clock),
    .resetn(resetn),

    .axi_arready(ram_axi_arready),
    .axi_arvalid(ram_axi_arvalid),
    .axi_araddr(ram_axi_araddr),

    .axi_rready(ram_axi_rready),
    .axi_rvalid(ram_axi_rvalid),
    .axi_rdata(ram_axi_rdata)
  );

  AXI_Ram #(
    .ADDR_BITS(RAM_ADDR_BITS),
    .DATA_BITS(RAM_DATA_BITS),
  ) ram (
    .clock(clock),
    .resetn(resetn),

    .axi_arready(ram_axi_arready),
    .axi_arvalid(ram_axi_arvalid),
    .axi_araddr(ram_axi_araddr),

    .axi_rready(ram_axi_rready),
    .axi_rvalid(ram_axi_rvalid),
    .axi_rdata(ram_axi_rdata),

    .axi_awvalid(ram_axi_awvalid),
    .axi_awready(ram_axi_awready),
    .axi_awaddr(ram_axi_awaddr),

    .axi_wvalid(ram_axi_wvalid),
    .axi_wready(ram_axi_wready),
    .axi_wdata(ram_axi_wdata),
    .axi_wstrb(ram_axi_wstrb),

    .axi_bvalid(ram_axi_bvalid),
    .axi_bready(ram_axi_bready),
    .axi_bresp(ram_axi_bresp)
  );

  initial begin
    tb_mem_init(ram.mem);
  end

  integer cycle = 0;
  always_ff @(posedge clock) begin
    cycle <= cycle + 1;
  end

  /* Spy on the RAM reads */
  integer read_count = 0;
  always_ff @(posedge clock) begin
    if (ram_axi_arready && ram_axi_arvalid) begin
      $display("AREAD @ %d: ", cycle, ram_axi_araddr);
    end
    if (ram_axi_rready && ram_axi_rvalid) begin
      $display("READ  @ %d: ", cycle, ram_axi_rdata);
      read_count = read_count + 1;
    end
  end

  always begin
    if (read_count == 10) begin
      $finish;
    end
  end
endmodule
