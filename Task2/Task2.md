


# **IRIS Labs Hardware Assignment I**

## **Q2.**

### **A.) Control Signals**

The table below outlines the control signals for different instructions:


| Instruction | Branch | MemRead | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite |
|------------|--------|---------|----------|-------|----------|--------|----------|
| **beq**    | 1      | 0       | X        | 01    | 0        | 0      | 0        |
| **sw**     | 0      | 0       | X        | 00    | 1        | 1      | 0        |
| **lw**     | 0      | 1       | 1        | 00    | 0        | 1      | 1        |

### **B.) Assembly Code Execution Analysis**

The given assembly code loops until `x1` becomes zero. Initially, `x2` is set to 2 and `x1` to 8, while `x0` remains 0 as it is not initialized. The instruction `slt x2, x0, x1` sets `x2` to 1 if `x0 < x1`, which is true at the beginning. The `beq x2, x0, DONE` instruction checks if `x2` is equal to `x0`, and since they are not equal, execution proceeds. The next two instructions modify `x1` and `x2`; `addi x1, x1, -1` decrements `x1` by 1, and `addi x2, x2, 2` increases `x2` by 2. The `j loop` instruction then jumps back to the start of the loop.

As the loop runs, `x1` gradually decreases to 0. When `x1 = 0`, the `slt` instruction sets `x2` to 0, making `beq x2, x0, DONE` true, which terminates execution. Regardless of its initial value, `x2` always ends up as 0 when the loop exits.

```assembly
loop: slt x2, x0, x1  
      beq x2, x0, DONE  
      addi x1, x1, -1  
      addi x2, x2, 2  
      j loop  
DONE:  

```

### **C.) Implementing Count Trailing Zeros (CTZ) in ALU**

To implement the Count Trailing Zeros (CTZ) operation in hardware, a new control signal `CTZ` can be introduced in the control unit. When `CTZ` is set to 1, all other control signals are set to 0 except for `RegWrite`, which remains 1. This signal is directly connected to the ALU, where the CTZ computation is performed. The implementation uses a loop running from 32 down to 0 to determine the number of trailing zeros efficiently.

```verilog
module ALU (
    input [3:0] ALUCtl,
    input CTZ,  // New control flag for CTZ operation
    input [31:0] A, B,
    output reg [31:0] ALUOut,
    output zero
);
    
    // Hardware implementable CTZ using a loop from 32 to 0
    reg [4:0] ctz_result;
    integer i;
    
    always @(*) begin
        if (CTZ) begin
            ctz_result = 32;
            for (i = 31; i >= 0; i = i - 1) begin
                if (A[i]) begin
                    ctz_result = 31 - i;
                    break;
                end
            end
            ALUOut = (A == 0) ? 32 : ctz_result; // If input is zero, return 32
        end else begin
            case(ALUCtl)
                // Other ALU operations...
            endcase
        end
    end
    
    // Zero flag is high when the ALU result is zero.
    assign zero = (ALUOut == 32'd0);
    
endmodule

```

This implementation ensures that the ALU can efficiently compute the number of trailing zeros in a 32-bit input using a simple loop. If `A` is zero, the function returns 32; otherwise, it finds the index of the least significant 1-bit and calculates the trailing zero count accordingly.
