module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    wire [6:0] opcode = inst[6:0];  // Extract opcode field

    always @(*) 
    begin
        case(opcode)
            // I-Type (Immediate Instructions: ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI, LW)
            7'b0010011, // Arithmetic I-Type (ADDI, ANDI, ORI, XORI, SLTI, SLTIU)
            7'b0000011, // Load (LW, LH, LHU, LB, LBU)
            7'b1100111: // JALR (Jump and Link Register)
                imm = {{20{inst[31]}}, inst[31:20]}; // Sign-extend 12-bit immediate

            // S-Type (Store Instructions: SW, SH, SB)
            7'b0100011: // S-Type format (SW, SH, SB)
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // Combine split immediate fields

            // B-Type (Branch Instructions: BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'b1100011: // B-Type format (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                imm = {{20{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]}; // Shifted sign-extended

            // U-Type (LUI, AUIPC)
            7'b0110111, // LUI
            7'b0010111: // AUIPC
                imm = {inst[31:12], 12'b0}; // Upper 20-bit immediate

            // J-Type (JAL)
            7'b1101111: // JAL (Jump and Link)
                imm = {{12{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21]}; // Sign-extended

            default:
                imm = 32'b0; // Default case
        endcase
    end
            
endmodule
