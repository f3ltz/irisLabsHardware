module SingleCycleCPU (
    input clk,
    input start
    
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,

// Declare wires for interconnections
wire [31:0] pc;         // current PC value
wire [31:0] pc_input;   // next PC value selected by Mux
wire [31:0] pc_plus4;   // PC + 4 value
wire [31:0] inst;       // fetched instruction
wire [6:0] opcode;     // opcode from instruction

// Control signals
wire branch;
wire memRead;
wire memtoReg;
wire memWrite;
wire ALUSrc;
wire regWrite;
wire [1:0]  ALUOp;

// Register file wires
wire [31:0] readData1;
wire [31:0] readData2;

// Immediate and ALU related wires
wire [31:0] imm;
wire [31:0] shiftedImm;
wire [31:0] branch_target;
wire branch_select;  // branch decision (branch signal & ALU zero flag)
wire [31:0] alu_in2;        // second operand for the ALU
wire [3:0]  ALUCtl;
wire [31:0] alu_out;
wire zero;           // zero flag from ALU

// Data memory output and write-back data
wire [31:0] memReadData;
wire [31:0] result;
	
	// Extract opcode
assign opcode = inst[6:0];
	// Branch select signal: branch is taken if branch control is high and ALU signals zero.
assign branch_select = branch & zero;

// Holds the current pc value
// When start is low, resets the pc
PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_input),
    .pc_o(pc)
);


// Adder: compute pc+4
Adder m_Adder_1(
    .a(pc),
    .b(32'd4),
    .sum(pc_plus4)
);


// Fetches the instruction at the current pc
InstructionMemory m_InstMem(
    .readAddr(pc),
    .inst(inst)
);


// Control unit generates control signals based on the opcode
Control m_Control(
    .opcode(opcode),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);


Register m_Register(
	.clk(clk),
	.rst(start),      
	.regWrite(regWrite),
	.readReg1(inst[19:15]),
	.readReg2(inst[24:20]),
	.writeReg(inst[11:7]),
	.writeData(result),
	.readData1(readData1),
	.readData2(readData2)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(inst),
    .imm(imm)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(shiftedImm)
);

Adder m_Adder_2(
    .a(pc),
    .b(shiftedImm),
    .sum(branch_target)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(branch_select),
    .s0(pc_plus4),
    .s1(branch_target),
    .out(pc_input)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(alu_in2)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(inst[30]),
    .funct3(inst[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUCtl(ALUCtl),
    .A(readData1),
    .B(alu_in2),
    .ALUOut(alu_out),
    .zero(zero)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(alu_out),
    .writeData(readData2),
    .readData(memReadData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(alu_out),
    .s1(memReadData),
    .out(result)
);

endmodule
