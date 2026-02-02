`default_nettype none

module top;

  // clock
  bit clk;
  always #5 clk <= ~clk;
  clocking cb @(posedge clk); endclocking

  // reset
  bit rst_n;
  initial #100 rst_n = 1'b1;

  // cycle
  longint unsigned cycles;
  always_ff @(posedge clk) begin
    cycles  <= cycles + 1;
  end

  // timeout
  longint unsigned max_cycles;
  initial begin
    assert ($value$plusargs("max_cycles=%d", max_cycles))
      else $fatal(1, "specify a max_cycles");
  end
  always_ff @(cb) begin
    if (cycles >= max_cycles) $finish(1);
  end

  // soc
  soc soc (
    .clk_i  (clk    ),
    .rst_ni (rst_n  )
  );

  // memory file
  string mem_file;
  initial begin
    assert ($value$plusargs("mem_file=%s", mem_file)) begin
      $readmemh(mem_file, soc.core.async_rom.rom);
    end else begin
      $fatal(1, "specify a mem_file");
    end
  end

  // debug
  always_ff @(cb) begin
    $display("pc=[%016x] ir=[0x%08x]", soc.core.pc_q, soc.core.ir);
  end

endmodule

`default_nettype wire
