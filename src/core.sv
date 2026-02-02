`default_nettype none

module core
  import nona_pkg::*;
(
  input  logic clk_i  ,
  input  logic rst_i
);

  logic [XLen-1:0] pc_q , pc_d;
  logic     [31:0] ir         ;

  assign pc_d = pc_q + XLen'(4);

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      pc_q  <= ResetVector;
    end else begin
      pc_q  <= pc_d       ;
    end
  end

  async_rom #(
    .RomSizeBytes (RomSizeBytes ),
    .AddrWidth    (XLen         ),
    .DataWidth    (32           )
  ) async_rom (
    .clk_i    (clk_i  ),
    .rst_i    (rst_i  ),
    .raddr_i  (pc_q   ),
    .rdata_o  (ir     )
  );

endmodule

`default_nettype wire
