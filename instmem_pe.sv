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
// Module Name:    instmem                                                    //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Instruction memory                                         //
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
module instmem_pe #(parameter WRITE_AWIDTH = 6, parameter WRITE_DWIDTH = 64, parameter READ_AWIDTH = 7, parameter READ_DWIDTH = 20)
(
 input logic 	     Clk, Write_En, Reset, exec_en,
 input logic [WRITE_AWIDTH-1:0]   Write_Addr,
 input logic [WRITE_DWIDTH-1:0]  In_Inst,
 input logic [READ_AWIDTH-1:0]   Inst_Addr,
 output logic [READ_DWIDTH-1:0] Inst_Data
);
   integer 			i;
   
   logic [63:0] [WRITE_DWIDTH-1:0] im ;
   
   always_ff @(posedge Clk or negedge Reset) begin
      if(Reset == 1'b0) begin
	 for(i=0; i<16; i++) begin
	    im[i] <= '0;
	 end
      end else if(Write_En == 1'b1) begin
	 im[Write_Addr] <= In_Inst;	 
      end
   end
   
   
//initial begin
//$readmemh("program.bin", im);
//end
always_comb begin
   if(Inst_Addr == 7'b0000000) begin
      Inst_Data <= im[0][63:44];
   end else if(Inst_Addr == 7'b0000001) begin
      Inst_Data <= im[0][43:24];
   end else if(Inst_Addr == 7'b0000010) begin
      Inst_Data <= im[0][23:4];
   end else if(Inst_Addr == 7'b0000011) begin
      Inst_Data[19:16] <= im[0][3:0];
      Inst_Data[15:0] <= im[1][63:48];
   end else if(Inst_Addr == 7'b0000100) begin
      Inst_Data <= im[1][47:28];
   end else if(Inst_Addr == 7'b0000101) begin
      Inst_Data <= im[1][27:8];
   end else if(Inst_Addr == 7'b0000110) begin
      Inst_Data[19:12] <= im[1][7:0];
      Inst_Data[11:0] <= im[2][63:52];
   end else if(Inst_Addr == 7'b0000111) begin
      Inst_Data <= im[2][51:32];
   end else if(Inst_Addr == 7'b0001000) begin
      Inst_Data <= im[2][31:12];
   end else if(Inst_Addr == 7'b0001001) begin
      Inst_Data[19:8] <= im[2][11:0];
      Inst_Data[7:0] <= im[3][63:56];
   end else if(Inst_Addr == 7'b0001010) begin
      Inst_Data <= im[3][55:36];
   end else if(Inst_Addr == 7'b0001011) begin
      Inst_Data <= im[3][35:16];
   end else if(Inst_Addr == 7'b0001100) begin
      Inst_Data[19:4] <= im[3][15:0];
      Inst_Data[3:0] <= im[4][63:60];
   end  else if(Inst_Addr == 7'b0001101) begin
      Inst_Data <= im[4][59:40];
   end else if(Inst_Addr == 7'b0001110) begin
      Inst_Data <= im[4][39:20];
   end else if(Inst_Addr == 7'b0001111) begin
      Inst_Data <= im[4][19:0];
   end  else if(Inst_Addr == 7'b0010000) begin
      Inst_Data <= im[5][63:44];
   end else if(Inst_Addr == 7'b0010001) begin
      Inst_Data <= im[5][43:24];
   end else if(Inst_Addr == 7'b0010010) begin
      Inst_Data <= im[5][23:4];
   end  else if(Inst_Addr == 7'b0010011) begin
      Inst_Data[19:16] <= im[5][3:0];
      Inst_Data[15:0] <= im[6][63:48];
   end else if(Inst_Addr == 7'b0010100) begin
      Inst_Data <= im[6][47:28];
   end else if(Inst_Addr == 7'b0010101) begin
      Inst_Data <= im[6][27:8];
   end  else if(Inst_Addr == 7'b0010110) begin
      Inst_Data[19:12] <= im[6][7:0];
      Inst_Data[11:0] <= im[7][63:52];
   end else if(Inst_Addr == 7'b0010111) begin
      Inst_Data <= im[7][51:32];
   end else if(Inst_Addr == 7'b0011000) begin
      Inst_Data <= im[7][31:12];
   end  else if(Inst_Addr == 7'b0011001) begin
      Inst_Data[19:8] <= im[7][11:0];
      Inst_Data[7:0] <= im[8][63:56];
   end else if(Inst_Addr == 7'b0011010) begin
      Inst_Data <= im[8][55:36];
   end else if(Inst_Addr == 7'b0011011) begin
      Inst_Data <= im[8][35:16];
   end  else if(Inst_Addr == 7'b0011100) begin
      Inst_Data[19:4] <= im[8][15:0];
      Inst_Data[3:0] <= im[9][63:60];
   end else if(Inst_Addr == 7'b0011101) begin
      Inst_Data <= im[9][59:40];
   end else if(Inst_Addr == 7'b0011110) begin
      Inst_Data <= im[9][39:20];
   end  else if(Inst_Addr == 7'b0011111) begin
      Inst_Data <= im[9][19:0];
   end else if(Inst_Addr == 7'b0100000) begin
      Inst_Data <= im[10][63:44];
   end else if(Inst_Addr == 7'b0100001) begin
      Inst_Data <= im[10][43:24];
   end else if(Inst_Addr == 7'b0100010) begin
      Inst_Data <= im[10][23:4];
   end else if(Inst_Addr == 7'b0100011) begin
      Inst_Data[19:16] <= im[10][3:0];
      Inst_Data[15:0] <= im[11][63:48];
   end else if(Inst_Addr == 7'b0100100) begin
      Inst_Data <= im[11][47:28];
   end else if(Inst_Addr == 7'b0100101) begin
      Inst_Data <= im[11][27:8];
   end else if(Inst_Addr == 7'b0100110) begin
      Inst_Data[19:12] <= im[11][7:0];
      Inst_Data[11:0] <= im[12][63:52];
   end else if(Inst_Addr == 7'b0100111) begin
      Inst_Data <= im[12][51:32];
   end else if(Inst_Addr == 7'b0101000) begin
      Inst_Data <= im[12][31:12];
   end else if(Inst_Addr == 7'b0101001) begin
      Inst_Data[19:8] <= im[12][11:0];
      Inst_Data[7:0] <= im[13][63:56];
   end else if(Inst_Addr == 7'b0101010) begin
      Inst_Data <= im[13][55:36];
   end else if(Inst_Addr == 7'b0101011) begin
      Inst_Data <= im[13][35:16];
   end else if(Inst_Addr == 7'b0101100) begin
      Inst_Data[19:4] <= im[13][15:0];
      Inst_Data[3:0] <= im[14][63:60];
   end  else if(Inst_Addr == 7'b0101101) begin
      Inst_Data <= im[14][59:40];
   end else if(Inst_Addr == 7'b0101110) begin
      Inst_Data <= im[14][39:20];
   end else if(Inst_Addr == 7'b0101111) begin
      Inst_Data <= im[14][19:0];
   end  else if(Inst_Addr == 7'b0110000) begin
      Inst_Data <= im[15][63:44];
   end else if(Inst_Addr == 7'b0110001) begin
      Inst_Data <= im[15][43:24];
   end else if(Inst_Addr == 7'b0110010) begin
      Inst_Data <= im[15][23:4];
   end  else if(Inst_Addr == 7'b0110011) begin
      Inst_Data[19:16] <= im[15][3:0];
      Inst_Data[15:0] <= im[16][63:48];
   end else if(Inst_Addr == 7'b0110100) begin
      Inst_Data <= im[16][47:28];
   end else if(Inst_Addr == 7'b0110101) begin
      Inst_Data <= im[16][27:8];
   end  else if(Inst_Addr == 7'b0110110) begin
      Inst_Data[19:12] <= im[16][7:0];
      Inst_Data[11:0] <= im[17][63:52];
   end else if(Inst_Addr == 7'b0110111) begin
      Inst_Data <= im[17][51:32];
   end else if(Inst_Addr == 7'b0111000) begin
      Inst_Data <= im[17][31:12];
   end  else if(Inst_Addr == 7'b0111001) begin
      Inst_Data[19:8] <= im[17][11:0];
      Inst_Data[7:0] <= im[18][63:56];
   end else if(Inst_Addr == 7'b0111010) begin
      Inst_Data <= im[18][55:36];
   end else if(Inst_Addr == 7'b0111011) begin
      Inst_Data <= im[18][35:16];
   end  else if(Inst_Addr == 7'b0111100) begin
      Inst_Data[19:4] <= im[18][15:0];
      Inst_Data[3:0] <= im[19][63:60];
   end else if(Inst_Addr == 7'b0111101) begin
      Inst_Data <= im[19][59:40];
   end else if(Inst_Addr == 7'b0111110) begin
      Inst_Data <= im[19][39:20];
   end  else if(Inst_Addr == 7'b0111111) begin
      Inst_Data <= im[19][19:0];
   end else if(Inst_Addr == 7'b1000000) begin
      Inst_Data <= im[20][63:44];
   end else if(Inst_Addr == 7'b1000001) begin
      Inst_Data <= im[20][43:24];
   end else if(Inst_Addr == 7'b1000010) begin
      Inst_Data <= im[20][23:4];
   end else if(Inst_Addr == 7'b1000011) begin
      Inst_Data[19:16] <= im[20][3:0];
      Inst_Data[15:0] <= im[21][63:48];
   end else if(Inst_Addr == 7'b1000100) begin
      Inst_Data <= im[21][47:28];
   end else if(Inst_Addr == 7'b1000101) begin
      Inst_Data <= im[21][27:8];
   end else if(Inst_Addr == 7'b1000110) begin
      Inst_Data[19:12] <= im[21][7:0];
      Inst_Data[11:0] <= im[22][63:52];
   end else if(Inst_Addr == 7'b1000111) begin
      Inst_Data <= im[22][51:32];
   end else if(Inst_Addr == 7'b1001000) begin
      Inst_Data <= im[22][31:12];
   end else if(Inst_Addr == 7'b1001001) begin
      Inst_Data[19:8] <= im[22][11:0];
      Inst_Data[7:0] <= im[23][63:56];
   end else if(Inst_Addr == 7'b1001010) begin
      Inst_Data <= im[23][55:36];
   end else if(Inst_Addr == 7'b001011) begin
      Inst_Data <= im[23][35:16];
   end else if(Inst_Addr == 7'b1001100) begin
      Inst_Data[19:4] <= im[23][15:0];
      Inst_Data[3:0] <= im[24][63:60];
   end  else if(Inst_Addr == 7'b1001101) begin
      Inst_Data <= im[24][59:40];
   end else if(Inst_Addr == 7'b1001110) begin
      Inst_Data <= im[24][39:20];
   end else if(Inst_Addr == 7'b1001111) begin
      Inst_Data <= im[24][19:0];
   end  else if(Inst_Addr == 7'b1010000) begin
      Inst_Data <= im[25][63:44];
   end else if(Inst_Addr == 7'b1010001) begin
      Inst_Data <= im[25][43:24];
   end else if(Inst_Addr == 7'b1010010) begin
      Inst_Data <= im[25][23:4];
   end  else if(Inst_Addr == 7'b1010011) begin
      Inst_Data[19:16] <= im[25][3:0];
      Inst_Data[15:0] <= im[26][63:48];
   end else if(Inst_Addr == 7'b1010100) begin
      Inst_Data <= im[26][47:28];
   end else if(Inst_Addr == 7'b1010101) begin
      Inst_Data <= im[26][27:8];
   end  else if(Inst_Addr == 7'b1010110) begin
      Inst_Data[19:12] <= im[26][7:0];
      Inst_Data[11:0] <= im[27][63:52];
   end else if(Inst_Addr == 7'b1010111) begin
      Inst_Data <= im[27][51:32];
   end else if(Inst_Addr == 7'b1011000) begin
      Inst_Data <= im[27][31:12];
   end  else if(Inst_Addr == 7'b1011001) begin
      Inst_Data[19:8] <= im[27][11:0];
      Inst_Data[7:0] <= im[28][63:56];
   end else if(Inst_Addr == 7'b1011010) begin
      Inst_Data <= im[28][55:36];
   end else if(Inst_Addr == 7'b1011011) begin
      Inst_Data <= im[28][35:16];
   end  else if(Inst_Addr == 7'b1011100) begin
      Inst_Data[19:4] <= im[28][15:0];
      Inst_Data[3:0] <= im[29][63:60];
   end else if(Inst_Addr == 7'b1011101) begin
      Inst_Data <= im[29][59:40];
   end else if(Inst_Addr == 7'b1011110) begin
      Inst_Data <= im[29][39:20];
   end  else if(Inst_Addr == 7'b1011111) begin
      Inst_Data <= im[29][19:0];
   end else if(Inst_Addr == 7'b1100000) begin
      Inst_Data <= im[30][63:44];
   end else if(Inst_Addr == 7'b1100001) begin
      Inst_Data <= im[30][43:24];
   end else if(Inst_Addr == 7'b1100010) begin
      Inst_Data <= im[30][23:4];
   end else if(Inst_Addr == 7'b1100011) begin
      Inst_Data[19:16] <= im[30][3:0];
      Inst_Data[15:0] <= im[31][63:48];
   end else if(Inst_Addr == 7'b1100100) begin
      Inst_Data <= im[31][47:28];
   end else if(Inst_Addr == 7'b1100101) begin
      Inst_Data <= im[31][27:8];
   end else if(Inst_Addr == 7'b1100110) begin
      Inst_Data[19:12] <= im[31][7:0];
      Inst_Data[11:0] <= im[32][63:52];
   end else if(Inst_Addr == 7'b1100111) begin
      Inst_Data <= im[32][51:32];
   end else if(Inst_Addr == 7'b1101000) begin
      Inst_Data <= im[32][31:12];
   end else if(Inst_Addr == 7'b1101001) begin
      Inst_Data[19:8] <= im[32][11:0];
      Inst_Data[7:0] <= im[33][63:56];
   end else if(Inst_Addr == 7'b1101010) begin
      Inst_Data <= im[33][55:36];
   end else if(Inst_Addr == 7'b1101011) begin
      Inst_Data <= im[33][35:16];
   end else if(Inst_Addr == 7'b1101100) begin
      Inst_Data[19:4] <= im[33][15:0];
      Inst_Data[3:0] <= im[34][63:60];
   end  else if(Inst_Addr == 7'b1101101) begin
      Inst_Data <= im[34][59:40];
   end else if(Inst_Addr == 7'b1101110) begin
      Inst_Data <= im[34][39:20];
   end else if(Inst_Addr == 7'b1101111) begin
      Inst_Data <= im[34][19:0];
   end  else if(Inst_Addr == 7'b1110000) begin
      Inst_Data <= im[35][63:44];
   end else if(Inst_Addr == 7'b1110001) begin
      Inst_Data <= im[35][43:24];
   end else if(Inst_Addr == 7'b1110010) begin
      Inst_Data <= im[35][23:4];
   end  else if(Inst_Addr == 7'b1110011) begin
      Inst_Data[19:16] <= im[35][3:0];
      Inst_Data[15:0] <= im[36][63:48];
   end else if(Inst_Addr == 7'b1110100) begin
      Inst_Data <= im[36][47:28];
   end else if(Inst_Addr == 7'b1110101) begin
      Inst_Data <= im[36][27:8];
   end  else if(Inst_Addr == 7'b1110110) begin
      Inst_Data[19:12] <= im[36][7:0];
      Inst_Data[11:0] <= im[37][63:52];
   end else if(Inst_Addr == 7'b1110111) begin
      Inst_Data <= im[37][51:32];
   end else if(Inst_Addr == 7'b1111000) begin
      Inst_Data <= im[37][31:12];
   end  else if(Inst_Addr == 7'b1111001) begin
      Inst_Data[19:8] <= im[37][11:0];
      Inst_Data[7:0] <= im[38][63:56];
   end else if(Inst_Addr == 7'b1111010) begin
      Inst_Data <= im[38][55:36];
   end else if(Inst_Addr == 7'b1111011) begin
      Inst_Data <= im[38][35:16];
   end  else if(Inst_Addr == 7'b1111100) begin
      Inst_Data[19:4] <= im[38][15:0];
      Inst_Data[3:0] <= im[39][63:60];
   end else if(Inst_Addr == 7'b1111101) begin
      Inst_Data <= im[39][59:40];
   end else if(Inst_Addr == 7'b1111110) begin
      Inst_Data <= im[39][39:20];
   end  else if(Inst_Addr == 7'b1111111) begin
      Inst_Data <= im[39][19:0];
   end
   
end // always_comb begin
   
endmodule

