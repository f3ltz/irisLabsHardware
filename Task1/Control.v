module Control (
    input  [6:0] opcode,
    output reg       branch,
    output reg       memRead,
    output reg       memtoReg,
    output reg [1:0] ALUOp,
    output reg       memWrite,
    output reg       ALUSrc,
    output reg       regWrite
);

    always @(*) begin
        // Default values
        branch   = 0;
        memRead  = 0;
        memtoReg = 0;
        ALUOp    = 2'b00;
        memWrite = 0;
        ALUSrc   = 0;
        regWrite = 0;

        case(opcode)
            // R-Type Instructions
            7'b0110011: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b10;
                memWrite = 0;
                ALUSrc   = 0;
                regWrite = 1;
            end

            // I-Type Arithmetic: ADDI, ANDI, ORI, XORI, etc.
            7'b0010011: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b11;
                memWrite = 0;
                ALUSrc   = 1;
                regWrite = 1;
            end

            // Load Instructions: LB, LH, LW, LBU, LHU
            7'b0000011: begin
                branch   = 0;
                memRead  = 1;
                memtoReg = 1;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 1;
                regWrite = 1;
            end

            // Store Instructions: SB, SH, SW, SD
            7'b0100011: begin
                branch   = 0;
                memRead  = 0;
                ALUOp    = 2'b00;
                memWrite = 1;
                ALUSrc   = 1;
                regWrite = 0;
            end

            // Branch Instructions: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011: begin
                branch   = 1;
                memRead  = 0;
                ALUOp    = 2'b01;
                memWrite = 0;
                ALUSrc   = 0;
                regWrite = 0;
            end

            // LUI (Load Upper Immediate)
            7'b0110111: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 1;
                regWrite = 1;
            end

            // AUIPC (Add Upper Immediate to PC)
            7'b0010111: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 1;
                regWrite = 1;
            end

            // JAL (Jump and Link)
            7'b1101111: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 0;
                regWrite = 1;
            end

            // JALR (Jump and Link Register)
            7'b1100111: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 1;
                regWrite = 1;
            end

            // ECALL, EBREAK
            7'b1110011: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 0;
                regWrite = 0;
            end

            default: begin
                branch   = 0;
                memRead  = 0;
                memtoReg = 0;
                ALUOp    = 2'b00;
                memWrite = 0;
                ALUSrc   = 0;
                regWrite = 0;
            end
        endcase
    end

endmodule
