`define COMMAND 8'h00
`define STATUS 8'h04


module ipa_cfg_mmap
#(
   parameter DATA_WIDTH=0,
   parameter BE_WIDTH=0,
   parameter ADDR_WIDTH=0
)
(
 input logic clk, rst_n,
 input logic [DATA_WIDTH-1:0] s_ipa_cfg_wdata,
 input logic [ADDR_WIDTH-1:0] s_ipa_cfg_add,
 input logic      	      s_ipa_cfg_req,
 input logic  		      s_ipa_cfg_wen,
 input logic [BE_WIDTH-1:0]   s_ipa_cfg_be,
 input logic [4:0] 	      s_ipa_cfg_id,
 input logic                  ipa_exec_complete,
 output logic  		      s_ipa_cfg_gnt,
 output logic [DATA_WIDTH-1:0]s_ipa_cfg_rdata,
 output logic  	              s_ipa_cfg_valid,
 output logic [4:0] 	      s_ipa_cfg_r_id
 
 );

   logic [31:0] 	      command_reg, status_reg;	      
   logic [4:0] 		      id_reg;
   logic 		      r_valid;

   // write logic
   always_ff @(posedge clk or negedge rst_n) begin
      if(rst_n == '0) 
	begin
	   
	   command_reg <= 0;
	   status_reg <= 0;
	   
	   r_valid <= 0;
	   id_reg <= 0;
	   
	end 
      else
	begin
	      r_valid <= 0;
	      id_reg<= 0;
	   if(ipa_exec_complete == 1)
	     begin
		status_reg <= 1;
		r_valid <= (s_ipa_cfg_req == 1) ? 1 : 0;
		id_reg  <= s_ipa_cfg_id;
		
	     end
	   else begin
	      if(s_ipa_cfg_req == 1 && s_ipa_cfg_wen == 0) 
		begin
		   id_reg  <= s_ipa_cfg_id;
		   r_valid <= 1;
		   case(s_ipa_cfg_add[7:0])
		     `COMMAND:
		       begin
			  command_reg <= s_ipa_cfg_wdata;
		       end
		     `STATUS:
		       begin		  
			  status_reg <= s_ipa_cfg_wdata;
		       end
		   endcase // case (s_ipa_cfg_add[7:0])
		end // if (s_ipa_cfg_req == 1 && s_ipa_cfg_wen == 0)
	      
	      else if(s_ipa_cfg_req == 1 && s_ipa_cfg_wen == 1) 
		begin
		   id_reg  <= s_ipa_cfg_id;
		   r_valid <= 1;
		end
	   end // else: !if(ipa_exec_complete == 1)
	   
	
	     
	end // else: !if(rst_n == '0)
      
	   
   end // always_ff @ (posedge clk or negedge rst_n)
   

   always_ff @ (posedge clk or negedge rst_n) 
     begin
	if(rst_n == '0) 
	  begin
	     s_ipa_cfg_rdata = '0;
	  end
	else
	  begin
	     
	     if(s_ipa_cfg_req == 1 && s_ipa_cfg_wen == 1)
	       begin
		  case(s_ipa_cfg_add[7:0])
		    `COMMAND:
		      begin
	    		 s_ipa_cfg_rdata = command_reg;
		      end
		    `STATUS:
		      begin
			 s_ipa_cfg_rdata = status_reg;
		      end
		  endcase
		  
	       end // if (s_ipa_cfg_req == 1 && s_ipa_cfg_wen == 1)
	  end // else: !if(rst_n == '0)
	
     end // always_comb begin
   
   

   assign s_ipa_cfg_gnt = 1;
   assign s_ipa_cfg_valid = r_valid;
   assign s_ipa_cfg_r_id = id_reg;
   
endmodule // ipa_cfg_mmap

