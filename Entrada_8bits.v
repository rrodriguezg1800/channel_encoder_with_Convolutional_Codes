// ==========================================================
// Módulo: Capturador de 8 bits
// Función: Captura el valor de los switches cuando start_cod = 1
// ==========================================================
module Entrada_8bits (
    input  wire        clk,        // Reloj del sistema
    input  wire        rst,        // Reset síncrono activo alto
    input  wire        start_cod,  // Pulso de inicio de captura
    input  wire [7:0]  switches,   // Entrada de 8 bits (switches)
    output reg  [7:0]  salida_o    // Salida capturada
);

    // Registro interno para detectar flanco de start_cod
    reg start_cod_d;  // retardo de 1 ciclo

    always @(posedge clk) begin
        if (rst) begin
            salida_o   <= 8'b0;
            start_cod_d <= 1'b0;
        end else begin
            // Detectar flanco de start_cod (0 -> 1)
            start_cod_d <= start_cod;
            if (start_cod & ~start_cod_d) begin
                // Captura la palabra al flanco positivo
                salida_o <= switches;  // MSB -> LSB se mantiene
            end
        end
    end

endmodule
