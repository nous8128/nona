`default_nettype none

module async_rom #(
  parameter  int unsigned RomSizeBytes    = 0                             ,
  parameter  int unsigned AddrWidth       = 0                             ,
  parameter  int unsigned DataWidth       = 0                             ,
  localparam int unsigned StrbWidth       = DataWidth / 8                 ,
  localparam int unsigned RomEntries      = RomSizeBytes / (DataWidth / 8),
  localparam int unsigned OffsetWidth     = $clog2(DataWidth / 8)         ,
  localparam int unsigned ValidAddrWidth  = $clog2(RomSizeBytes)
) (
  input  logic                 clk_i    ,
  input  logic                 rst_i    ,
  input  logic [AddrWidth-1:0] raddr_i  ,
  output logic [DataWidth-1:0] rdata_o
);

  // DRC
  initial begin
    assert (RomSizeBytes > 0) else $fatal(1, "RomSizeBytes must be > 0 for %m (RomSizeBytes=%0d)", RomSizeBytes);
    assert (AddrWidth    > 0) else $fatal(1, "AddrWidth must be > 0 for %m (AddrWidth=%0d)"      , AddrWidth   );
    assert (DataWidth    > 0) else $fatal(1, "DataWidth must be > 0 for %m (DataWidth=%0d)"      , DataWidth   );
  end

  logic [DataWidth-1:0] rom[RomEntries] ;

  logic [ValidAddrWidth-1:OffsetWidth] valid_raddr;
  assign valid_raddr  = raddr_i[ValidAddrWidth-1:OffsetWidth];

  assign rdata_o  = rom[valid_raddr];

endmodule

`default_nettype wire
