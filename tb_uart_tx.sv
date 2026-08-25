module tb_uart_tx;
    logic clk=0,rst_n=0,start=0; logic [7:0] data; logic tx,busy;
    uart_tx #(.CLK_PER_BIT(4)) dut(.*);
    always #1 clk=~clk;
    initial begin
        repeat(2) @(posedge clk); rst_n=1;
        @(posedge clk); data=8'hA5; start=1;
        @(posedge clk); start=0;
        wait(!busy); #5;
        $display("UART TX TEST COMPLETED");
        $finish;
    end
endmodule
