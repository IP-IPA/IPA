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
// Module Name:    constantregfile                                            //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Constant register file                                     //
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
module constantregfile_pe #(parameter READ_AWIDTH = 5, parameter WRITE_AWIDTH = 4, parameter WRITE_DWIDTH = 64, parameter READ_DWIDTH = 32)
   (
    input logic 		   Clk, Reset, Read_En_CRF_0, Read_En_CRF_1, Write_En,
    input logic [READ_AWIDTH-1:0]  Read_Addr_CRF_0, Read_Addr_CRF_1,
    input logic [WRITE_DWIDTH-1:0] In_Const,
    input logic [WRITE_AWIDTH-1:0] Write_Addr, 
    output logic [READ_DWIDTH-1:0] Read_Data_CRF_0, Read_Data_CRF_1
    );
   localparam Num_Regs = 16;
   integer 			   i;
   

   logic [Num_Regs-1:0][63:0] 	   Mem_Content ;
   //logic [READ_DWIDTH-1:0] Read_Data0_reg;
   //logic [READ_DWIDTH-1:0] Read_Data1_reg;

   always_ff @(posedge Clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   for(i=0; i<Num_Regs; i++) begin
	      Mem_Content[i] <= '0;
	   end
	end else if(Write_En) begin
	   Mem_Content[Write_Addr] <= In_Const;	   
	end
     end
   always_comb begin
      
      if(Read_En_CRF_0 == 1'b1) begin
	 if(Read_Addr_CRF_0 == 5'b00000) begin
	    Read_Data_CRF_0 <= Mem_Content[0][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b00001) begin
	    Read_Data_CRF_0 <= Mem_Content[0][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b00010) begin
	    Read_Data_CRF_0 <= Mem_Content[1][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b00011) begin
	    Read_Data_CRF_0 <= Mem_Content[1][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b00100) begin
	    Read_Data_CRF_0 <= Mem_Content[2][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b00101) begin
	    Read_Data_CRF_0 <= Mem_Content[2][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b00110) begin
	    Read_Data_CRF_0 <= Mem_Content[3][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b00111) begin
	    Read_Data_CRF_0 <= Mem_Content[3][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b01000) begin
	    Read_Data_CRF_0 <= Mem_Content[4][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b01001) begin
	    Read_Data_CRF_0 <= Mem_Content[4][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b01010) begin
	    Read_Data_CRF_0 <= Mem_Content[5][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b01011) begin
	    Read_Data_CRF_0 <= Mem_Content[5][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b01100) begin
	    Read_Data_CRF_0 <= Mem_Content[6][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b01101) begin
	    Read_Data_CRF_0 <= Mem_Content[6][31:0];
	 end else if(Read_Addr_CRF_0 == 5'b01110) begin
	    Read_Data_CRF_0 <= Mem_Content[7][63:32];
	 end else if(Read_Addr_CRF_0 == 5'b01111) begin
	    Read_Data_CRF_0 <= Mem_Content[7][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10000) begin
	    Read_Data_CRF_0 <= Mem_Content[8][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10001) begin
	    Read_Data_CRF_0 <= Mem_Content[8][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10010) begin
	    Read_Data_CRF_0 <= Mem_Content[9][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10011) begin
	    Read_Data_CRF_0 <= Mem_Content[9][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10100) begin
	    Read_Data_CRF_0 <= Mem_Content[10][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10101) begin
	    Read_Data_CRF_0 <= Mem_Content[10][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10110) begin
	    Read_Data_CRF_0 <= Mem_Content[11][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10111) begin
	    Read_Data_CRF_0 <= Mem_Content[11][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11000) begin
	    Read_Data_CRF_0 <= Mem_Content[12][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11001) begin
	    Read_Data_CRF_0 <= Mem_Content[12][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11010) begin
	    Read_Data_CRF_0 <= Mem_Content[13][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11011) begin
	    Read_Data_CRF_0 <= Mem_Content[13][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11100) begin
	    Read_Data_CRF_0 <= Mem_Content[14][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11101) begin
	    Read_Data_CRF_0 <= Mem_Content[14][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11110) begin
	    Read_Data_CRF_0 <= Mem_Content[15][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11111) begin
	    Read_Data_CRF_0 <= Mem_Content[15][31:0];
	 end
      end else begin// if (Read_En_CRF_0 == 1'b1)
	 Read_Data_CRF_0 <= '0;
      end
      
      if(Read_En_CRF_1 == 1'b1) begin
	 if(Read_Addr_CRF_1 == 5'b00000) begin
	    Read_Data_CRF_1 <= Mem_Content[0][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b00001) begin
	    Read_Data_CRF_1 <= Mem_Content[0][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b00010) begin
	    Read_Data_CRF_1 <= Mem_Content[1][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b00011) begin
	    Read_Data_CRF_1 <= Mem_Content[1][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b00100) begin
	    Read_Data_CRF_1 <= Mem_Content[2][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b00101) begin
	    Read_Data_CRF_1 <= Mem_Content[2][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b00110) begin
	    Read_Data_CRF_1 <= Mem_Content[3][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b00111) begin
	    Read_Data_CRF_1 <= Mem_Content[3][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b01000) begin
	    Read_Data_CRF_1 <= Mem_Content[4][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b01001) begin
	    Read_Data_CRF_1 <= Mem_Content[4][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b01010) begin
	    Read_Data_CRF_1 <= Mem_Content[5][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b01011) begin
	    Read_Data_CRF_1 <= Mem_Content[5][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b01100) begin
	    Read_Data_CRF_1 <= Mem_Content[6][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b01101) begin
	    Read_Data_CRF_1 <= Mem_Content[6][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b01110) begin
	    Read_Data_CRF_1 <= Mem_Content[7][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b01111) begin
	    Read_Data_CRF_1 <= Mem_Content[7][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10000) begin
	    Read_Data_CRF_1 <= Mem_Content[8][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10001) begin
	    Read_Data_CRF_1 <= Mem_Content[8][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10010) begin
	    Read_Data_CRF_1 <= Mem_Content[9][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10011) begin
	    Read_Data_CRF_1 <= Mem_Content[9][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10100) begin
	    Read_Data_CRF_1 <= Mem_Content[10][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10101) begin
	    Read_Data_CRF_1 <= Mem_Content[10][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b10110) begin
	    Read_Data_CRF_1 <= Mem_Content[11][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b10111) begin
	    Read_Data_CRF_1 <= Mem_Content[11][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11000) begin
	    Read_Data_CRF_1 <= Mem_Content[12][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11001) begin
	    Read_Data_CRF_1 <= Mem_Content[12][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11010) begin
	    Read_Data_CRF_1 <= Mem_Content[13][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11011) begin
	    Read_Data_CRF_1 <= Mem_Content[13][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11100) begin
	    Read_Data_CRF_1 <= Mem_Content[14][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11101) begin
	    Read_Data_CRF_1 <= Mem_Content[14][31:0];
	 end else if(Read_Addr_CRF_1 == 5'b11110) begin
	    Read_Data_CRF_1 <= Mem_Content[15][63:32];
	 end else if(Read_Addr_CRF_1 == 5'b11111) begin
	    Read_Data_CRF_1 <= Mem_Content[15][31:0];
	 end
	 
      end else begin // if (Read_En_CRF_1 == 1'b1)
	 Read_Data_CRF_1 <= '0;
      end
   end
endmodule // constantregfile


