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
// Module Name:    datamem                                                    //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    CGRA                                                       //
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
///////////////////////////////////////////////////////////////////////////////
module datamemory #(parameter NB_ROWS = 4, parameter NB_COLS = 4)
(
 input logic[(NB_COLS*NB_ROWS)-1 : 0] [31:0] Data_Addr_In,
 output logic[(NB_COLS*NB_ROWS)-1 : 0] [31:0] Data_Out 
);
  logic  [4095:0] [31:0] Data_Reg;
   integer     i;
   
   initial begin
      $readmemh("data.hex", Data_Reg);
   end
   always_comb begin
      for(i = 0; i< NB_ROWS*NB_COLS; i++) begin	 
	 Data_Out[i] <= Data_Reg[Data_Addr_In[i]];
      end
   end  
endmodule // datamemory

