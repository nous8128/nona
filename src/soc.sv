`default_nettype none

module soc (
  input  logic clk_i  ,
  input  logic rst_ni
);

  logic rst;

  sync sync (
    .clk_i    (clk_i    ),
    .async_i  (~rst_ni  ),
    .sync_o   (rst      )
  );

  core core (
    .clk_i    (clk_i    ),
    .rst_i    (rst      )
  );

endmodule

`default_nettype wire
