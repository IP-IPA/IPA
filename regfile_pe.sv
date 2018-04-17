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
// Module Name:    regfile                                                    //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Register file                                              //
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
module regfile_pe #(parameter AWIDTH = 3, parameter DWIDTH = 32)
   (
    input logic 	      Clk, Reset, Read_En0, Read_En1, Write_En,
    input logic [AWIDTH-1:0]  Read_Addr0, Read_Addr1, Write_Addr,
    output logic [DWIDTH-1:0] Read_Data0, Read_Data1, 
    input logic [DWIDTH-1:0]  Write_Data
    );
   localparam Num_Regs = 2**AWIDTH;

   logic [Num_Regs-1:0][DWIDTH-1:0] MemContent;
   logic [DWIDTH-1:0] 		    Read_Data0_reg;
   logic [DWIDTH-1:0] 		    Read_Data1_reg;
   logic 			    Write_En_Reg;
   logic [AWIDTH-1:0] 		    Write_Addr_Reg;
   
   integer 			    i;
   
   always_comb
     begin
	Read_Data0 <=  MemContent[Read_Addr0];
	Read_Data1 <=  MemContent[Read_Addr1];
     end
   
   always_ff @(posedge Clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   for(i=0; i<Num_Regs; i++) begin
	      MemContent[i] <= '0;
	   end
	end else if(Write_En == 1'b1) begin
	   MemContent[Write_Addr] <= Write_Data;
	end
	
     end
endmodule

