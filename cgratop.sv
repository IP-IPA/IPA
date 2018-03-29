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
// Module Name:    cgratop                                                    //
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
module cgratop
  #(parameter NB_ROWS = 4, parameter NB_COLS = 4)
(
 input logic 				Clk, DMA_Clk, Reset, Context_Fetch_En, Initn,
 output logic [(NB_ROWS*NB_COLS)-1 : 0] End_Exec_O
 );
   localparam Num_Slaves = 16;
   
   logic 				DMA_Write_En_Out, DMA_Exec_En_Out;
   logic [63:0] 			DMA_Data_Out;
   logic [20:0] 			DMA_Addr_Out;
   logic [63:0] Context_Data;
   logic [9:0] Context_Addr;
   logic [(NB_ROWS*NB_COLS)-1 : 0] [31:0] Load_Data_I;
   logic [(NB_ROWS*NB_COLS)-1 : 0] [31:0] Load_Store_Addr_O;
   logic [(NB_ROWS*NB_COLS)-1 : 0] [31:0] Store_Data_O;
   logic [(NB_ROWS*NB_COLS)-1:0] 	  Load_Store_Req_O;
   logic [(NB_ROWS*NB_COLS)-1:0] 	  Load_Store_Data_Req_O;
   logic [(NB_ROWS*NB_COLS)-1:0] 	  Load_Store_Grant_I;
   logic [(NB_ROWS*NB_COLS)-1:0] 	  Data_Req_Valid_I;
   
   logic [Num_Slaves-1:0][31:0] 	  data_wdata_o;
   logic [Num_Slaves-1:0][31:0] 	  data_r_rdata_i;
   logic [Num_Slaves-1:0][9:0] 		  data_add_o;
   logic [Num_Slaves-1:0] 		  data_wen_o;
   logic [Num_Slaves-1:0][15:0] 	  data_id;
   logic [Num_Slaves-1:0][15:0] 	  data_id_i;
   logic [Num_Slaves-1:0] 		  data_req_o;
   logic [Num_Slaves-1:0] 		  data_gnt_i;
   logic [Num_Slaves-1:0] 		  data_r_valid_i;

  
   always@(posedge Clk or negedge Reset) begin
      if(Reset == 1'b0) begin
	 data_id_i <= '0;
	 data_r_valid_i <= '0;
	 data_gnt_i <= 32'hffffffff;
      end else begin
	 data_id_i <= data_id;
	 data_r_valid_i <=  data_req_o;	 
      end
   end
  
/* -----\/----- EXCLUDED -----\/-----
   contextmemory contextmemory(
			       .Context_Addr(Context_Addr),
			       .Context_Data(Context_Data)
			       );
 -----/\----- EXCLUDED -----/\----- */

   st_tcdm_bank_1024x32 IM_BANK1(
				 .CLK(Clk),
				 .RSTN(Reset),
				 .INITN(Reset),
				 .STDBY('0),
				 .CSN(DMA_Exec_En_Out),
				 .WEN(1'b1),
				 .WMN('0),
				 .RM(4'h0),
				 .WM(4'h0),
				 .HS('1), // high Speed
				 .LS('0), // low Speed
				 .A(Context_Addr),
				 .D(),
				 .Q(Context_Data[63:32]),
				 .TM(1'b0)
				 );
   st_tcdm_bank_1024x32 IM_BANK2(
				 .CLK(Clk),
				 .RSTN(Reset),
				 .INITN(Reset),
				 .STDBY('0),
				 .CSN(DMA_Exec_En_Out),
				 .WEN(1'b1),
				 .WMN('0),
				 .RM(4'h0),
				 .WM(4'h0),
				 .HS('1), // high Speed
				 .LS('0), // low Speed
				 .A(Context_Addr),
				 .D(),
				 .Q(Context_Data[31:0]),
				 .TM(1'b0)
				 );
 
   
   
   dma_ipa #(4, 4) dma_ipa(
	   .Clk(Clk),
	   .Reset(Reset),
	   .Context_Fetch_En(Context_Fetch_En),
	   .In_Data(Context_Data),
	   .Context_Addr(Context_Addr),
	   .Out_Data(DMA_Data_Out),
	   .Out_Addr(DMA_Addr_Out),
	   .Exec_En_Out(DMA_Exec_En_Out),
	   .Write_En(DMA_Write_En_Out)
	   );
   cgra #(4, 4, 32) cgra(
	     .Clk(Clk),
	     .Reset(Reset),
	     .DMA_Read_En(DMA_Write_En_Out),
	     .DMA_Addr_In(DMA_Addr_Out),
	     .DMA_Data_In(DMA_Data_Out),
	     .Exec_En(DMA_Exec_En_Out),
	     .Load_Data_I(Load_Data_I),
	     .Load_Store_Addr_O(Load_Store_Addr_O),
	     .Load_Store_Req_O(Load_Store_Req_O),
	     .Load_Store_Data_Req_O(Load_Store_Data_Req_O),
	     .End_Exec_O(End_Exec_O),
	     .Load_Store_Grant_I(Load_Store_Grant_I),  
	     .Data_Req_Valid_I(Data_Req_Valid_I),
	     .Store_Data_O(Store_Data_O)
	     ); 
   XBAR_TCDM #( .N_CH0(NB_ROWS*NB_COLS), 
		.N_CH1(0),  
		.N_SLAVE(Num_Slaves),
		.ADDR_WIDTH(32),
		.DATA_WIDTH(32),
		.ADDR_MEM_WIDTH(10)
		) XBAR_TCDM( 
		        .data_req_i(Load_Store_Data_Req_O), 
			.data_add_i(Load_Store_Addr_O),
                        .data_wen_i(Load_Store_Req_O),            // Data request type : 0--> Store, 1 --> Load
			.data_wdata_i(Store_Data_O),          // Data request Write data
			.data_be_i(64'hffffffffffffffff),             // Data request Byte enable
			.data_gnt_o(Load_Store_Grant_I),            // Grant Incoming Request
			.data_r_valid_o(Data_Req_Valid_I),        // Data Response Valid (For LOAD/STORE commands)
			.data_r_rdata_o(Load_Data_I),        // Data Response DATA (For LOAD commands)
			.data_req_o(data_req_o),            // Data request
			.data_ts_set_o(),         // Current Request is a SET during a test&set
			.data_add_o(data_add_o),            // Data request Address
			.data_wen_o(data_wen_o),            // Data request type : 0--> Store, 1 --> Load
			.data_wdata_o(data_wdata_o),          // Data request Wrire data
			.data_be_o(),             // Data request Byte enable 
			.data_ID_o(data_id),             // Data request Byte enable 
			.data_gnt_i(data_req_o),            // Grant In
			.data_r_rdata_i(data_r_rdata_i),        // Data Response DATA (For LOAD commands)
			.data_r_valid_i(data_r_valid_i),        // Valid Response 
			.data_r_ID_i(data_id_i),          // ID Response
			.clk(Clk),
			.rst_n(Reset)
			      );
    genvar k;
   TCDM #(.Num_Slaves(Num_Slaves)) TCDM(.Clk(Clk),
				       .Reset(Reset),
				       .Initn(Initn),
				       .data_req_o(data_req_o),
				       .data_wen_o(data_wen_o),
				       .data_add_o(data_add_o),
				       .data_wdata_o(data_wdata_o),
				       .data_r_rdata_i(data_r_rdata_i)
				       );
   
     
/* -----\/----- EXCLUDED -----\/-----
    generate
    for (k=0; k <  Num_Slaves; k++)
    begin
       st_tcdm_bank_1024x32 tcdm(
			     .CLK(Clk),
			     .RSTN(Reset),
			     .INITN(Initn),
			     .STDBY('0),
			     .CSN(!data_req_o[k]),
			     .WEN(data_wen_o[k]),
			     .WMN('0),
			     .RM(4'h0),
			     .WM(4'h0),
			     .HS('1), // high Speed
			     .LS('0), // low Speed
			     .A(data_add_o[k]),
			     .D(data_wdata_o[k]),
			     .Q(data_r_rdata_i[k]),
			     .TM(1'b0)
			     );
    end // for (k=0; k<2*(NB_ROWS*NB_COLS); k++)
    endgenerate
 -----/\----- EXCLUDED -----/\----- */
   
endmodule // top
module TCDM #(parameter Num_Slaves = 4)(input logic Clk, Reset, Initn, 
					input logic [Num_Slaves-1:0] 	    data_req_o,
					input logic [Num_Slaves-1:0] 	    data_wen_o,
					input logic [Num_Slaves-1:0][9:0]   data_add_o, 
					input logic [Num_Slaves-1:0][31:0]  data_wdata_o,
					output logic [Num_Slaves-1:0][31:0] data_r_rdata_i);

   genvar 								    k;
 generate
    for (k=0; k <  Num_Slaves; k++)
    begin
       st_tcdm_bank_1024x32 tcdm(
			     .CLK(Clk),
			     .RSTN(Reset),
			     .INITN(Initn),
			     .STDBY('0),
			     .CSN(!data_req_o[k]),
			     .WEN(data_wen_o[k]),
			     .WMN('0),
			     .RM(4'h0),
			     .WM(4'h0),
			     .HS('1), // high Speed
			     .LS('0), // low Speed
			     .A(data_add_o[k]),
			     .D(data_wdata_o[k]),
			     .Q(data_r_rdata_i[k]),
			     .TM(1'b0)
			     );
    end // for (k=0; k<2*(NB_ROWS*NB_COLS); k++)
    endgenerate

  
endmodule // TCDM

