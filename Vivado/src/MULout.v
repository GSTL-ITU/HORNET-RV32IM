module MULout(
    input [63:0] P,
    input M_inA32,
    input M_inB32,
    input [1:0] op_mul,
    output [31:0] out_mul
    );

    wire [63:0] P_2C, P_s, P_su;
    wire [1:0] signs;

    assign P_2C = ~P + 1;

    assign signs = {M_inA32, M_inB32};

    assign P_s = signs[1] ? (signs[0] ? P : P_2C) : (signs[0] ? P_2C : P);
    assign P_su = signs[1] ? P_2C : P;


    assign out_mul = op_mul[1] ? (op_mul[0] ? P[63:32] : P_su[63:32]) : (op_mul[0] ? P_s[63:32] : P_s[31:0]);

endmodule
