module instructionMemory(input logic [31:0] A, 
		output logic [31:0] RD);

logic [31:0] instructs [19:0];
// Note:  if load word doesn't work, this test code also will not work
initial 
begin
   instructs[0] = 32'b100011_00000_00001_0000000000001000;  // lw r1 <- 15  
   instructs[1] = 32'b101011_00000_00001_0000000000010000;  // sw 15 into location 4 (16 as a byte address)
   instructs[2] = 32'b100011_00001_00000_0000000000000001;  // lw r0 <- 15 from location 4
   instructs[3] = 32'b100011_00001_00000_0000000000000101;  // lw r0 <- 0 from location 5  
   instructs[4] = 32'b100011_00000_00001_0000000000000000;  //lw r1 <- 1100   (000c)

end

assign RD = instructs[A[6:2]];




endmodule



