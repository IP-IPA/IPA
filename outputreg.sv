////////////////////////////////////////////////////////////////////////////////
// Company:        Multitherman Laboratory @ DEIS - University of Bologna     //
//                    Viale Risorgimento 2 40136                              //
//                    Bologna - fax 0512093785 -                              //
//                                                                            //
// Engineer:       Satyajit Das - satyajit.das@unibo.it                       //
//                                                                            //
// Additional contributions by:                                               //
//                                                                            //
//                                                                            //
//                                                                            //
// Create Date:    17/05/2016                                                 // 
// Design Name:    CGRA                                                       // 
// Module Name:    outputreg                                                  //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    output register                                            //
//                                                                            //
//                                                                            //
// Revision:                                                                  //
// Revision v0.1 - File Created                                               //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
module outputreg #(parameter DWIDTH = 32)
(
input logic Clk, Reset, Write_En,
output logic [DWIDTH-1:0] Read_Data, 
input logic [DWIDTH-1:0] Write_Data
);
localparam Num_Regs = 1;

logic [DWIDTH-1:0] MemContent;

always_comb
begin
	Read_Data <= MemContent;
end

always_ff @(posedge Clk or negedge Reset)
begin
	if(Reset == 1'b0) begin
	 MemContent <= '0;
	end else if(Write_En == 1'b1) begin
	 MemContent <= Write_Data;
	end
end
endmodule
	
