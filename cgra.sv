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
// Module Name:    CGRA                                                       //
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
////////////////////////////////////////////////////////////////////////////////
module cgra 
  #(
    parameter NB_ROWS = 4, 
    parameter NB_COLS=4, 
    parameter DATA_WIDTH = 32, 
    parameter NB_LS = 16
    )
   (
    input logic 				  Clk, Reset, DMA_Read_En, Exec_En,
    input logic [(NB_ROWS*NB_COLS)-1:0] 	  Load_Store_Grant_I, Data_Req_Valid_I,
    input logic [63:0] 				  DMA_Data_In, 
    input logic [22:0] 				  DMA_Addr_In,
    input logic [(NB_LS)-1 : 0] [DATA_WIDTH-1:0]  Load_Data_I,
    output logic [(NB_LS)-1 : 0] [DATA_WIDTH-1:0] Load_Store_Addr_O,
    output logic [(NB_ROWS*NB_COLS)-1 : 0] 	  End_Exec_O,
    output logic [(NB_LS)-1:0] 			  Load_Store_Req_O, Load_Store_Data_Req_O,
    output logic [(NB_LS)-1 : 0] [DATA_WIDTH-1:0] Store_Data_O
    );

   logic [(NB_ROWS-1) : 0][(NB_COLS-1):0][DATA_WIDTH-1:0] PE_Out_N;
   logic [(NB_ROWS-1) : 0][(NB_COLS-1):0][DATA_WIDTH-1:0] PE_Out_S;
   logic [(NB_ROWS-1) : 0][(NB_COLS-1):0][DATA_WIDTH-1:0] PE_Out_E;
   logic [(NB_ROWS-1) : 0][(NB_COLS-1):0][DATA_WIDTH-1:0] PE_Out_W;
   logic [(NB_ROWS*NB_COLS)-1 : 0] 			  PE_Cond_Out;
   logic [(NB_ROWS*NB_COLS)-1 : 0][3:0] 		  tile_id;	
   logic [(NB_ROWS*NB_COLS)-1 : 0] 			  Stall_Out;
   
   genvar 						  i, j;

   
   
   generate
      for (i = 0; i< NB_ROWS; i++) begin
	 for (j = 0; j< NB_COLS; j++) begin
	    assign tile_id[i*NB_ROWS + j] = i*NB_ROWS + j;
	    if (1) begin
	       
	       tile_ipa #(4, 32, 10, NB_ROWS, NB_COLS, 20)  tile_i (
							      .Clk(Clk),
							      .Reset(Reset),
							      .Load_Store_Grant_I(Load_Store_Grant_I[i*NB_ROWS + j]),
							      .Data_Req_Valid_I(Data_Req_Valid_I[i*NB_ROWS + j]),
							      .Tile_Id(tile_id[i*NB_ROWS + j]),
							      .PE_In_N(PE_Out_S[(NB_ROWS+i-1)%NB_ROWS][j]),
							      .PE_In_S(PE_Out_N[(i+1)%NB_ROWS][j]),
							      .PE_In_E(PE_Out_W[i][(j+1)%NB_COLS]),
							      .PE_In_W(PE_Out_E[i][(NB_COLS+j-1)%NB_COLS]),
							      .PE_Out_N(PE_Out_N[i][j]),
							      .PE_Out_S(PE_Out_S[i][j]),
							      .PE_Out_E(PE_Out_E[i][j]),
							      .PE_Out_W(PE_Out_W[i][j]),
							      .PE_Cond_Out(PE_Cond_Out[i*NB_ROWS + j]),
							      .PE_Cond_In(PE_Cond_Out),	
							      .DMA_Read_En(DMA_Read_En),
							      .DMA_Data_In(DMA_Data_In),
							      .DMA_Addr_In(DMA_Addr_In),
							      .Exec_En_Global(Exec_En),
							      .Load_Data_I (Load_Data_I[i*NB_ROWS + j]),
							      .Store_Data_O(Store_Data_O[i*NB_ROWS + j]),
							      .Load_Store_Addr_O(Load_Store_Addr_O[i*NB_ROWS + j]),
							      .Load_Store_Req_O(Load_Store_Req_O[i*NB_ROWS + j]),
							      .Load_Store_Data_Req_O(Load_Store_Data_Req_O[i*NB_ROWS + j]),
							      .End_Exec_O(End_Exec_O[i*NB_ROWS + j]),
							      .Stall_In(Stall_Out),
							      .Stall_Out(Stall_Out[i*NB_ROWS + j])
							      );
	    end else begin // if (i*NB_ROWS < NB_LS)
	       
	       tile_ipa #(4, 32, 10, NB_ROWS, NB_COLS, 20)  tile_i (
							      .Clk(Clk),
							      .Reset(Reset),
							      .Tile_Id(tile_id[i*NB_ROWS + j]),
							      .PE_In_N(PE_Out_S[(NB_ROWS+i-1)%NB_ROWS][j]),
							      .PE_In_S(PE_Out_N[(i+1)%NB_ROWS][j]),
							      .PE_In_E(PE_Out_W[i][(j+1)%NB_COLS]),
							      .PE_In_W(PE_Out_E[i][(NB_COLS+j-1)%NB_COLS]),
							      .PE_Out_N(PE_Out_N[i][j]),
							      .PE_Out_S(PE_Out_S[i][j]),
							      .PE_Out_E(PE_Out_E[i][j]),
							      .PE_Out_W(PE_Out_W[i][j]),
							      .PE_Cond_Out(PE_Cond_Out[i*NB_ROWS + j]),
							      .PE_Cond_In(PE_Cond_Out),	
							      .DMA_Read_En(DMA_Read_En),
							      .DMA_Data_In(DMA_Data_In),
							      .DMA_Addr_In(DMA_Addr_In),
							      .Exec_En_Global(Exec_En),
							      .Load_Data_I ('0),
							      .Store_Data_O(),
							      .Load_Store_Addr_O(),
							      .Load_Store_Req_O(),
							      .Load_Store_Data_Req_O(),
							      .End_Exec_O(End_Exec_O[i*NB_ROWS + j]),
							      .Stall_In(Stall_Out),
							      .Stall_Out(Stall_Out[i*NB_ROWS + j])
							      );
	    end // else: !if(i*NB_ROWS < NB_LS)
	    
            
	 end // for (j = 0; j< NB_COLS; j++)
      end // for (i = 0; i< NB_ROWS; i++)
   endgenerate   
endmodule // cgra
