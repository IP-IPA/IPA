module contextmemory
(
 input logic[11:0] Context_Addr,
 output logic[63:0] Context_Data
);
  logic [63:0] Context_Data_Reg [4095:0];
   initial begin
      $readmemh("program.hex", Context_Data_Reg);
   end
   always_comb begin
      Context_Data <= Context_Data_Reg[Context_Addr];
   end  
endmodule // contextmemory
