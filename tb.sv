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
// Design Name:    TB                                                         // 
// Module Name:    tb                                                         //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    CGRA_TB                                                    //
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
`timescale 1ns/1ps
`define CLK_PERIOD 10

module tb;
   parameter NB_ROWS = 4;
   parameter NB_COLS = 4;
   logic Clk, DMA_Clk, Reset, Context_Fetch_En, Initn;
   logic [(NB_ROWS*NB_COLS)-1 : 0] End_Exec_I;
   logic 			   Exec_Comp;
   logic [NB_ROWS*NB_COLS:0] 	   tmp;
   assign tmp[0] = 0;
   //integer 			   activeavg, inactiveavg;
   logic 			   xg;
   
   genvar 			   i;
   generate
      for(i=0; i< NB_ROWS*NB_COLS; i++) begin
         assign tmp[i+1] = tmp[i] | End_Exec_I[i];
      end
   endgenerate
   always_comb begin
      Exec_Comp= tmp[NB_ROWS*NB_COLS];
   end  

   
   cgratop cgratop(
		   .Clk(Clk),
		   .DMA_Clk(DMA_Clk),
		   .Reset(Reset),
		   .Context_Fetch_En(Context_Fetch_En),
		   .End_Exec_O(End_Exec_I),
		   .Initn(Initn)
		   );
   initial begin
      Clk = '1;
      DMA_Clk = '1;
      xg = '1;
      Reset = '0;
      Initn = '0;
      Context_Fetch_En = '0;
      $display("Preloading TCDM memory");
      $readmemh("context1.hex", tb.cgratop.IM_BANK1.cut.Mem);
      $readmemh("context2.hex", tb.cgratop.IM_BANK2.cut.Mem);

      $display("Preloading TCDM memory");


/* -----\/----- EXCLUDED -----\/-----
      $readmemh("data.hex", tb.cgratop.genblk1[31].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[30].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[29].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[28].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[27].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[26].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[25].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[24].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[23].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[22].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[21].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[20].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[19].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[18].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[17].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[16].tcdm.cut.Mem);
 

      $readmemh("data.hex", tb.cgratop.genblk1[15].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[14].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[13].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[12].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[11].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[10].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[9].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[8].tcdm.cut.Mem);
 -----/\----- EXCLUDED -----/\----- */



/* -----\/----- EXCLUDED -----\/-----
      $readmemh("data.hex", tb.cgratop.genblk1[7].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[6].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[5].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[4].tcdm.cut.Mem);
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----

      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_31__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_30__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_29__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_28__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_27__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_26__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_17__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_16__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_25__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_24__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_23__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_22__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_21__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_20__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_19__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_18__tcdm.cut.Mem);

-----/\----- EXCLUDED -----/\----- */
/* -----\/----- EXCLUDED -----\/-----
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_15__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_14__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_13__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_12__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_11__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_10__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_9__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_8__tcdm.cut.Mem);
 -----/\----- EXCLUDED -----/\----- */
      
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_3__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_2__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_1__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_0__tcdm.cut.Mem);


      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_4__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_5__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_6__tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.TCDM.genblk1_7__tcdm.cut.Mem);

 
 
 
 
/* -----\/----- EXCLUDED -----\/-----
      $readmemh("data.hex", tb.cgratop.genblk1[3].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[2].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[1].tcdm.cut.Mem);
      $readmemh("data.hex", tb.cgratop.genblk1[0].tcdm.cut.Mem);
 -----/\----- EXCLUDED -----/\----- */
   end
   always #5 Clk = ~Clk;
   always #5 DMA_Clk = (~DMA_Clk) & xg;
   always #10 Reset = '1;
   always #40 Initn = '1;
   always #30 Context_Fetch_En = '1;
   always #1550 xg = '0;
/* -----\/----- EXCLUDED -----\/-----
   always #10 activeavg = (tb.cgratop.cgra.genblk1[0].genblk1[0].tile.active + 
			   tb.cgratop.cgra.genblk1[0].genblk1[1].tile.active +
			   tb.cgratop.cgra.genblk1[0].genblk1[2].tile.active +
			   tb.cgratop.cgra.genblk1[0].genblk1[3].tile.active +
			   tb.cgratop.cgra.genblk1[1].genblk1[0].tile.active +
			   tb.cgratop.cgra.genblk1[1].genblk1[1].tile.active +
			   tb.cgratop.cgra.genblk1[1].genblk1[2].tile.active +
			   tb.cgratop.cgra.genblk1[1].genblk1[3].tile.active +
			   tb.cgratop.cgra.genblk1[2].genblk1[0].tile.active +
			   tb.cgratop.cgra.genblk1[2].genblk1[1].tile.active +
			   tb.cgratop.cgra.genblk1[2].genblk1[2].tile.active +
			   tb.cgratop.cgra.genblk1[2].genblk1[3].tile.active +
			   tb.cgratop.cgra.genblk1[3].genblk1[0].tile.active +
			   tb.cgratop.cgra.genblk1[3].genblk1[1].tile.active +
			   tb.cgratop.cgra.genblk1[3].genblk1[2].tile.active +
			   tb.cgratop.cgra.genblk1[3].genblk1[3].tile.active )/16;
   
always #10 inactiveavg = (tb.cgratop.cgra.genblk1[0].genblk1[0].tile.inactive + 
			   tb.cgratop.cgra.genblk1[0].genblk1[1].tile.inactive +
			   tb.cgratop.cgra.genblk1[0].genblk1[2].tile.inactive +
			   tb.cgratop.cgra.genblk1[0].genblk1[3].tile.inactive +
			   tb.cgratop.cgra.genblk1[1].genblk1[0].tile.inactive +
			   tb.cgratop.cgra.genblk1[1].genblk1[1].tile.inactive +
			   tb.cgratop.cgra.genblk1[1].genblk1[2].tile.inactive +
			   tb.cgratop.cgra.genblk1[1].genblk1[3].tile.inactive +
			   tb.cgratop.cgra.genblk1[2].genblk1[0].tile.inactive +
			   tb.cgratop.cgra.genblk1[2].genblk1[1].tile.inactive +
			   tb.cgratop.cgra.genblk1[2].genblk1[2].tile.inactive +
			   tb.cgratop.cgra.genblk1[2].genblk1[3].tile.inactive +
			   tb.cgratop.cgra.genblk1[3].genblk1[0].tile.inactive +
			   tb.cgratop.cgra.genblk1[3].genblk1[1].tile.inactive +
			   tb.cgratop.cgra.genblk1[3].genblk1[2].tile.inactive +
			   tb.cgratop.cgra.genblk1[3].genblk1[3].tile.inactive )/16;			  
 -----/\----- EXCLUDED -----/\----- */
endmodule // tb
