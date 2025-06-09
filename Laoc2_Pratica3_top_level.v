module Laoc2_Pratica3_top_level(
    input  [17:0] SW,     // SW17 = Run, SW15–0 = DIN
    input  [3:0]  KEY,    // KEY0 = Resetn, KEY1 = Clock
    output [7:0] LEDG,     // LEDRG
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, // Saídas para displays de 7 segmentos
    output [17:0] LEDR    // LEDR15–0 = BusWires, LEDR17 = Done
  );
  // EH POSSIVEL QUE DE PROBLEMA NA PLACA POR CAUSA DO TOP LEVEL! 
  
  wire Clock;
  wire Resetn;
  wire [15:0] BusWires;
  wire [15:0] ContaInstrucao;
  wire Done;
  wire Run;
  wire [2:0] Tstep;
  wire [15:0] R0out, R1out, R2out, R3out;
  wire [9:0] IRout;             
  wire [15:0] Wire_ContaInstrucao;


  // Componentes Do processador
  wire [15:0] Rx_data;
  wire [15:0] Ry_data;


  // Mapeia as saídas para os LEDs
  assign LEDR[15:0] = BusWires;
  assign LEDR[17]   = Run;
  assign Run        = SW[17]; // SW17 indica o início da execução
  assign LEDG[2]    = Done;   // LEDG0 indica se a instrução foi concluída
  assign LEDG[1]    = Resetn;  // LEDG0 indica se a instrução foi concluída
  assign Resetn      = SW[16]; // Reset ativo em nível baixo
  // assign Clock      = SW[15]; // Reset ativo em nível baixo
  assign Clock      = !KEY[3];
  assign LEDG[7]    = Clock;
  

/* 
comandos para o quartus rodar na placa
cd ~/quartus/bin; ./quartus --64bit
lsusb
sudo chmod 666 /dev/bus/usb/001/010
*/


endmodule