`default_nettype none

module sync #(
  parameter  int unsigned Stages = 2
) (
  input  logic clk_i    ,
  input  logic async_i  ,
  output logic sync_o
);

  // DRC
  initial begin
    assert (Stages >= 2) else $fatal(1, "Stages must be >= 2 for synchronizer (Stages=%0d)", Stages);
  end

  logic [Stages-1:0] sync_ff;

  always_ff @(posedge clk_i) begin
    sync_ff[0]  <= async_i;
    for (int i = 1; i < Stages; i++) begin
      sync_ff[i]  <= sync_ff[i-1] ;
    end
  end

  assign sync_o = sync_ff[Stages-1] ;

endmodule

`default_nettype wire
