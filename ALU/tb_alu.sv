module tb_alu;
    logic [7:0] a,b,y; logic [2:0] op; logic zero,carry;
    alu dut(.a(a),.b(b),.op(op),.y(y),.zero(zero),.carry(carry));

    task automatic check(input logic [7:0] aa, input logic [7:0] bb,
                         input logic [2:0] oo, input logic [7:0] expected);
        begin
            a=aa; b=bb; op=oo; #1;
            assert(y===expected)
                else $fatal("FAIL a=%h b=%h op=%b y=%h expected=%h",a,b,op,y,expected);
        end
    endtask

    initial begin
        check(8'h05,8'h03,3'b000,8'h08);
        check(8'h05,8'h03,3'b001,8'h02);
        check(8'hA5,8'h0F,3'b010,8'h05);
        check(8'hA5,8'h0F,3'b011,8'hAF);
        check(8'hA5,8'h0F,3'b100,8'hAA);
        check(8'h0F,8'h00,3'b101,8'hF0);
        check(8'h03,8'h05,3'b110,8'h01);
        $display("ALU TEST PASSED");
        $finish;
    end
endmodule
