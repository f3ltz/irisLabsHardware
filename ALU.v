module ALU (
    input [3:0] ALUCtl,
    input [31:0] A, B,
    output reg [31:0] ALUOut,
    output zero
);
    // Combinational logic for ALU operations.
    always @(*) begin
        case(ALUCtl)
            4'b0010: ALUOut = A + B;                     // ADD
            4'b0110: ALUOut = A - B;                     // SUB
            4'b0000: ALUOut = A & B;                     // AND
            4'b0001: ALUOut = A | B;                     // OR
            4'b0011: ALUOut = A ^ B;                     // XOR
            4'b0100: ALUOut = A << B[4:0];               // SLL: shift left logical (only lower 5 bits for shift amount)
            4'b0101: ALUOut = A >> B[4:0];               // SRL: shift right logical
            4'b0111: ALUOut = $signed(A) >>> B[4:0];       // SRA: shift right arithmetic
            4'b1000: ALUOut = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;  // SLT: set less than (signed)
            4'b1001: ALUOut = (A < B) ? 32'd1 : 32'd0;    // SLTU: set less than (unsigned)
            default: ALUOut = 32'd0;                      // Default case
        endcase
    end

    // Zero flag is high when the ALU result is zero.
    assign zero = (ALUOut == 32'd0);

endmodule
