module Control(ins, MemtoReg, memWrite, Branch, ALUControl, ALUSrc, RegDst, RegWrite, alu4, alu3, alu2, alu1, alu0);

   input logic [31:0] ins;
   
   output logic [0:0] MemtoReg, memWrite, Branch, ALUSrc, RegDst, RegWrite, alu4, alu3, alu2, alu1, alu0;

   output logic [2:0] ALUControl;


   logic [0:0] add, lw, sw, jr, jal, nor1, nori, not1, bleu, rolv, rorv;


   assign add = ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign lw = ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign sw = ins[31] & ~ins[30] & ins[29] & ~ins[28] & ins[27] & ins[26];
   assign jr = ~ins[31] & ~ins[30] & ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign jal = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign nor1 = ins[31] & ~ins[30] & ~ins[29] & ins[28] & ins[27] & ~ins[26];
   assign nori = ~ins[31] & ~ins[30] & ins[29] & ins[28] & ins[27] & ~ins[26];
   assign not1 = ~ins[31] & ~ins[30] & ~ins[29] & ins[28] & ~ins[27] & ~ins[26];
   assign bleu = ~ins[31] & ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign rolv = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign rorv = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ~ins[26];
   
   assign alu0 = 1'b0;
   assign alu1 = 1'b0;
   assign alu2 = 1'b0;
   assign alu3 = 1'b0;
   assign alu4 = 1'b0;

   
   assign regWriteEnable = lw;
   assign MemtoReg = lw;
   assign memWrite = sw;
   assign Branch = bleu;
   assign ALUSrc = lw | sw;
   assign RegDst = add | nor1 | rolv | rorv | not1;
   assign RegWrite = add | nor1 | rolv | rorv | not1 | lw | nori;


   logic [4:0] Out;
   mux4to1B5 mux1(lw, 1'b0, 5'b100, 5'b11, {{3'b0, 1'b1}, 1'b0}, 5'b1, Out);


   assign ALUControl = Out;
   
   always @ (lw)
     begin
	$display("lw : %h ",lw);
	$display("Out: %h ",Out);
	
     end


   endmodule