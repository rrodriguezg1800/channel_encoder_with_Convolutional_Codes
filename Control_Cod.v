//==============================================================
// CONTROL: genera enable/estado/timing exactamente como el original
//==============================================================
module Control_Cod #(
    parameter integer K = 3,
    parameter integer N = 8,
    parameter integer GUARD_PAIRS = 1
)(
    input  wire clk,
    input  wire rst,
    input  wire iniciar,

    output wire        load_frame_o,   // (iniciar && !transmitiendo)
    output wire        step_en_o,      // (transmitiendo && !listo_o)
    output wire        consumir_msb_o, // (contador < N)

    output reg         par_valid_o,
    output reg         listo_o,
    output reg  [$clog2((N+K-1+GUARD_PAIRS)+1)-1:0] contador_o
);
    localparam integer REAL_STEPS  = (N + K - 1);
    localparam integer TOTAL_PAIRS = REAL_STEPS + GUARD_PAIRS;
    localparam integer CNTW        = $clog2(TOTAL_PAIRS+1);

    reg transmitiendo;

    assign consumir_msb_o = (contador_o < N);
    assign step_en_o      = (transmitiendo && !listo_o);
    assign load_frame_o   = (iniciar && !transmitiendo);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador_o    <= {CNTW{1'b0}};
            transmitiendo <= 1'b0;
            listo_o       <= 1'b0;
            par_valid_o   <= 1'b0;
        end else begin
            if (load_frame_o) begin
                contador_o    <= {CNTW{1'b0}};
                transmitiendo <= 1'b1;
                listo_o       <= 1'b0;
                par_valid_o   <= 1'b0;

            end else if (transmitiendo && !listo_o) begin
                par_valid_o <= (contador_o < TOTAL_PAIRS);
                contador_o  <= contador_o + 1'b1;

                // 'listo' al ciclo siguiente tras el último par (mismo timing)
                if (contador_o == TOTAL_PAIRS) begin
                    listo_o       <= 1'b1;
                    transmitiendo <= 1'b0;
                    par_valid_o   <= 1'b0;
                end
            end else begin
                par_valid_o <= 1'b0;
            end
        end
    end
endmodule
