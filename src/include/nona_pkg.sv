package nona_pkg;

  parameter int unsigned     XLen         = 64                ;
  parameter logic [XLen-1:0] ResetVector  = XLen'('h80000000) ;

  parameter int unsigned     RomSizeBytes = 16 * 1024         ;

endpackage
