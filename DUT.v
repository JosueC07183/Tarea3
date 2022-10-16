`include "maquina.v"

module DUT(
  input wire CLK, 
  input wire RESET,
  input wire MDIO_START,
  input wire MDIO_IN,
  input wire [31:0] T_DATA,
  output wire [15:0] RD_DATA,
  output wire DATA_RDY, 
  output wire MDC,
  output wire MDIO_OE,
  output wire MDIO_OUT
);

 maquina trans_1(
    .CLK(CLK), 
    .MDC(MDC), 
    .RESET(RESET), 
    .MDIO_START(MDIO_START), 
    .MDIO_OUT(MDIO_OUT),
    .MDIO_OE(MDIO_OE), 
    .MDIO_IN(MDIO_IN), 
    .T_DATA(T_DATA), 
    .RD_DATA(RD_DATA), 
    .DATA_RDY(DATA_RDY)
    );

endmodule
