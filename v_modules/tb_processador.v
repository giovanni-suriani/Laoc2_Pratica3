`timescale 1ps/1ps

module tb_processador;

  reg [15:0] DIN;
  reg [2:0] Opcode;          // Opcode III
  reg [5:3] Rx;              // Rx (destino/target)
  reg [8:6] Ry;              // Ry (fonte/source)
  wire [8:0] Instrucao; // Instrução completa
  reg Clock, Resetn, Run;
  wire Done;
  wire [2:0] Tstep; // Sinal de Tstep
  wire [15:0] BusWires;
  // wire [15:0] Rx_data, Ry_data; // Dados dos registradores Rx e Ry
  wire [15:0] ContaInstrucao;
  wire [15:0] R0out, R1out, R2out, R3out, R4out; // Dados dos registradores Rx e Ry

  // Instancia o processador

  processador_multiciclo uut (
                           .Resetn   (Resetn   ),
                           .Clock    (Clock    ),
                           .Run      (Run      ),
                           .Done     (Done     ),
                           .BusWires (BusWires ),
                           .Tstep    (Tstep    ),
                           .R0out               (R0out               ),
                           .R1out               (R1out               ),
                           .R2out               (R2out               ),
                           .R3out               (R3out               ),
                           .Wire_ContaInstrucao (ContaInstrucao )
                         );


  assign Instrucao = uut.Instrucao; // Instrução completa
  // Clock gerado a cada 50ps


  integer detalhado = 1;
  integer mostra_registradores = 1;

  always #50 Clock = ~Clock;


  integer mostra_teste1  = 1;
  integer mostra_teste2  = 1;
  integer mostra_teste3  = 1;
  integer mostra_teste4  = 1;
  integer mostra_teste5  = 1;
  integer mostra_teste6  = 1;
  integer mostra_teste7  = 1;
  integer mostra_teste8  = 1;
  integer mostra_teste9  = 1;
  integer mostra_teste10 = 1;
  integer mostra_teste11 = 1;
  integer mostra_teste12 = 1;
  integer mostra_teste13 = 1;
  integer mostra_teste14 = 1;
  integer mostra_teste15 = 0;

  initial
    begin
      // Inicialização
      Clock = 0;
      Resetn = 1;
      Run = 0;
      DIN = 16'b0;
      // Reset do processador

      // ------------------------------
      // T0 - Resetn dos registradores e sinais
      // ------------------------------
      // @(posedge Clock);
      // #1;
      @(posedge Clock);
      #1;
      $display("[%0t] Teste Resetn (mux, registradores, e outros sinais)",$time);
      $display("[%0t] BusWires = %0d, DIN = %0d, Tstep = %0d",$time, BusWires, uut.DIN, uut.Tstep);
      $display("[%0t] R1 = %0d R2 = %0d, .. R6 = %0d R7 = %0b",$time, uut.R1.Q, uut.R2.Q, uut.R6.Q, uut.R7.Q);
      $display("[%0t] IncrPc=%0d W_D=%0d ADDRin=%0d DOUTin=%0d",
               $time, uut.IncrPc, uut.W_D, uut.ADDRin, uut.DOUTin);
      $display("[%0t] Run=%0d Resetn=%0d Clear=%0d GRout=%0d",
               $time, uut.Run, uut.Resetn, uut.Clear, uut.GRout);
      $display("[%0t] IRin=%0d Rin=%b Rout=%b Ain=%0d",
               $time, uut.IRin, uut.Rin, uut.Rout, uut.Ain);
      $display("[%0t] Gin=%0d Gout=%0d Ulaop=%b DINout=%h",
               $time, uut.Gin, uut.Gout, uut.Ulaop, uut.DINout);
      $display("[%0t] Memout=%0d ADDRout=%0d ADDRout=%0d",
               $time, uut.Memout, uut.ADDRout, uut.DOUTin, uut.ADDRout);
      $display("[%0t] W_D DOUTin=%b, DOUTout=%0d",
               $time, uut.W_D, uut.DOUTin, uut.DOUTout);
      $display("[%0t] Done=%0d",
               $time, uut.Done);
      $display("[%0t] Teste 0 Finalizado",$time);
      $display("--------------------------------------------------");


      Run = 1; // Ativa o Run
      Resetn = 0; // Desativa o reset

      // -----------------------------
      // T1 - mvi r0, #2
      // -----------------------------
      if (mostra_teste1)
        begin
          $display("[%0t] Teste 1 instrucao mvi R0, #2, R0 inicial = %0d", $time, uut.R0.Q);
          @(posedge Clock);
          #351;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R0 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R0.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0001000000, R0 = 2 Tstep = 4",$time);
          $display("[%0t] Teste mvi r0, #2 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T2 - mvi R1, #3
      // -----------------------------
      if (mostra_teste2)
        begin
          $display("[%0t] Teste 2 instrucao mvi R1, #3, R1 inicial = %0d", $time, uut.R1.Q);
          @(posedge Clock);
          #451;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0001001000, R1 = 3 Tstep = 4",$time);
          $display("[%0t] Teste mvi r1, #3 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T3 - LD R2, R1
      // -----------------------------
      if (mostra_teste3)
        begin
          $display("[%0t] Teste 3 instrucao LD R2, R1, R2 inicial = %0d R1 inicial = %0d", $time, uut.R2.Q, uut.R1.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R2 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R2.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0111010001, R2 = 4 Tstep = 5",$time);
          $display("[%0t] Teste LD R2, R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T4 - ADD R1, R2
      // -----------------------------
      if (mostra_teste4)
        begin
          $display("[%0t] Teste 4 instrucao ADD R1, R2, R1 inicial = %0d R2 inicial = %0d", $time, uut.R1.Q, uut.R2.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0011001010, R1 = 7 Tstep = 5",$time);
          $display("[%0t] Teste ADD R1, R2 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T5 - mv r3, r1
      // -----------------------------
      if (mostra_teste5)
        begin
          $display("[%0t] Teste 5 instrucao mv R3, R1, R1 inicial = %0d R3 inicial = %0d", $time, uut.R1.Q, uut.R3.Q);
          @(posedge Clock);
          #351;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R3 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R3.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0000011001, R3 = 7 Tstep = 3",$time);
          $display("[%0t] Teste mv r3, r1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end


      // -----------------------------
      // T6 - sub r1, r2
      // -----------------------------
      if (mostra_teste6)
        begin
          $display("[%0t] Teste 6 instrucao sub R1, R2, R1 inicial = %0d R2 inicial = %0d", $time, uut.R1.Q, uut.R2.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0100001010, R1 = 3 Tstep = 5",$time);
          $display("[%0t] Teste sub R1, R2 concluido.", $time);
          $display("--------------------------------------------------");
          // display_registradores;
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T7 - st r1, r0
      // -----------------------------
      if (mostra_teste7)
        begin
          $display("[%0t] Teste 7 instrucao st R1, R0, R1 inicial = %0d R0 inicial = %0d", $time, uut.R1.Q, uut.R0.Q);
          @(posedge Clock);
          #451;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 1000001000, R1 = 3 Tstep = 4",$time);
          $display("[%0t] Teste st R1, R0 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T8 - slt r0, r1
      // -----------------------------
      if (mostra_teste8)
        begin
          $display("[%0t] Teste 8 instrucao slt R0, R1, R0 inicial = %0d R1 inicial = %0d", $time, uut.R0.Q, uut.R1.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R0 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R0.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0101000001, R0 = 1 Tstep = 5",$time);
          $display("[%0t] Teste slt R0, R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T9 - push r1
      // -----------------------------
      if (mostra_teste9)
        begin
          $display("[%0t] Teste 9 instrucao push R1, R1 inicial = %0d", $time, uut.R1.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 1001001000, R1 = 3 Tstep = 5",$time);
          $display("[%0t] Teste push R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T10 - slt r1, r2
      // -----------------------------
      if (mostra_teste10)
        begin
          $display("[%0t] Teste 10 instrucao slt R1, R2, R1 inicial = %0d R2 inicial = %0d", $time, uut.R1.Q, uut.R2.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0101001010, R1 = 1 Tstep = 5",$time);
          $display("[%0t] Teste slt R1, R2 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T11 - mvnz r0, r1
      // -----------------------------
      if (mostra_teste11)
        begin
          $display("[%0t] Teste 11 instrucao mvnz R0, R1, R0 inicial = %0d R1 inicial = %0d", $time, uut.R0.Q, uut.R1.Q);
          @(posedge Clock);
          #351;
          $display("[%0t] Ciclo 3 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R0 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R0.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0010000001, R0 = 1 Tstep = 3",$time);
          $display("[%0t] Teste mvnz R0, R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T12 - add r0, r0
      // -----------------------------
      if (mostra_teste12)
        begin
          $display("[%0t] Teste 12 instrucao add R0, R0, R0 inicial = %0d", $time, uut.R0.Q);
          @(posedge Clock);
          #551;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R0 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R0.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0011000000, R0 = 2 Tstep = 5",$time);
          $display("[%0t] Teste add R0, R0 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T13 - mvnz r0, r1
      // -----------------------------
      if (mostra_teste13)
        begin
          $display("[%0t] Teste 13 instrucao mvnz R0, R1, R0 inicial = %0d R1 inicial = %0d", $time, uut.R0.Q, uut.R1.Q);
          @(posedge Clock);
          #351;
          $display("[%0t] Ciclo 3 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R0 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R0.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 0010000001, R0 = 1 Tstep = 3",$time);
          $display("[%0t] Teste mvnz R0, R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      // -----------------------------
      // T14 - pop r1
      // -----------------------------
      if (mostra_teste14)
        begin
          $display("[%0t] Teste 14 instrucao pop R1, R1 inicial = %0d", $time, uut.R1.Q);
          @(posedge Clock);
          #651;
          $display("[%0t] Ciclo 5 NEG_EDGE", $time);
          $display("[%0t]           IR = %10b, R1 = %0d Tstep = %0d", $time, uut.IR.Q, uut.R1.Q, uut.Tstep);
          if (detalhado)
            $display("[%0t] ESPERADO: IR = 1010001000, R1 = 3 Tstep = 6",$time);
          $display("[%0t] Teste pop R1 concluido.", $time);
          $display("--------------------------------------------------");
          if (mostra_registradores)
            begin
              display_registradores;
            end
        end

      #300;
      $stop;

      // ------------------------------
      // T11 - ST R1, R0
      // ------------------------------

    end

  task display_registradores;
    begin
      // $display("+------------+--------------+ Registradores +-------------+--------+--------+", $time);
      $display("+-------------------+-------+ Registradores +-------+-----------------------+");
      $display("|        R0 = %0d        | R1 = %0d        | R2 = %1d        | R3 = %1d             |",
               uut.R0.Q, uut.R1.Q, uut.R2.Q, uut.R3.Q);
      $display("+-------------------+---------------+---------------+-----------------------+");
    end
  endtask

  task display_registradorese;
    begin
      // $display("+------------+--------------+ Registradores +-------------+--------+--------+", $time);
      $display("                                 /////////                                           ");
      $display("                                ( O  u  O )                                            ");
      $display("                                    | |                                                ");
      $display(" +-------------------+-------+ Registradores +-------+-----------------------+ ");
      $display("\\\|        R0 = %0d        | R1 = %0d        | R2 = %1d        | R3 = %1d             |/",
               uut.R0.Q, uut.R1.Q, uut.R2.Q, uut.R3.Q);
      $display(" +-------------------+---------------+---------------+-----------------------+ ");
      $display("                         |                          |                             ");
      $display("                        _|                          |_                            ");
      $display(" \\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\/\\\ ");
             end
             endtask


               // Testes do AVA
               task teste_mvi_R2_1;
               begin
               Opcode = 3'b001; // mvi
               Rx = 3'b010;     // R2
               Ry = 3'b000;     // R0
               uut.R2.Q = 16'd0; // R0 = 11
               //uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 010
             end
             endtask

               task teste_mvi_R4_10;
               begin
               Opcode = 3'b001; // mvi
               Rx = 3'b100;     // R0
               Ry = 3'b000;     // zzz
               uut.R4.Q = 16'd0; // R0 = 11
               //uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste_mv_R5_R7;
               begin
               Opcode = 3'b000; // mvi
               Rx = 3'b101;     // R0
               Ry = 3'b111;     // zzz
               uut.R5.Q = 16'd1; // R0 = 11
               uut.R7.Q = 16'd2; // R0 = 11
               //uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste_sub_R4_R2;
               begin
               Opcode = 3'b011; // sub
               Rx = 3'b100;     // R4
               Ry = 3'b010;     // R2
               uut.R4.Q = 16'd10; // R4 = 10
               uut.R2.Q = 16'd6; // R2 = 6
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste_mvnz_R7_R5;
               begin
               Opcode = 3'b100; // mvnz
               Rx = 3'b111;     // R7
               Ry = 3'b101;     // R5
               uut.R7.Q = 16'd0; // R7 = 0
               uut.R5.Q = 16'd0; // R5 = 0
               uut.G.Q  = 16'd4; // G = 4
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask


               // Testes Internos

               task teste_mv_R0_R1;
               begin
               Opcode = 3'b000; // mv
               Rx = 3'b000;     // R0
               Ry = 3'b001;     // R1
               uut.R0.Q = 16'd11; // R0 = 11
               uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste_mvi_R0_5;
               begin
               Opcode = 3'b001; // mv
               Rx = 3'b000;     // R0
               Ry = 3'b001;     // R1
               uut.R0.Q = 16'd11; // R0 = 11
               uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste_sub_R1_R0;
               begin
               Opcode = 3'b011; // sub
               Rx = 3'b001;     // R1
               Ry = 3'b000;     // R0
               uut.R0.Q = 16'd5; // R0 = 11
               uut.R1.Q = 16'd10; // R1 = 10
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste1_mvnz_R0_R1;
               begin
               Opcode = 3'b100; // mvnz
               Rx = 3'b000;     // R0
               Ry = 3'b001;     // R1
               uut.R0.Q = 16'd11; // R0 = 11
               uut.R1.Q = 16'd10; // R1 = 10
               uut.G.Q  = 16'd0;  // G = 0
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask

               task teste2_mvnz_R0_R1;
               begin
               Opcode = 3'b100; // mvnz
               Rx = 3'b000;     // R0
               Ry = 3'b001;     // R1
               uut.R0.Q = 16'd11; // R0 = 11
               uut.R1.Q = 16'd10; // R1 = 10
               uut.G.Q  = 16'd5;  // G = 0
               DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
             end
             endtask



               task cabecalho_teste(input integer numero_task);
               begin
               $display("--------------------------------------------------");
               $display("[%0t] Teste %0d", $time, numero_task);
               $display("--------------------------------------------------");
             end
             endtask

               integer disp_sinais = 1;
               task meio_teste_1_ciclo;
               begin
               if (disp_sinais)
               $display("[%0t] Clock: %b, Resetn: %b, Run: %b, DIN: %b",$time, Clock, Resetn, Run, DIN);
               $display("[%0t] Barramento: %b, Tempo_Instrucao = %0d",$time, BusWires, uut.Tstep);
               $display("[%0t] Done: %b",$time, Done);
             end
             endtask

               /*
               always @(posedge Clock)
               begin
               counter_clock_cycle = counter_clock_cycle + 1;
               // $display("[%0t] Counter_Clock_Cycle ",$time);
               case (counter_clock_cycle)
               1:
               begin
               // Opcode = 3'b001; // mvi R0 5
               // Rx = 3'b000;     // R0
               // Ry = 3'b001;     // R1
               // uut.R0.Q = 16'd11; // R0 = 11
               // uut.R1.Q = 16'd10; // R1 = 10
               // DIN = {6'b000_000, Opcode, Rx, Ry}; // Formando a instrução: 000 001 000
               // cabecalho_teste(2);
               // Run = 1; // Agendado ja no inicio do ciclo
               // $display("[%0t] instrucao = %3b_%3b_%3b = mv R0 R1 000_000_001", $time, Instrucao[8:6], Instrucao[5:3], Instrucao[2:0]);
             end


             endcase

             end
               */


             endmodule





               /*
               1 Ciclo em verilog
               1. Avaliacao de condicoes, always, if,  e sinais agendados ( PROIBIDO USAR, ex: #2, se nao nao funciona FPGA)...
               2. Blocking e Non Blocking, (SO use BLOCKING em logica dentro dos blocos),
               3. Atribuicao dos Non Blocking Variaveis externas, sempre usar Non Blocking

               clear;vsim -c -do vlog_terminal_tb_proc.do
               killmodelsim;vsim -do vlog_wave_tb_proc.do
               alias killmodelsim='ps aux | grep '\''intelFPGA/20.1/'\'' | grep -v grep | awk '\''{print $2}'\'' | xargs kill -9'
               */
