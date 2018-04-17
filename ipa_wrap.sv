`include "pulp_soc_defines.sv"
`define GNT_BASED_FC
module ipa_wrap
#(
   parameter ADDR_MEM_WIDTH=12,
   parameter DATA_WIDTH=32,
   parameter BE_WIDTH=4,
   parameter ADDR_WIDTH=32,
   parameter TEST_SET_BIT = 20,
   parameter NB_ROWS = 4,
   parameter NB_COLS = 4,
   parameter IPA_GCM_ID_WIDTH = 20,
   parameter NB_GCM_BANKS = 2,
   parameter NB_LS = 16 // top two rows
)
(
   input  logic               clk,
   input  logic               rst_n,
   TCDM_BANK_MEM_BUS.Master tcdm_ipa_sram_master[1:0],
   XBAR_TCDM_BUS.Slave        dma_ipa_xbar_slave[3:0],
   XBAR_TCDM_BUS.Master       ipa_xbar_master[NB_LS-1:0],
   XBAR_PERIPH_BUS.Slave      ipa_cfg_slave,
   output logic               busy_o,
   input logic [1:0]          TCDM_arb_policy_ipa_i
);

  
   

  
   
   logic [31:0] 	      ipa_cgf_command, ipa_cgf_status;
   
  
   logic [NB_LS-1:0]          tcdm_req;
   logic [NB_LS-1:0]          tcdm_gnt;
   logic [NB_LS-1:0] [32-1:0] tcdm_add;
   logic [NB_LS-1:0]          tcdm_type;
   logic [NB_LS-1:0] [4 -1:0] tcdm_be;
   logic [NB_LS-1:0] [32-1:0] tcdm_wdata;
   logic [NB_LS-1:0] [32-1:0] tcdm_r_rdata;
   logic [NB_LS-1:0]          tcdm_r_valid;
   logic 		      context_fetch_en, busy_ipac;


   logic [3:0][DATA_WIDTH-1:0]              s_dma_ipa_bus_wdata;
   logic [3:0][ADDR_WIDTH-1:0]              s_dma_ipa_bus_add;
   logic [3:0]                              s_dma_ipa_bus_req;
   logic [3:0]                              s_dma_ipa_bus_wen;
   logic [3:0][BE_WIDTH-1:0]                s_dma_ipa_bus_be;
   logic [3:0]                              s_dma_ipa_bus_gnt;
   logic [3:0][DATA_WIDTH-1:0]              s_dma_ipa_bus_r_rdata;
   logic [3:0]                              s_dma_ipa_bus_r_valid;

    // LOGARITHMIC INTERCONNECT --> SRAM TCDM BUS SIGNALS
   logic [1:0][DATA_WIDTH-1:0]          s_tcdm_bus_sram_wdata;
   logic [1:0][ADDR_MEM_WIDTH-1:0]      s_tcdm_bus_sram_add;
   logic [1:0]                          s_tcdm_bus_sram_req;
   logic [1:0]                          s_tcdm_bus_sram_wen;
   logic [1:0][BE_WIDTH-1:0]            s_tcdm_bus_sram_be;
   logic [1:0][IPA_GCM_ID_WIDTH-1:0]    s_tcdm_bus_sram_ID;
   logic [1:0][DATA_WIDTH-1:0]          s_tcdm_bus_sram_rdata;
   logic [1:0]                          s_tcdm_bus_sram_rvalid;
   logic [1:0][IPA_GCM_ID_WIDTH-1:0]    s_tcdm_bus_sram_rID;
   logic [1:0]                          s_data_ts_set_int;
   logic [1:0] 			        s_data_ts_set_q;


   logic [1:0] 				ipa_gcm_req;
   
   logic [1:0] 				ipa_gcm_wen;
   
   logic [1:0][ADDR_MEM_WIDTH-1:0] 	gcm_req_Addr;
   
   genvar j;

   logic [DATA_WIDTH-1:0] s_ipa_cfg_wdata;
   logic [ADDR_WIDTH-1:0] s_ipa_cfg_add;
   logic      		  s_ipa_cfg_req;
   logic  		  s_ipa_cfg_wen;
   logic [BE_WIDTH-1:0]   s_ipa_cfg_be;
   logic  		  s_ipa_cfg_gnt;
   logic [4:0] 	          s_ipa_cfg_id;
   logic [DATA_WIDTH-1:0] s_ipa_cfg_rdata;
   logic  		  s_ipa_cfg_valid;
   logic [4:0] 	          s_ipa_cfg_r_id;

   logic                  ipa_gcm_req_o;


