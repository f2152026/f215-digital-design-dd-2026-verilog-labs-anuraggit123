// tb.v
// Starter testbench template -- YOU complete this file.

module tb #(parameter WIDTH=8,parameter DEPTH=8);

  // TODO: declare the inputs and outputs
    reg [$clog2(DEPTH)-1:0] t_sel;
    wire [WIDTH-1:0] t_dout;
  // TODO: instantiate DUT here
    lut #(.WIDTH(WIDTH),.DEPTH(DEPTH)) DUT(
      .sel(t_sel),
      .dout(t_dout)
    );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i;
  initial begin
    // TODO: apply different input combinations
    for(i=0;i<DEPTH;i=i+1) begin
      t_sel=i;
      #1;
      if(t_dout!==i*i)
        $display("ERROR: sel=%0d, expected=%0d, got=%0d",i,i*i,t_dout);
      else  
        $display("PASS: sel=%0d, dout=%0d",i,t_dout);
    end 
    $finish;

  end

  initial begin
    $monitor($time, " SEL=%b, DOUT=%b",t_sel,t_dout); // change as required
  end

endmodule