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
// Module Name:    tile                                                       //
// Project Name:                                                              //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Tile                                                       //
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

module tile_ipa #(parameter AWIDTH = 4, parameter DWIDTH = 32, parameter INST_AWIDTH = 10, parameter NB_ROWS = 4, parameter NB_COLS = 4,
	      parameter INST_DWIDTH = 20)
   (
    input logic 			  Clk, Reset, DMA_Read_En, Exec_En_Global, Load_Store_Grant_I, Data_Req_Valid_I,
    input logic [(NB_ROWS*NB_COLS)-1 : 0] PE_Cond_In,
    input logic [DWIDTH-1:0] 		  PE_In_N, PE_In_S, PE_In_E, PE_In_W,
    input logic [22:0] 			  DMA_Addr_In,
    input logic [3:0] 			  Tile_Id, 
    input logic [63:0] 			  DMA_Data_In,
    input logic [(NB_ROWS*NB_COLS)- 1 : 0] Stall_In,
    output logic [31:0] 		  Load_Store_Addr_O, Store_Data_O,
    input logic [31:0] 			  Load_Data_I, 
    output logic [DWIDTH-1:0] 		  PE_Out_N, PE_Out_S, PE_Out_E, PE_Out_W,
    output logic 			  PE_Cond_Out, End_Exec_O, Load_Store_Req_O, Load_Store_Data_Req_O, Stall_Out
    );
   logic [DWIDTH-1:0] 			ALU_In0, ALU_In1,ALU_Out_reg,
					ALU_Out, PE_In_RF_0, PE_In_RF_1, PE_In_CRF_0, PE_In_CRF_1;

   logic 				Exec_En, Clock_Gate_En_O, self_clock_gate_en, Load_Store_Req_Out, Load_Store_Data_Req_Out, Load_Store_Req, Load_Store_Data_Req;

   //logic [3:0] 				Tile_Id_Reg;
   logic                                ldstraddr_init;
   
   logic [4:0] 				Read_Addr_CRF_0, Read_Addr_CRF_1;
   
   logic [4:0] 				Opcode;
   
   logic 				Write_En_RF, Read_En_CRF_1, Read_En_CRF_0;
   
   logic [2:0] 				Write_Addr_RF;
   
   logic [19:0] 			Inst_Data_reg;
   
   logic [19:0] 			Inst_Data;   
   
   logic [6:0] 				Inst_Addr;

   logic 				Write_En_IM, Write_En_CRF, ALU_En, Counter_En;

   logic 				Global_Cond, Global_Stall;
   
   logic [(NB_ROWS*NB_COLS)-1:0] 	PE_Cond_In_Reg;

   logic [4:0] 				Count_Nop;

   logic 				Halt_Reg, gated_clk;

   logic 				ls_active, end_exec;
   logic [31:0] 			alu_out_prev, load_data, load_store_addr;

   logic 				exec;
   
/* -----\/----- EXCLUDED -----\/-----
   always @ (Clk) 
     begin
	if (!Clk) begin
	   en_out = enable; // build latch     
	end
     end
 -----/\----- EXCLUDED -----/\----- */

   integer 				active, inactive;
   

