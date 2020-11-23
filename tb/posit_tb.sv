

`include "posit_pkg.sv"
`include "posit_arith_unit.sv"

module tb;
  timeunit 1ns;

  import posit_pkg::*;

//  localparam N_TESTS= 100_000;
  localparam N_TESTS= 10000;
  integer L= 16;

  logic [FULL_L - 1 : 0] file_lines [ 0 : N_TESTS - 1] [0 : 2];

  logic  [FULL_L - 1 : 0] in_1, in_0;
  logic  [PRECISION_CONFIG_L - 1 : 0] mode;

  logic  [FULL_L - 1 : 0] out, golden;
  logic [32 -1 :0] golden_part, out_part;

  logic [2*FULL_L - 1 : 0]     mul_out_full;
  logic [1:0][2*HALF_L -1 :0]  mul_out_half;
  logic [3:0][2*QUART_L -1 :0] mul_out_quart;
  logic mul_en;

  /*
  multiplier_decomposable  
    MULTIPLIER_DECOMPOSABLE_INS (
      .in0        (in_0),
      .in1        (in_1),
      .mode       (mode),
      .out_full   (mul_out_full),
      .out_half   (mul_out_half),
      .out_quarter (mul_out_quart)
    ); 
  */
 
  posit_arith_unit POSIT_ARITH_UNIT_INS (
    .clk (1'b0), // for assertion

    .in_0(in_0),
    .in_1(in_1),
    .out(out),

    .mode(mode),
    .mul_en(mul_en) // if 0 then add is enabled
  );
  
  initial begin
    L=16;
    mode= pe_pkg::PRECISION_CONFIG_16B;
    mul_en =1'b1;
    $readmemh("./no_backup/stim/mul_stim_16_4.txt", file_lines);
    check_16 (file_lines);
    mul_en =1'b0;
    $readmemh("./no_backup/stim/add_stim_16_4.txt", file_lines);
    check_16 (file_lines);

    L=32;
    mode= pe_pkg::PRECISION_CONFIG_32B;
    mul_en =1'b1;
    $readmemh("./no_backup/stim/mul_stim_32_7.txt", file_lines);
    check_32 (file_lines);
    mul_en =1'b0;
    $readmemh("./no_backup/stim/add_stim_32_7.txt", file_lines);
    check_32 (file_lines);

    L=8;
    mode= pe_pkg::PRECISION_CONFIG_8B;
    mul_en =1'b1;
    $readmemh("./no_backup/stim/mul_stim_8_2.txt", file_lines);
    check_8 (file_lines);
    mul_en =1'b0;
    $readmemh("./no_backup/stim/add_stim_8_2.txt", file_lines);
    check_8 (file_lines);
  end

  task check_32 (input logic [FULL_L - 1 : 0] file_lines [ 0 : N_TESTS - 1] [0 : 2]);
    localparam L1= 32;
    for (integer i=0; i< N_TESTS ; i=i+1) begin
      in_0 = file_lines[i][0];
      in_1 = file_lines[i][1];
      golden = file_lines[i][2];

      #1;
      //$display(in_0);
      //$display(in_1);
      //$display(golden);
      //$display(out);
      
      for (integer j=0; j< (FULL_L/L1) ; j=j+1) begin
        golden_part= golden[j*L1 +: L1];
        out_part= out[j*L1 +: L1];
        
        assert (out_part != {L1{1'b1}}) else begin 
          $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
          $finish;
        end

        if (golden_part == {L1{1'b1}}) begin
          assert (out_part == golden_part - 1);
        end
        if ((golden_part != out_part) && (out_part != golden_part + 1) && (golden_part != {L1{1'b1}})) begin
          assert (golden_part == out_part) 
          else begin 
            $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
            $finish(1);
          end
        end
        if ( i < 10) begin
          $display("%h, %h, %h, %h", in_0, in_1, golden, out);
//          $display("%h, %h, %h", mul_out_quart, mul_out_half, mul_out_full);
        end
      end
    end
  endtask
  task check_16 (input logic [FULL_L - 1 : 0] file_lines [ 0 : N_TESTS - 1] [0 : 2]);
    localparam L1= 16;
    for (integer i=0; i< N_TESTS ; i=i+1) begin
      in_0 = file_lines[i][0];
      in_1 = file_lines[i][1];
      golden = file_lines[i][2];

      #1;
      //$display(in_0);
      //$display(in_1);
      //$display(golden);
      //$display(out);
      
      for (integer j=0; j< (FULL_L/L1) ; j=j+1) begin
        golden_part= golden[j*L1 +: L1];
        out_part= out[j*L1 +: L1];
        
        assert (out_part != {L1{1'b1}}) else begin 
          $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
          $finish;
        end

        if (golden_part == {L1{1'b1}}) begin
          assert (out_part == golden_part - 1);
        end
        if ((golden_part != out_part) && (out_part != golden_part + 1) && (golden_part != {L1{1'b1}})) begin
          assert (golden_part == out_part) 
          else begin 
            $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
            $finish(1);
          end
        end
        if ( i < 10) begin
          $display("%h, %h, %h, %h", in_0, in_1, golden, out);
//          $display("%h, %h, %h", mul_out_quart, mul_out_half, mul_out_full);
        end
      end
    end
  endtask
  task check_8 (input logic [FULL_L - 1 : 0] file_lines [ 0 : N_TESTS - 1] [0 : 2]);
    localparam L1= 8;
    for (integer i=0; i< N_TESTS ; i=i+1) begin
      in_0 = file_lines[i][0];
      in_1 = file_lines[i][1];
      golden = file_lines[i][2];

      #1;
      //$display(in_0);
      //$display(in_1);
      //$display(golden);
      //$display(out);
      
      for (integer j=0; j< (FULL_L/L1) ; j=j+1) begin
        golden_part= golden[j*L1 +: L1];
        out_part= out[j*L1 +: L1];
        
        assert (out_part != {L1{1'b1}}) else begin 
          $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
          $finish;
        end

        if (golden_part == {L1{1'b1}}) begin
          assert (out_part == golden_part - 1);
        end
        if ((golden_part != out_part) && (out_part != golden_part + 1) && (golden_part != {L1{1'b1}})) begin
          assert (golden_part == out_part) 
          else begin 
            $display("Fail at %0t!%d, %h, %h, %h, %h", $time, j, in_0, in_1, golden_part, out_part);
            $finish(1);
          end
        end
        if ( i < 10) begin
          $display("%h, %h, %h, %h", in_0, in_1, golden, out);
//          $display("%h, %h, %h", mul_out_quart, mul_out_half, mul_out_full);
        end
      end
    end
  endtask
endmodule
