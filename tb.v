`include "tester.v"
`include "maquina.v"

module tb();
// Aquí todas las señales son cables.
   wire CLK, RESET, MDIO_START, MDIO_IN;
    wire [31:0] T_DATA;
    // Salidas
    wire [15:0] RD_DATA;
    wire DATA_RDY, MDC, MDIO_OE, MDIO_OUT;

// Ahora se realizan las instancias
    initial
    begin
        $dumpfile("clause22.vcd");
        $dumpvars(1, tb);
    end
     maquina DUT(
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

    tester probador(
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
endmodule // Fin