logic s_ipa_cfg_gnt_fasttoslow, s_ipa_cfg_valid_fasttoslow;
always_ff @(posedge clk or negedge rst_n) begin
   if(rst_n == 0) begin
      s_ipa_cfg_gnt_fasttoslow <= 0;
      s_ipa_cfg_valid_fasttoslow <= 0;
      
   end else begin
      s_ipa_cfg_gnt_fasttoslow <= s_ipa_cfg_gnt;
      s_ipa_cfg_valid_fasttoslow <= s_ipa_cfg_valid;
      
   end
end // always_ff @ (posedge clk or negedge rst_n)

   assign s_ipa_cfg_add     = ipa_cfg_slave.add;
   assign s_ipa_cfg_req     = ipa_cfg_slave.req;
   assign s_ipa_cfg_wdata   = ipa_cfg_slave.wdata;
   assign s_ipa_cfg_wen     = ipa_cfg_slave.wen;
   assign s_ipa_cfg_be      = ipa_cfg_slave.be;
   assign s_ipa_cfg_id      = ipa_cfg_slave.id;
	   
   assign ipa_cfg_slave.gnt     = s_ipa_cfg_gnt | s_ipa_cfg_gnt_fasttoslow;
   assign ipa_cfg_slave.r_opc   = 'b0;
   assign ipa_cfg_slave.r_valid = s_ipa_cfg_valid | s_ipa_cfg_valid_fasttoslow;
   assign ipa_cfg_slave.r_rdata = s_ipa_cfg_rdata;//32'hdeadbeef;
   assign ipa_cfg_slave.r_id    = s_ipa_cfg_r_id;//'0;

   logic [NB_ROWS*NB_COLS:0] tmp;
   logic [(NB_ROWS*NB_COLS)-1:0] end_exec_o;
   assign tmp[0] = 0;
  
   logic 			   ipa_exec_complete;
   
   genvar 			   index;
   logic [31:0] 		   command_reg, status_reg;
   logic [4:0] 	id_reg;
   
   generate
      for(index=0; index< NB_ROWS*NB_COLS; index++) begin
         assign tmp[index+1] = tmp[index] | end_exec_o[index];
      end
   endgenerate
   
    always_comb begin
      ipa_exec_complete= (tmp[NB_ROWS*NB_COLS]==1) ? 1 : 0;
   end
   always_ff @(posedge clk or negedge rst_n) begin
      if(rst_n == '0) begin
	 busy_o <= '0;
      end else if(context_fetch_en == 1) begin
	 busy_o <= '1;
      end else if(ipa_exec_complete == 1) begin
	 busy_o <= '0;
      end
   end
   
   
   always_ff @(posedge clk or negedge rst_n) begin
     if(rst_n == '0) begin
	context_fetch_en <= '0;
	
     end else if(s_ipa_cfg_rdata == 2) begin
	context_fetch_en <= '1;
	
     end else if(s_ipa_cfg_rdata == 0) begin
	context_fetch_en <= '0;
     end 
   end
   
   generate
      for (j=0;j<4;j++) begin 
         assign s_dma_ipa_bus_wdata[j]   = ipa_gcm_req[0] == 1 ? '0 : dma_ipa_xbar_slave[j].wdata;
         assign s_dma_ipa_bus_add[j]     = ipa_gcm_req[0] == 1 ? '0 : dma_ipa_xbar_slave[j].add;
         assign s_dma_ipa_bus_req[j]     = ipa_gcm_req[0] == 1 ? '0 : dma_ipa_xbar_slave[j].req;
         assign s_dma_ipa_bus_wen[j]     = ipa_gcm_req[0] == 1 ? '0 : dma_ipa_xbar_slave[j].wen;
         assign s_dma_ipa_bus_be[j]      = ipa_gcm_req[0] == 1 ? '0 : dma_ipa_xbar_slave[j].be;
         // response channel
         assign dma_ipa_xbar_slave[j].gnt = s_dma_ipa_bus_gnt[j];
         assign dma_ipa_xbar_slave[j].r_rdata = s_dma_ipa_bus_r_rdata[j];
         assign dma_ipa_xbar_slave[j].r_valid = s_dma_ipa_bus_r_valid[j];
      end // block: dma_ipa_binding
      
   endgenerate
   
   
   genvar i;
   generate
      for (i=0;i<NB_LS;i++) begin : ipa_binding
         assign ipa_xbar_master[i].req   = tcdm_req   [i];
         assign ipa_xbar_master[i].add   = tcdm_add   [i];
         assign ipa_xbar_master[i].wen   = tcdm_type  [i];
         assign ipa_xbar_master[i].wdata = tcdm_wdata [i];
         assign ipa_xbar_master[i].be    = '1;
         // response channel
         assign tcdm_gnt     [i] = ipa_xbar_master[i].gnt;
         assign tcdm_r_rdata [i] = ipa_xbar_master[i].r_rdata;
         assign tcdm_r_valid [i] = ipa_xbar_master[i].r_valid;
      end // block: ipa_binding
      
   endgenerate
   logic 				DMA_Write_En_Out, DMA_Exec_En_Out;
   logic [63:0] 			DMA_Data_Out;
   logic [22:0] 			DMA_Addr_Out;
   logic [63:0] Context_Data;
   logic [ADDR_WIDTH-1:0] Context_Addr;

    generate
      for (i=0; i<2; i++)
      begin : TCGCM_BANKS_BIND_IPA
         assign tcdm_ipa_sram_master[i].req   = s_tcdm_bus_sram_req   [i]| ipa_gcm_req[i];// | ipa_gcm_req[i]
         assign tcdm_ipa_sram_master[i].add   = ipa_gcm_req[i] == 1 ? gcm_req_Addr[i] : s_tcdm_bus_sram_add   [i];//ipa_gcm_req[i] == 1 ? gcm_req_Addr[i] :
         assign tcdm_ipa_sram_master[i].wen   = s_tcdm_bus_sram_wen   [i]| ipa_gcm_wen[i] ;//| ipa_gcm_wen[i]
         assign tcdm_ipa_sram_master[i].wdata = s_tcdm_bus_sram_wdata [i];
         assign tcdm_ipa_sram_master[i].be    = ipa_gcm_req[i] == 1 ? '1: s_tcdm_bus_sram_be    [i];
         assign s_tcdm_bus_sram_rdata[i]  = tcdm_ipa_sram_master[i].rdata;


         always_ff @(posedge clk or negedge rst_n) 
         begin : TCGCM_BANKS_RESP_IPA
            if(~rst_n)
            begin
               s_tcdm_bus_sram_rID[i]    <= '0;
               s_tcdm_bus_sram_rvalid[i] <= 1'b0;
               s_data_ts_set_q[i]         <= '0;
            end
            else 
            begin
               s_data_ts_set_q[i]        <= s_data_ts_set_int[i];
                                                  // NORMAL MODE//                                                                       // DURING SET
               s_tcdm_bus_sram_rvalid[i] <= ( (s_tcdm_bus_sram_req[i] | ipa_gcm_req [i]) & ~s_data_ts_set_int[i]  & ~s_data_ts_set_q[i] ) | ((s_tcdm_bus_sram_req[i]| ipa_gcm_req [i]) & ~s_data_ts_set_int[i]  & s_data_ts_set_q[i] );
               if(s_tcdm_bus_sram_req[i])
                  s_tcdm_bus_sram_rID[i] <= s_tcdm_bus_sram_ID[i];
            end
         end
	    
      end // block: TCDM_BANKS_BIND_IPA
   endgenerate
   generate
      for (i=0; i<2; i++)
	begin
	   assign ipa_gcm_req   [i] = ipa_gcm_req_o;
	   assign ipa_gcm_wen   [i] = ipa_gcm_req_o;
	   assign gcm_req_Addr  [i] = Context_Addr;//assign Context_Data[31+(32*i):0+(32*i)]=s_tcdm_bus_sram_rdata[i];
	   if(i == 0) begin
	      assign Context_Data[63:32]=s_tcdm_bus_sram_rdata[i];
	   end else begin
	      assign Context_Data[31:0]=s_tcdm_bus_sram_rdata[i];
	   end
	end
   endgenerate

 XBAR_TCDM
    #(
      .N_CH0           ( 4                                  ),
      .N_CH1           ( 0                                  ),
      .N_SLAVE         ( 2                                  ),
      .ID_WIDTH        ( IPA_GCM_ID_WIDTH                   ),

      //FRONT END PARAMS
      .ADDR_WIDTH      ( ADDR_WIDTH                         ),
      .DATA_WIDTH      ( DATA_WIDTH                         ),
      .BE_WIDTH        ( BE_WIDTH                           ),
      .TEST_SET_BIT    ( TEST_SET_BIT                       ),

      .ADDR_MEM_WIDTH  ( ADDR_MEM_WIDTH                     )
    )
    ipa_XBAR_GCM_i
    (
      // ---------------- MASTER CH0+CH1 SIDE  --------------------------
      .data_req_i          (  s_dma_ipa_bus_req      ),
      .data_add_i          (  s_dma_ipa_bus_add      ),
      .data_wen_i          (  s_dma_ipa_bus_wen      ),
      .data_wdata_i        (  s_dma_ipa_bus_wdata    ),
      .data_be_i           (  s_dma_ipa_bus_be       ),
      .data_gnt_o          (  s_dma_ipa_bus_gnt        ),  
      .data_r_valid_o      (  s_dma_ipa_bus_r_valid  ),
      .data_r_rdata_o      (  s_dma_ipa_bus_r_rdata  ), 

      // ---------------- MM_SIDE (Interleaved) --------------------------
      .data_req_o          (  s_tcdm_bus_sram_req    ),
      .data_ts_set_o       (  s_data_ts_set_int      ),
      .data_add_o          (  s_tcdm_bus_sram_add    ),
      .data_wen_o          (  s_tcdm_bus_sram_wen    ),
      .data_wdata_o        (  s_tcdm_bus_sram_wdata  ),
      .data_be_o           (  s_tcdm_bus_sram_be     ),
      .data_ID_o           (  s_tcdm_bus_sram_ID     ),
      .data_gnt_i          (  {NB_GCM_BANKS{1'b1}}  ),
      
      .data_r_rdata_i      (  s_tcdm_bus_sram_rdata  ), 
      .data_r_valid_i      (  s_tcdm_bus_sram_rvalid ),
      .data_r_ID_i         (  s_tcdm_bus_sram_rID    ),

      //.TCDM_arb_policy_i   (  TCDM_arb_policy_ipa_i  ),
      
      .clk                 (  clk                    ),
      .rst_n               (  rst_n                  )
    );



 
   
   
   dma_ipa 
     #(
       .NB_ROWS( 4), 
       .NB_COLS( 4),
       .GCM_ADDR_WIDTH(ADDR_WIDTH)
       ) 
   ipa_controller_i(
	   .Clk(clk),
	   .Reset(rst_n),
	   .Context_Fetch_En(context_fetch_en),
	   .In_Data(Context_Data),
	   .Context_Addr(Context_Addr),
	   .ipa_gcm_req_o(ipa_gcm_req_o),
	   .Out_Data(DMA_Data_Out),
	   .Out_Addr(DMA_Addr_Out),
	   .Exec_En_Out(DMA_Exec_En_Out),
	   .Write_En(DMA_Write_En_Out),
	   .s_ipa_cfg_id(),
	   .s_ipa_cfg_r_id(),
	   .exec_comp(ipa_exec_complete),
	   .busy_o(busy_ipac),
	   .read_valid(s_dma_ipa_bus_r_valid[3])
	   );
   cgra 
     #(
       .NB_ROWS(4), 
       .NB_COLS(4), 
       .DATA_WIDTH(32), 
       .NB_LS(16)
       )
   ipa_cgra_i(
	     .Clk(clk),
	     .Reset(rst_n),
	     .DMA_Read_En(DMA_Write_En_Out),
	     .DMA_Addr_In(DMA_Addr_Out),
	     .DMA_Data_In(DMA_Data_Out),
	     .Exec_En(DMA_Exec_En_Out),
	     .Load_Data_I(tcdm_r_rdata),
	     .Load_Store_Addr_O(tcdm_add),
	     .Load_Store_Req_O(tcdm_req),
	     .Load_Store_Data_Req_O(tcdm_type),
	     .End_Exec_O(end_exec_o),
	     .Load_Store_Grant_I(tcdm_gnt),  
	     .Data_Req_Valid_I(tcdm_r_valid),
	     .Store_Data_O(tcdm_wdata)
	     ); 
   ipa_cfg_mmap
#(
 .DATA_WIDTH     ( DATA_WIDTH   ),
 .ADDR_WIDTH     ( ADDR_WIDTH   ),
 .BE_WIDTH       ( BE_WIDTH     )
)
 ipa_cfg_mmap_i(
		 .clk(clk),
		 .rst_n(rst_n),
		 .s_ipa_cfg_wdata(s_ipa_cfg_wdata),
		 .s_ipa_cfg_add(s_ipa_cfg_add),
		 .s_ipa_cfg_req(s_ipa_cfg_req),
		 .s_ipa_cfg_wen(s_ipa_cfg_wen),
		 .s_ipa_cfg_be(s_ipa_cfg_be),
		 .s_ipa_cfg_id(s_ipa_cfg_id),
		 .ipa_exec_complete(ipa_exec_complete),
		 .s_ipa_cfg_gnt(s_ipa_cfg_gnt),
		 .s_ipa_cfg_rdata(s_ipa_cfg_rdata),
		 .s_ipa_cfg_valid(s_ipa_cfg_valid),
		 .s_ipa_cfg_r_id(s_ipa_cfg_r_id)
		 );


 
   

   
endmodule
