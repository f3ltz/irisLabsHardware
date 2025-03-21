module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    always @(*) begin
        case(ALUOp)
            // For load, store, AUIPC, etc. – perform addition.
            2'b00: ALUCtl = 4'b0010; // ADD

            // For branch instructions – perform subtraction.
            2'b01: ALUCtl = 4'b0110; // SUB

            // For R-type instructions – decode using funct3 and funct7.
            2'b10: begin
                case(funct3)
                    3'b000: ALUCtl = (funct7 == 1'b1 && ALUOp == 2'b10) ? 4'b0110 : 4'b0010; // ADD if funct7==0, SUB if funct7==1
                    3'b001: ALUCtl = 4'b0100; // SLL
                    3'b010: ALUCtl = 4'b1000; // SLT
                    3'b011: ALUCtl = 4'b1001; // SLTU
                    3'b100: ALUCtl = 4'b0011; // XOR
                    3'b101: ALUCtl = (funct7 == 1'b0) ? 4'b0101 : 4'b0111; // SRL if funct7==0, SRA if funct7==1
                    3'b110: ALUCtl = 4'b0001; // OR
                    3'b111: ALUCtl = 4'b0000; // AND
                    default: ALUCtl = 4'bxxxx; // Undefined
                endcase
            end
			
			2'b11: begin
                case(funct3)
                    3'b000: ALUCtl = 4'b0010; // ADD if funct7==0, SUB if funct7==1
                    3'b001: ALUCtl = 4'b0100; // SLLi
                    3'b010: ALUCtl = 4'b1000; // SLTi
                    
                    3'b100: ALUCtl = 4'b0011; // XOR
                    3'b101: ALUCtl = (funct7 == 1'b0) ? 4'b0101 : 4'b0111; // SRL if funct7==0, SRA if funct7==1
                    3'b110: ALUCtl = 4'b0001; // ORi
                    
                    default: ALUCtl = 4'bxxxx; // Undefined
                endcase
            end

            default: ALUCtl = 4'bxxxx; // Undefined for any other ALUOp
        endcase
    end

endmodule
