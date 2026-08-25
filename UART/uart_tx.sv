module uart_tx #(
    parameter int CLK_PER_BIT=16
)(
    input logic clk,rst_n,
    input logic start,
    input logic [7:0] data,
    output logic tx,
    output logic busy
);
    logic [7:0] shreg; logic [15:0] count; logic [3:0] bit_idx;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin tx<=1'b1; busy<=0; shreg<=0; count<=0; bit_idx<=0; end
        else if(start && !busy) begin
            shreg<=data; busy<=1; count<=0; bit_idx<=0; tx<=0;
        end else if(busy) begin
            if(count==CLK_PER_BIT-1) begin
                count<=0;
                if(bit_idx<8) begin tx<=shreg[bit_idx]; bit_idx<=bit_idx+1; end
                else begin tx<=1; busy<=0; end
            end else count<=count+1;
        end
    end
endmodule