/* -----\/----- LSU -----\/-----*/
   always_ff @(posedge Clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   exec <= 0;
	end else if(Exec_En_Global==1'b1) begin
	   exec <= 1;
	end else if (End_Exec_O == 1'b1) begin
	   exec <=0;
	end
     end
   
    always_ff @(posedge Clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   Load_Store_Req <= '0;
	   Load_Store_Data_Req<= '0;
	   load_store_addr <= '0;
	   ldstraddr_init <= 0;
	end
	else
	  begin
	     Load_Store_Req <= Load_Store_Req_Out;
	     Load_Store_Data_Req <= Load_Store_Data_Req_Out;
	     load_data <= Load_Data_I;
	     load_store_addr <= Load_Store_Addr_O;
	     ldstraddr_init <= Load_Store_Req_Out == 1 ? 1 : 0;
	     
	  end
     end // always_ff @ (posedge Clk or negedge Reset)
   
   always_ff @(posedge Clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   active <= 0;
	   inactive <= 0;
	   ALU_En <= '0;
	   Halt_Reg <= '1;
	   //Load_Store_Req_O <= '0;
	   //Load_Store_Data_Req_O<= '0;
	   Load_Store_Req_Out <= '0;
	   Load_Store_Data_Req_Out <= '0;
	   end_exec <= 1'b1;
	   End_Exec_O <= 1'b0;
	   ALU_Out_reg <= '0 ;
	   alu_out_prev <= '0;
	  
	   
	   
	end else if (exec==1'b1) begin

	   if( End_Exec_O == '0) begin
	      if((Clock_Gate_En_O & (!Global_Stall)) == '1) begin
		 active <= active + 1;
	      end else begin
		 inactive <= inactive + 1;
	      end
	   end

	   ALU_En <= 1 & (!Global_Stall);
	   ALU_Out_reg <=  (Data_Req_Valid_I == '1) ? Load_Data_I : ALU_Out;
	   alu_out_prev <= (Data_Req_Valid_I == '1) ? Load_Data_I : ALU_Out;
	   
	  if(Inst_Data[4:0] == 5'b11111) begin
	     End_Exec_O <= 1'b1;
	     end_exec <= 1'b0;	     
	   end
	   if((Inst_Data[4:0] == 5'b00111) && Clock_Gate_En_O == '1 && Load_Store_Grant_I == '0 ) begin // && Load_Store_Grant_I == '0  && Global_Stall != '1
	      Load_Store_Req_Out <= 1'b1;
	      Load_Store_Data_Req_Out <= 1'b1;
	      
	      
	      
	   end else if(Inst_Data[4:0] == 5'b01001   && Clock_Gate_En_O == '1 && Load_Store_Grant_I == '0  ) begin//Load_Store_Grant_I == '0 &&
	      Load_Store_Req_Out <= 1'b1;
	      Load_Store_Data_Req_Out <= 1'b0;
              
	      
	      
	   end else if(Load_Store_Grant_I == '1) begin//Data_Req_Valid_I
	      Load_Store_Data_Req_Out <= '0;
	      Load_Store_Req_Out <= '0;
	      
	      
	      
	   end  
	end else begin
	   ALU_En <= '0;
	end
     end // always_ff @ (posedge Clk or negedge Reset)


  /* -----\/----- PEController -----\/----- */
   
   always_ff @(posedge gated_clk or negedge Reset)
     begin
	if(Reset == 1'b0) begin
	   
	   Write_En_IM <= '0;

	   Write_En_CRF <= '0;
	   
	   Inst_Data_reg <= '0;

	   Exec_En <= '0;
	   
	   Inst_Addr <= '0;	   
	   

	end else if (exec ==1'b1 && Clock_Gate_En_O == '1) begin

           Exec_En <= 1'b1;
	   
	   Write_En_IM <= 1'b0;

           Write_En_CRF <= 1'b0;  
	   
	    
	   PE_Cond_In_Reg<= PE_Cond_In;


	   if(((Global_Stall != '1))) begin
	      Inst_Data_reg <= Inst_Data;
	      Inst_Addr <= (Inst_Data[4:0]==5'b11110) ? '0 : ((Inst_Data[4:0]==5'b10100)||((Inst_Data[4:0]==5'b10011) && (Global_Cond==1'b1))) ? Inst_Data[11:5] : ((Inst_Data[4:0]==5'b10011) && (Global_Cond==1'b0)) ? Inst_Data[18:12] : Inst_Addr+1;
	   end
	end else begin
           Write_En_IM <= 1'b0;

           Write_En_CRF <= 1'b0;

	  

	   
	end // else: !if(Exec_En_Global==1'b1
	
     end // always_ff @
   

   always@( * ) begin
      if (exec == 1'b1) begin
	 PE_Out_N <= ALU_Out_reg;
	 
	 PE_Out_S <= ALU_Out_reg;
	 
	 PE_Out_E <= ALU_Out_reg;
	 
	 PE_Out_W <= ALU_Out_reg;	

	 Opcode <= Inst_Data_reg[4:0];

	 self_clock_gate_en = (Inst_Data[4:0]==5'b11110) ? '1 : '0; 
	 
	 Write_En_RF <= ((Inst_Data_reg[6:5] == 2'b00) || ((Inst_Data_reg[4:0]==5'b00000) || (Inst_Data_reg[4:0]==5'b10011) ||(Inst_Data_reg[4:0]==5'b10100))) ? 1'b0 : 1'b1;
	 
	 Write_Addr_RF <=  Inst_Data_reg[9:7];
	 
	 Read_Addr_CRF_0 <= Inst_Data_reg[14:11];
	 
	 Read_Addr_CRF_1 <= Inst_Data_reg[19:16];
	 
	 Read_En_CRF_0 <= Inst_Data_reg[10];

	 Read_En_CRF_1 <= Inst_Data_reg[15];

	 ALU_In0 <= (Read_En_CRF_0  == 0) && (Read_Addr_CRF_0 == 4'b1001) ? PE_In_N:
		     (Read_En_CRF_0  == 0) && (Read_Addr_CRF_0 == 4'b1010) ? PE_In_S:
		     (Read_En_CRF_0  == 0) && (Read_Addr_CRF_0 == 4'b1011) ? PE_In_E:
	   	     (Read_En_CRF_0  == 0) && (Read_Addr_CRF_0 == 4'b1100) ? PE_In_W:
		     (Read_En_CRF_0  == 1) ? PE_In_CRF_0 : PE_In_RF_0;
	 
	 ALU_In1 <= (Read_En_CRF_1  == 0) && (Read_Addr_CRF_1 == 4'b1001) ? PE_In_N:
		   (Read_En_CRF_1  == 0) && (Read_Addr_CRF_1 == 4'b1010) ? PE_In_S:
		   (Read_En_CRF_1  == 0) && (Read_Addr_CRF_1 == 4'b1011) ? PE_In_E:
	   	   (Read_En_CRF_1  == 0) && (Read_Addr_CRF_1 == 4'b1100) ? PE_In_W:
		   (Read_En_CRF_1  == 1) ? PE_In_CRF_1 : PE_In_RF_1;

	 if((Inst_Data[4:0] == 5'b00000 && (Inst_Data[9:5]>5'b00001) && (Global_Stall != '1))) begin
	    Count_Nop <= Inst_Data[9:5] -1;
	    Counter_En <= '1;
	 end else begin
	    Counter_En <= '0;
	    Count_Nop <= '0;
	 end

	 Store_Data_O <= ALU_In0;
	 Load_Store_Addr_O <= (ldstraddr_init == 0 && Load_Store_Req_Out == 1) ? ALU_In1<<2  : load_store_addr;
	 Stall_Out <= Load_Store_Req_O ; //Load_Store_Data_Req_O ^ Data_Req_Valid_I;Load_Store_Grant_I ^ ^ Data_Req_Valid_I ^ Load_Store_Grant_I
//(Data_Req_Valid_I ^ (Load_Store_Req_O))| Data_Req_Valid_I   ;//^ Data_Req_Valid_I; Load_Store_Grant_I; | Data_Req_Valid_I


      end else begin // if (Exec_En==1'b1)
	 PE_Out_N <= '0;
	 
	 PE_Out_S <= '0;
	 
	 PE_Out_E <= '0;
	 
	 PE_Out_W <= '0;	

	 Opcode <= '0;
	 
	 Write_En_RF <= '0;
	 
	 Write_Addr_RF <='0;
	
	 self_clock_gate_en = '0;
	   
	 Read_Addr_CRF_0 <= '0;
	 
	 Read_Addr_CRF_1 <= '0;
	 
	 Read_En_CRF_0 <= '0;

	 Read_En_CRF_1 <= '0;

	 
	 Store_Data_O <=  '0;
	 Load_Store_Addr_O <= '0;
	 Stall_Out <= 1'b0;
	 ALU_In1 <= '0;
	 ALU_In0 <= '0;
	 ls_active <= '0;
	 Counter_En <= '0;
	 Count_Nop <= '0;
	
      end // else: !if(Exec_En_Global==1'b1)

   end
   assign Load_Store_Data_Req_O = Load_Store_Data_Req_Out; //Load_Store_Data_Req | Load_Store_Data_Req_Out;
   assign Load_Store_Req_O      = Load_Store_Req_Out; //Load_Store_Req_Out | Load_Store_Req;

   
   constantregfile_pe constantregfile_pe(
				   .Clk(gated_clk),
				   .Reset(Reset),
				   .In_Const(DMA_Data_In),
				   .Write_En((DMA_Addr_In[Tile_Id] == 1'b1) && (DMA_Addr_In[16] == 1) ? DMA_Read_En : 1'b0),
				   .Read_En_CRF_0(Read_En_CRF_0),
				   .Read_Addr_CRF_0(Read_Addr_CRF_0),
				   .Read_Data_CRF_0(PE_In_CRF_0),
				   .Read_En_CRF_1(Read_En_CRF_1),
				   .Read_Addr_CRF_1(Read_Addr_CRF_1),
				   .Read_Data_CRF_1(PE_In_CRF_1),
				   .Write_Addr(DMA_Addr_In[20:17])	      
				   );
   
   regfile_pe regfile_pe(
		   .Clk(Clk),
		   .Reset(Reset), 
		   .Read_En0(!Read_En_CRF_0), 
		   .Read_En1(!Read_En_CRF_1), 
		   .Write_En(Write_En_RF & (!Global_Stall)),
		   .Read_Addr0(Read_Addr_CRF_0[2:0]), 
		   .Read_Addr1(Read_Addr_CRF_1[2:0]), 
		   .Write_Addr(Write_Addr_RF),
		   .Read_Data0(PE_In_RF_0), 
		   .Read_Data1(PE_In_RF_1), 
		   .Write_Data(ALU_Out)
		   );

   instmem_pe instmem_pe(
		   .Clk(gated_clk),
		   .Reset(Reset),
		   .exec_en(exec),
		   .Write_En((DMA_Addr_In[Tile_Id] == 1'b1) && (DMA_Addr_In[16] == 0) ? DMA_Read_En : 1'b0),
		   .In_Inst(DMA_Data_In),
		   .Inst_Addr(Inst_Addr),
		   .Inst_Data(Inst_Data),
		   .Write_Addr(DMA_Addr_In[22:17])
		   );

   
   
   alu_pe alu_pe(
	    .Clk(Clk),
	   .Reset(Reset),
	   .ALU_En(1),
	   .alu_in_prev(alu_out_prev),
	   .Exec_En_Global(exec),
	   .load_data_i(Load_Data_I),
	   .data_req_valid_i (Data_Req_Valid_I),
	   .ALU_In0(ALU_In0),
	   .ALU_In1(ALU_In1),
	   .Opcode(Opcode),
	   .ALU_Out(ALU_Out),
	   .ALU_Cond(PE_Cond_Out)
              );


   orcond #(NB_ROWS, NB_COLS) orcond_pe(
		   .In_Cond(PE_Cond_In),
		   .Out_Cond(Global_Cond)
		   );
   orcond #(NB_ROWS, NB_COLS) orstall_pe(
				      .In_Cond(Stall_In),
				      .Out_Cond(Global_Stall)
				      );
   
   
   counter_pe counter_pe(
		      .Clk(Clk),
		      .Reset(Reset),
		      .Counter_En(Counter_En),
		      .Global_Stall_I(Global_Stall),
		      .Clock_Gate_En_O(Clock_Gate_En_O),
		      .Data_In(Count_Nop)
		      );

/* -----\/----- EXCLUDED -----\/-----
   cluster_clock_gating clk_gate(
				 .clk_i(Clk),
				 .en_i(!Global_Stall),
				 .test_en_i(1'b0),
				 .clk_o(gated_clk)
				 );
 -----/\----- EXCLUDED -----/\----- */


   cgra_clock_gating counter_gate_pe(
				     .clk_i(Clk),
				     .en_i((!Global_Stall) || Clock_Gate_En_O),
				     .test_en_i(1'b0),
				     .clk_o(gated_clk)   
				     );
   

   
endmodule

