package AdderGenPkg;

typedef enum bit[1:0] {
  STATE_HALT = 2'b00
} state_t /*verilator public*/;

endpackage

import AdderGenPkg::*;

module AdderGen #(
  // Address bits in the sparse coordinate memory
  parameter CADDR_BITS = 16,
  parameter CDATA_BITS = 16,

  // Pattern bits
  parameter PDATA_BITS = 24
) (

  input clock,
  input reset,

  // Coordinate memory master
  // read address
  output                  crvalid,
  output [CADDR_BITS-1:0] craddr,
  input                   crready,

  // read response
  input                   cvalid,
  input  [CDATA_BITS-1:0] cdata,
  output                  cready,

  // Pattern output master
  // These can be used as addresses in main memory
  output                  pvalid,
  output [PDATA_BITS-1:0] pdata,
  input                   pready
);
  assign crvalid = 0;
  assign craddr = 0;
  assign cready = 0;
  assign pvalid = 0;
  assign pdata = 0;

  logic [1:0] state, next_state;

  // State machine update on clock edge
  always_ff @(posedge clock) begin
    if (reset) begin
      state <= STATE_HALT;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    unique case (state)
    STATE_HALT:
        next_state = STATE_HALT;
    default:
        next_state = STATE_HALT;
    endcase
  end

endmodule
