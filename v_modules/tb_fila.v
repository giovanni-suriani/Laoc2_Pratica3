module tb_fila;




memoria_dados u_memoria_dados(
  .Reset   (Reset   ),
  .Clock   (Clock   ),
  .wren    (wren    ),
  .Address (Address ),
  .Din     (Din     ),
  .Q       (Q       )
);


endmodule
