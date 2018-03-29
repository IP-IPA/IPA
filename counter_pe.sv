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
// Module Name:    counter                                                    //
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
module counter_pe(
	       input logic Clk,Reset, Counter_En, Global_Stall_I,
	       input logic [4:0] Data_In,
	       output logic Clock_Gate_En_O
	       );

   logic [4:0] 		    Counter_Reg;
   logic 		    count_state, state;
		    
   

  always_ff @(posedge Clk or negedge Reset) begin
     if(Reset == 1'b0) begin
	Counter_Reg <= '0;
	count_state <= '0;
	state <= '0;
	
     end else if(Counter_En == '1 && Global_Stall_I == '0) begin
	Counter_Reg <= Data_In;
	count_state <= '1;
	state<='1;
	
     end else if(state == '1 && Global_Stall_I == '0) begin
	Counter_Reg <= Counter_Reg - 1;
	count_state <= '0;
	if(Counter_Reg == 5'b00001) begin
	state <= '0;
	end	
     end
     
     
  end


   always_comb begin
      Clock_Gate_En_O <= '0;
      if(count_state == '1) begin
	 Clock_Gate_En_O <= '0;
	 //state <= '1;
	 
      end else if(Counter_Reg == 5'b00000 && count_state == '0) begin
	 Clock_Gate_En_O <= '1;
	 //state <= '0;
      end 
   end

endmodule // counter
