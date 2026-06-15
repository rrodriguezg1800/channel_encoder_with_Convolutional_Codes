/*==================== OneShot_Inicio.v ====================
Control the positive false signal of push-buttom
==========================================================*/
`timescale 1ns/1ps
module Control_Antirebote (
    input  wire clk,
    input  wire rst,
    input  wire start_i,     // botón/orden de inicio (sincronizado a clk)
    output wire iniciar_o    // pulso de 1 ciclo para iniciar
);
    // Misma lógica que tenías en Top_TX (drop-in, sin cambios funcionales)
    reg start_req, iniciar_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_req   <= 1'b0;
            iniciar_reg <= 1'b0;
        end else begin
            if (start_i && !start_req) begin
                start_req   <= 1'b1;
                iniciar_reg <= 1'b1;   // pulso 1 ciclo
            end else begin
                iniciar_reg <= 1'b0;
                if (start_req) start_req <= 1'b0;
            end
        end
    end

    assign iniciar_o = iniciar_reg;
endmodule
