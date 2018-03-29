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
// Module Name:    orcond                                                     //
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
module orcond #(parameter NB_ROWS = 4, parameter NB_COLS = 4)
   (
    input logic [(NB_ROWS*NB_COLS)-1:0] In_Cond,
    output logic 			Out_Cond 
    );
   logic [NB_ROWS*NB_COLS:0] tmp;
   assign tmp[0] = 0;
   
   genvar 		    i;
   generate
      for(i=0; i< NB_ROWS*NB_COLS; i++) begin
        assign tmp[i+1] = tmp[i] | In_Cond[i];
      end
   endgenerate
   always_comb begin
      Out_Cond= tmp[NB_ROWS*NB_COLS];
   end      
endmodule // orcond



   
