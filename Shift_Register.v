//==============================================================
// Submódulo 2: Registro K y "next" exactos al original
//==============================================================
module Shift_Register #(
    parameter integer K = 3
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         load_zero_i,   // poner en 0 al iniciar frame
    input  wire         step_en_i,     // (transmitiendo && !listo_o)
    input  wire         bit_in_i,      // entrada_bit del ciclo
    output wire [K-1:0] next_o         // combinacional: {bit_in, q[K-1:1]}
);
    reg [K-1:0] q;

    assign next_o = {bit_in_i, q[K-1:1]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= {K{1'b0}};
        end else if (load_zero_i) begin
            q <= {K{1'b0}};
        end else if (step_en_i) begin
            q <= next_o;
        end
    end
endmodule
