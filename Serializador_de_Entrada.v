//==============================================================
// Submódulo 1: Paralelo->Serie (MSB-first), exacto al original
//==============================================================
`timescale 1ns/1ps
module Serializador_de_Entrada #(
    parameter integer N = 8
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         load_i,        // cargar mensaje_i (iniciar && !transmitiendo)
    input  wire [N-1:0] mensaje_i,
    input  wire         shift_en_i,    // habilita el shift (transmitiendo && !listo_o)
    input  wire         consumir_i,    // (contador < N)
    output wire         entrada_bit_o  // MSB si consumir_i, si no 0
);
    reg [N-1:0] sr;

    assign entrada_bit_o = consumir_i ? sr[N-1] : 1'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sr <= {N{1'b0}};
        end else begin
            if (load_i) begin
                sr <= mensaje_i;                    // carga paralela
            end else if (shift_en_i && consumir_i) begin
                sr <= {sr[N-2:0], 1'b0};            // shift-left, entra 0 por LSB
            end
        end
    end
endmodule
