module alu #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       op,
    output logic [WIDTH-1:0] y,
    output logic             zero,
    output logic             carry
);
    logic [WIDTH:0] tmp;

    always_comb begin
        y = '0;
        carry = 1'b0;
        tmp = '0;
        unique case (op)
            3'b000: begin tmp = {1'b0,a} + {1'b0,b}; y = tmp[WIDTH-1:0]; carry=tmp[WIDTH]; end
            3'b001: begin tmp = {1'b0,a} - {1'b0,b}; y = tmp[WIDTH-1:0]; carry=tmp[WIDTH]; end
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b100: y = a ^ b;
            3'b101: y = ~a;
            3'b110: y = (a < b) ? {{(WIDTH-1){1'b0}},1'b1} : '0;
            default: y = '0;
        endcase
        zero = (y == '0);
    end
endmodule
