//=============================== TX ===============================
`timescale 1ns/1ps
module Top_Codificador	 (
    input  wire        clk_in,
    input  wire        rst,
    input  wire [7:0]  switches,
    input  wire        start_cod,

    // Debug
    output wire        led_clk_debug,
    output wire        led_par_valid,
    output wire [19:0] leds_codigo20,

    // Señales útiles para TB/estado (sin exponer stream de datos)
    output wire        led_listo_cod
);

    // ---------------- Reloj lento ----------------
    wire clk_lento;
    Divisor_de_Frecuencia #(.DIV(10_000_000)) u_div (
        .clk_in (clk_in),
        .rst    (rst),
        .clk_out(clk_lento)
    );
    assign led_clk_debug = clk_lento;

    // ------------- Capturador palabra -------------
    wire [7:0] palabra_sw;
    Entrada_8bits u_Inicio_Cod (
        .clk      (clk_lento),
        .rst      (rst),
        .start_cod(start_cod),
        .switches (switches),
        .salida_o (palabra_sw)
    );

    // ----------- One-shot de inicio (encapsulado) -----------
    wire iniciar_cod;
    Control_Antirebote para_boton_start (
        .clk      (clk_lento),
        .rst      (rst),
        .start_i  (start_cod),
        .iniciar_o(iniciar_cod)
    );

    // ----------------- Codificador (22 bits) -----------------
    wire listo_cod;
    wire par_valid_cod;
    wire [21:0] codigo_o_acumulado; // 11 pares -> 22 bits

    // Wires internos SOLO para depuración en simulación (no salen del chip)
    wire t1_cod, t2_cod;

    Codificador #(
        .K(3), .N(8), .RESPUESTA(6'b111011),
        .GUARD_PAIRS(1) // 10 reales + 1 guarda = 11 pares (22 bits)
    ) u_cod (
        .clk                (clk_lento),
        .rst                (rst),
        .iniciar            (iniciar_cod),
        .mensaje            (palabra_sw),
        .listo_o            (listo_cod),
        .par_valid_o        (par_valid_cod),
        .codigo_o_acumulado (codigo_o_acumulado),
        .t1_o               (t1_cod),   // <-- visibles por jerarquía en TB
        .t2_o               (t2_cod)    // <--
    );

    // Debug / estado
    assign led_par_valid  = par_valid_cod;
    assign leds_codigo20  = codigo_o_acumulado[21:2]; // descartamos 1 par (2 bits)
    assign led_listo_cod = listo_cod;                // fin tras 22 bits
endmodule
