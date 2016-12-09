module DataPath(clock, pcQ, instr, pcD, RegWrite);

   // The clock will be driven from the testbench 
   // The instruction, pcQ and pcD are sent to the testbench to
   // make debugging easier

   logic [0:0] PCSrc;
   logic[31:0] PCPlus4;
   logic[31:0] PCBranch;
   logic[31:0] mux1out;
   logic [4:0] 	       WriteReg;
   logic [31:0]        Result;
   logic [31:0]        out2;

   mux2to1B32 mux1(1'b0, PCBranch, PCPlus4, mux1out);
   
   input logic clock;
   output logic [31:0] instr;
   output logic [31:0] pcQ;
   output logic [31:0] pcD;
   output logic [0:0] RegWrite;
   

   
   // The PC is just a register
   // for now, it is always enabled so it updates on every clock cycle
   // Its ports are above
   
   enabledRegister PC(pcD,pcQ,clock,1'b1);

      assign pcD = mux1out;
   // set up a hard-wired connection to a value
   
   logic [31:0] constant4;

   initial
     constant4 <= 32'b100;

   // construct the adder for the PC incrementing circuit.

   logic [31:0] adderIn1, adderIn2, adderOut;
   
   adder psAdd(adderIn1,adderIn2,adderOut);

   // Connect the adder to the right inputs and output
   // notice that using pcD and pcQ here and above in the PC register is like
   // connecting a wire  BUT the wires have a direction. E.g. the first
   // line below says a signal goes from pcQ to adderIn1
   
   assign adderIn1 = pcQ;
   assign adderIn2 = constant4;
   assign PCPlus4 = adderOut;

   
   // construct the instuctionmemory
   // wired to PC and instruction

   logic [31:0] instA;
   
   instructionMemory2016 imem(instA,instr);

   // Wire instruction memory

   assign instA = pcQ;

   // construct the control unit  This unit generates the signals that control the datapath
   // it will have many more ports later


   logic [0:0] 	MemtoReg, memWrite, Branch, ALUSrc, RegDst, alu4, alu3, alu2, alu1, alu0;

   logic [2:0] 	ALUControl;
   
   Control theControl(instr, MemtoReg, memWrite, Branch, ALUControl, ALUSrc, RegDst, RegWrite, alu4, alu3, alu2, alu1, alu0);
   
   
   // construct the register file with (currently mostly) unused values to connect to it
   
   logic [4:0] 	       A3, A2, A1;
   logic 	       WE3;
   logic [31:0]        WD3, RD1, RD2;

   
   registerFile theRegisters(A1,A2, 
			     A3, clk, WE3, WD3, RD1, RD2);

   // attach the A1 port to 5 bits of the instruction

   logic [31:0]   RD;

   assign clk = clock;
   assign A1 = instr[25:21];
   assign A2 = instr[20:16];
   assign A3 = WriteReg;
   assign WD3 = Result;
   assign WE3 = RegWrite;
   
   
   logic [31:0]        SignImm;

   // sign extend the immediate field
   //  
   assign SignImm = {{16{instr[15]}}, instr[15:0]};

   logic [31:0]        SrcA, SrcB, ALUResult;
   logic [4:0] 	       aluSelect;
   

   logic [31:0]        constant2, adderInB1, ShiftedSignImm, adderOutB;

   initial
     constant2 <= 32'b10;
   
   assign ShiftedSignImm = SignImm << constant2;
   assign adderInB1 = PCPlus4;
   

   adder PCBranchAdder(adderInB1, ShiftedSignImm, adderOutB);

   assign PCBranch = adderOutB;
   
   mux2to1B5 mux2(RegDst, instr[15:11], instr[20:16], WriteReg);
   
   
   ALU theALU(SrcA, SrcB, ALUControl, ALUResult);

   // attach the SrcA port to RD1 and SrcB to SignImm
   
   assign SrcA = RD1;
   assign SrcB = SignImm;

   logic 	       Zero;
   
   logic [31:0]        WD,dataA;
   logic [0:0] 	       WE;

   dataMemory data(dataA, RD, WD, clk, WE);

   // attach clk to clock, We to memWrite, dataA to ALUResult, and WD to RD2

   assign clk = clock;
   assign WE = memWrite;
   assign dataA = ALUResult;
   assign WD = RD2;

   //create multiplxors for R-type instructions
   mux2to1B32 mux3(1'b1, SignImm, RD2, out2);


   mux2to1B32 mux4(1'b1, RD, ALUResult, Result);
   
      always @ (negedge clock)
	begin
	   	$display("A2 : %h ",A2);
	$display("RD2 : %h ",RD2);
	   	$display("SrcA : %h ",SrcA);
	$display("SrcB : %h ",SrcB);
	$display("ALU Result : %h ",ALUResult);
	$display("ALU Control : %h ",ALUControl);
	   $display("Result : %h",Result);
	   $display("RD : %h",RD);
	   
	   
     end

   
endmodule

