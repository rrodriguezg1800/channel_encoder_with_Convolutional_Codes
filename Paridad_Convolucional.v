//==============================================================
// Submódulo 3: Paridades (t1,t2) desde RESPUESTA y state_next
//==============================================================
module Paridad_Convolucional #(
    parameter integer K = 3,
    parameter [5:0]  RESPUESTA = 6'b111011
)(
    input  wire [K-1:0] state_next_i,
    output wire         t1_o,
    output wire         t2_o
);
    // Taps como en el diseño original
    localparam [K-1:0] G1 = {RESPUESTA[5], RESPUESTA[3], RESPUESTA[1]};
    localparam [K-1:0] G2 = {RESPUESTA[4], RESPUESTA[2], RESPUESTA[0]};

    // XOR de reducción sobre las máscaras
    assign t1_o = ^(state_next_i & G1);
    assign t2_o = ^(state_next_i & G2);
endmodule
