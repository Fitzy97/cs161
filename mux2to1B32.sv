module mux2to1B32 (input logic C,
		  input logic[31:0] I1, 
		  input logic[31:0] I0, 
		  output logic[31:0] O);
   
	mux4to1B4 m0(1'b0,C,4'b0,I1[3:0],4'b0,I0[3:0],O[3:0]);
	mux4to1B4 m1(1'b0,C,4'b0,I1[7:4],4'b0,I0[7:4],O[7:4]);
	mux4to1B4 m2(1'b0,C,4'b0,I1[11:8],4'b0,I0[11:8],O[11:8]);
	mux4to1B4 m3(1'b0,C,4'b0,I1[15:12],4'b0,I0[15:12],O[15:12]);
   	mux4to1B4 m4(1'b0,C,4'b0,I1[19:16],4'b0,I0[19:16],O[19:16]);
	mux4to1B4 m5(1'b0,C,4'b0,I1[23:20],4'b0,I0[23:20],O[23:20]);
   	mux4to1B4 m6(1'b0,C,4'b0,I1[27:24],4'b0,I0[27:24],O[27:24]);
	mux4to1B4 m7(1'b0,C,4'b0,I1[31:28],4'b0,I0[31:28],O[31:28]);

endmodule