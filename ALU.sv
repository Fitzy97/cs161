/*
As you are given it, this ALU only implements Add
  */

module ALU(input logic  [31:0] I1,
	   input logic [31:0] I2,
	   input logic [2:0] Selector,
	   output logic [31:0] O
	   );

   
   logic [31:0] 	       added;
   assign added = I1 + I2;

   logic [31:0] 	       nored;
   assign nored = ~(I1 | I2);

   logic [31:0] 	       notted;
   assign notted = ~I1;

   logic [4:0] 		       shamt;
   initial
     shamt <= I1[4:0];
   logic [31:0] 	       rolved;
   //assign rolved = {I2[(31-shamt):0], I2[31:(31-shamt+1)]};

   logic [31:0] 	       rorved;
   //assign rorved = {I2[(shamt-1):0], I2[31:(31-shamt)]};
   
   
   logic [31:0] 	       mux1out, mux2out, mux3out;
   
   mux4to1B32 mux2(Selector[1], Selector[2], 32'b0, 32'b0, added, 32'b0, mux2out);
   mux4to1B32 mux3(Selector[1], Selector[2], 32'b0, 32'b0, 32'b0, 32'b0, mux3out);


   
   mux2to1B32 mux1(Selector[0], mux3out, mux2out, mux1out);
   
   //output logic [31:0] 	       mux1out;
   
   assign O = mux1out;

         always @ (added)
	   begin
	      	$display("I1 : %h ",I1);
	$display("I2 : %h ",I2);
	$display("added : %h ",added);
	$display("mux1out : %h ",mux1out);
	
     end
   
endmodule
