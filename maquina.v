module maquina(
  input  CLK,
  input  RESET,
  input  MDIO_START,
  input  MDIO_IN,
  input  [31:0] T_DATA,
  output reg [15:0] RD_DATA,
  output reg DATA_RDY, MDIO_OE,
  output reg MDC,
  output reg MDIO_OUT
);
 reg [5:0] cnt; // Esto es como el clk divider.

 always @(posedge CLK) begin
    if (~RESET) begin             
      MDC <= 1'b0;
    end
    MDC <= !MDC;

  end
/*
La idea de este flanco positivo para MDIO_START es que se reinicie-
la señal DATA_RDY
*/
always @(posedge MDIO_START) begin  
    cnt <= 31;
    DATA_RDY <= 1'b0;
  end

/*
 Cuando RESET es igual a 0, entonces todas la salidas serán 0.
*/
always @(posedge MDC) begin
//
    if (~RESET) begin           
// Comportamiento por defecto de la lógica.
        cnt <= 31;                  // Ahora el parámetro cnt es de 32 bits. Será útil para la escritura paralelo-serie.
        DATA_RDY <= 1'b0;
        MDIO_OE <= 1'b0;
        MDIO_OUT <= 1'b0;
        RD_DATA[15:0] <= 1'b0;
        MDC <= 1'b0;
    end
/*
Se le va a asignar a MDIO_START un valor de 1, esto hace que se pueda habilitar
MDIO_OUT. Se va a iniciar con la escritura.
*/
  else begin if (MDIO_START)begin 
/*
Al estar MDIO_START en 1 entonces se le pasan a MDIO_OUT los bits que están en
T_DATA, desde el MSB-LSB, y como cnt <= 31, entonces se realiza la siguiente-
asignación no bloqueante.
*/ 
  if(cnt >=0)begin
    
    MDIO_OUT <= T_DATA[cnt];   // Esto es la operación de paralelo a serie. 
    if(cnt != 0) begin         // Si cnt es distinto de 0, entonces se le va quitando 1 para completar los 32 bits.
      cnt <= cnt -1;          // Una vez que termine esto MDIO_OUT se pondrá en alto.
    end
/*
Al preguntar si T_DATA[] == 2'b10, se indica que esto se trata de lectura, tal como
viene en la cláusula.
*/
    if(T_DATA[29:28] == 2'b10 && cnt >15)begin   // Al ser lectura, entonces la señal MDIO_OE tiene que estar ON los primeros flacos positivos. 
          MDIO_OE <= 1'b1;

    end
/*
Cuando se trata de escritura la señal MDIO_OE debe estar en alto.
*/
    else if(T_DATA[29:28] == 2'b01)begin
      MDIO_OE <= 1'b1;
    end
/*
Al final se pone en 0.
*/
    else begin
      MDIO_OE <= 1'b0;
    end

/*
 Entrada seria, cuando cnt tenga los 16 bits correspondientes y la señal DATA_RDY no sea 1-
entonces según la claúsula 22 del estándar MDIO_IN va a escribir en RD_DATA.
en ese sentido al concatenarlos se logra lo que dice la claúsula. 
Pero este valor aún no es válido ya que la señal DATA_RDY no es 1, entonces- 
cuando es cnt se acaba es cuando dicha señal va a habilitar el valor de RD_DATA. Y
así con el cnt 0, entonces DATA_RDY estará en ON.
*/
  if(T_DATA[29:28] == 2'b10) begin
    if(~MDIO_OE)begin
      if(cnt <= 15 && DATA_RDY!=1'b1)begin   
        RD_DATA[15:0] <= {RD_DATA[14:0], MDIO_IN};
      end 
      if(cnt==0)begin                          // Si cnt=0 implica que DATA_RDY es 1. 
        DATA_RDY <= 1;  
      end 
    end           
  end
// Aquí se pone en 0 justo después de la lectura. De lo contrario, esta señal se mantendrá en alto en toda la transacción.
      if(cnt==0)begin 
        MDIO_OE <=1'b0;                      
      end     
    end
  end  
end    
end 

endmodule
