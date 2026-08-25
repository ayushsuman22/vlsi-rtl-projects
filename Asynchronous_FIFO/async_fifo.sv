module async_fifo #(
    parameter int DATA_WIDTH=8,
    parameter int ADDR_WIDTH=2
)(
    input logic wr_clk, wr_rst_n, wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    output logic full,
    input logic rd_clk, rd_rst_n, rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic empty
);
    localparam int DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH:0] wbin,wgray,rbin,rgray;
    logic [ADDR_WIDTH:0] rgray_w1,rgray_w2,wgray_r1,wgray_r2;
    logic [ADDR_WIDTH:0] wbin_next,wgray_next,rbin_next,rgray_next;

    function automatic [ADDR_WIDTH:0] bin2gray(input [ADDR_WIDTH:0] b);
        bin2gray=(b>>1)^b;
    endfunction

    always_comb begin
        wbin_next = wbin + ((wr_en && !full) ? 1 : 0);
        wgray_next = bin2gray(wbin_next);
        rbin_next = rbin + ((rd_en && !empty) ? 1 : 0);
        rgray_next = bin2gray(rbin_next);
    end

    always_ff @(posedge wr_clk or negedge wr_rst_n)
        if(!wr_rst_n) begin wbin<='0; wgray<='0; end
        else begin
            if(wr_en && !full) mem[wbin[ADDR_WIDTH-1:0]] <= wr_data;
            wbin<=wbin_next; wgray<=wgray_next;
        end

    always_ff @(posedge rd_clk or negedge rd_rst_n)
        if(!rd_rst_n) begin rbin<='0; rgray<='0; rd_data<='0; end
        else begin
            if(rd_en && !empty) rd_data <= mem[rbin[ADDR_WIDTH-1:0]];
            rbin<=rbin_next; rgray<=rgray_next;
        end

    always_ff @(posedge wr_clk or negedge wr_rst_n)
        if(!wr_rst_n) begin rgray_w1<='0; rgray_w2<='0; end
        else begin rgray_w1<=rgray; rgray_w2<=rgray_w1; end

    always_ff @(posedge rd_clk or negedge rd_rst_n)
        if(!rd_rst_n) begin wgray_r1<='0; wgray_r2<='0; end
        else begin wgray_r1<=wgray; wgray_r2<=wgray_r1; end

    always_comb begin
        empty = (rgray_next == wgray_r2);
        full = (wgray_next == {~rgray_w2[ADDR_WIDTH:ADDR_WIDTH-1],
                                rgray_w2[ADDR_WIDTH-2:0]});
    end
endmodule
