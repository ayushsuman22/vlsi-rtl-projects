module tb_async_fifo;
    logic wr_clk=0,rd_clk=0,wr_rst_n=0,rd_rst_n=0,wr_en=0,rd_en=0;
    logic [7:0] wr_data,rd_data; logic full,empty;
    async_fifo #(.DATA_WIDTH(8),.ADDR_WIDTH(2)) dut(.*);

    always #5 wr_clk=~wr_clk;
    always #7 rd_clk=~rd_clk;

    initial begin
        repeat(2) @(posedge wr_clk); wr_rst_n=1; rd_rst_n=1;
        repeat(4) begin
            @(posedge wr_clk); wr_en=1; wr_data=$random;
        end
        @(posedge wr_clk); wr_en=0;
        repeat(2) @(posedge rd_clk);
        repeat(4) begin @(posedge rd_clk); rd_en=1; end
        @(posedge rd_clk); rd_en=0;
        #20 $display("ASYNC FIFO TEST COMPLETED");
        $finish;
    end
endmodule
