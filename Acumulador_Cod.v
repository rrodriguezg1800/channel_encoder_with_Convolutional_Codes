//==============================================================
// ACUMULADOR: llena el buffer (sin salida1/salida2)
//==============================================================
module Acumulador_Cod #(
    parameter integer K = 3,
    parameter integer N = 8,
    parameter integer GUARD_PAIRS = 1
)(
    input  wire clk,
    input  wire rst,
    input  wire load_frame_i,
    input  wire step_en_i,
    input  wire [$clog2((N+K-1+GUARD_PAIRS)+1)-1:0] contador_i,
    input  wire t1_i,
    input  wire t2_i,
    output reg  [2*((N+K-1)+GUARD_PAIRS)-1:0] codigo_o_acumulado_o
);
    localparam integer REAL_STEPS  = (N + K - 1);
    localparam integer TOTAL_PAIRS = REAL_STEPS + GUARD_PAIRS;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            codigo_o_acumulado_o <= {(2*TOTAL_PAIRS){1'b0}};
        end else begin
            if (load_frame_i) begin
                codigo_o_acumulado_o <= {(2*TOTAL_PAIRS){1'b0}};
            end else if (step_en_i) begin
                if (contador_i < TOTAL_PAIRS) begin
                    codigo_o_acumulado_o[2*(TOTAL_PAIRS-1-contador_i)+1] <= t1_i; // G1
                    codigo_o_acumulado_o[2*(TOTAL_PAIRS-1-contador_i)  ] <= t2_i; // G2
                end
            end
        end
    end
endmodule