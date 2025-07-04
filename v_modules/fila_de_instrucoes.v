module fila_de_instrucoes(
    input Clock,
    input Reset,
    input Pop,           // Despacho geral
    input Pop_R,         // Despacho somente se próxima for tipo R
    input Pop_I,         // Despacho somente se próxima for tipo I
    output reg [15:0] Instrucao_Despachada,
    output reg Full,
    output reg Empty
  );

  parameter sem_valor = 16'b0000_0000_0000_0101;
  parameter ADD = 3'd2;
  parameter SUB = 3'd3;
  parameter  LD = 3'd4; // Load
  parameter  ST = 3'd5; // Store

  // Filas físicas
  reg [15:0] Fila_R[7:0];
  reg [15:0] Fila_I[7:0];
  reg [2:0]  head_R, tail_R;
  reg [2:0]  head_I, tail_I;

  // Fila lógica de tipos (ordem de chegada)
  reg [0:0] TipoFila[15:0];  // 0 = R, 1 = I
  reg [3:0] head, tail;
  reg [4:0] count;

  // Memória de instruções
  reg [3:0] PC;
  wire [15:0] Mem_data;

  memoria_instrucoes u_memoria_instrucoes(
                       .Reset   (Reset),
                       .Clock   (Clock),
                       .Wren    (1'b0),
                       .Address (PC),
                       .Din     (16'b0),
                       .Q       (Mem_data)
                     );

  function [2:0] get_opcode;
    input [15:0] instr;
    get_opcode = instr[15:13];
  endfunction

  always @(negedge Clock or posedge Reset)
    begin
      if (Reset)
        begin
          head <= 0;
          tail <= 0;
          count <= 0;
          head_R <= 0;
          tail_R <= 0;
          head_I <= 0;
          tail_I <= 0;
          PC <= 0;
          Instrucao_Despachada <= sem_valor;
        end
      else
        begin
          // Preenchimento da fila se houver espaço
          if (count < 16)
            begin
              case (get_opcode(Mem_data))
                ADD:
                  begin
                    if ((tail_R + 1) != head_R)
                      begin
                        Fila_R[tail_R] = Mem_data;
                        TipoFila[tail] = 0;
                        tail_R         = tail_R + 1;
                        tail           = tail + 1;
                        count          = count + 1;
                        PC             = PC + 1;
                      end
                  end
                SUB:
                  begin
                    if ((tail_R + 1) != head_R)
                      begin
                        Fila_R[tail_R] = Mem_data;
                        TipoFila[tail] = 0;
                        tail_R         = tail_R + 1;
                        tail           = tail + 1;
                        count          = count + 1;
                        PC             = PC + 1;
                      end
                  end
                LD:
                  begin
                    // $display("[%0t] Sou um load simplorio",$time);
                    if ((tail_I + 1) != head_I)
                      begin
                        Fila_I[tail_I] = Mem_data;
                        TipoFila[tail] = 1;
                        tail_I         = tail_I + 1;
                        tail           = tail + 1;
                        count          = count + 1;
                        PC             = PC + 1;
                      end
                    // Depuracao com display
                    // $display("[%0t] Fila_I[%0d] = %b", $time, tail_I - 1, Fila_I[tail_I - 1]);
                  end
                ST:
                  begin
                    if ((tail_I + 1) != head_I)
                      begin
                        Fila_I[tail_I] = Mem_data;
                        TipoFila[tail] = 1;
                        tail_I         = tail_I + 1;
                        tail           = tail + 1;
                        count          = count + 1;
                        PC             = PC + 1;
                      end
                  end
              endcase
            end

          // Despacho (por ordem de chegada, com tipo condicional)
          if (count >= 0)
            begin
              if (Pop)
                begin
                  // $display("[%0t] Despacho de instrucao head =  %0d, Tipo_fila[head] = %0d", $time, head, TipoFila[head]);
                  if (TipoFila[head] == 0)
                    begin
                      // $display("[%0t] Despacho de instrucao R [%0d] com opcode %b",
                      //          $time, head_R, Fila_R[head_R][15:13]);
                      Instrucao_Despachada  = Fila_R[head_R];
                      head_R               <= head_R + 1;
                      head                 <= head + 1;
                      Fila_R[head_R]        = sem_valor;       // Limpa a posição
                    end
                  else
                    begin
                      // $display("[%0t] Despacho de instrucao I [%0d] com opcode %b",
                      //          $time, head_I, Fila_I[head_I][15:13]);
                      Instrucao_Despachada <= Fila_I[head_I];
                      head_I               <= head_I + 1;
                      head                 <= head + 1;
                      Fila_I[head_I]        = sem_valor;       // Limpa a posição
                    end
                end
              else if (Pop_R && TipoFila[head] == 0)
                begin
                  Instrucao_Despachada <= Fila_R[head_R];
                  head_R <= head_R + 1;
                end
              else if (Pop_I && TipoFila[head] == 1)
                begin
                  Instrucao_Despachada = Fila_I[head_I];
                  head_I = head_I + 1;
                end
            end

          // Flags
          Full <= (count == 16);
          Empty <= (count == 0);
        end
    end
endmodule
