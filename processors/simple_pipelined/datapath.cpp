#define NUM_REGISTERS 8

#define OPCODE(inst) (((inst) >> 26) & 0x0000003F)

#define RS(inst) ((0x03E00000 & (inst)) >> 21)
#define RT(inst) ((0x001F0000 & (inst)) >> 16)
#define RD(inst) ((0x0000F800 & (inst)) >> 11)

#define SHAMT(inst) ((0x000007C0 & (inst)) >> 6)
#define FUNCT(inst) ((0x0000003F & (inst)))

#define IMM(inst) ((0x0000FFFF & (inst)))

void datapath(unsigned int instrMem[64], unsigned int dataMem[64]) {
	//SETUP
	//------------------------
	int reg[NUM_REGISTERS];

	int PC = 0;
	bool exit = false;

	//MAIN LOOP
	//------------------------
	loop:while(true) {
		if(exit)
			return;

		//get next instruction
		unsigned int instr = instrMem[PC];
		PC += 1;

		//instruction decode
		switch(OPCODE(instr)) {
		case 0:		//R-type
			//ALU
			switch(FUNCT(instr)) {
			case 0x20:	//10 0000	Add
				reg[RS(instr)] = reg[RT(instr)] + reg[RD(instr)];
				break;
			case 0x22:	//10 0010	Sub
				reg[RS(instr)] = reg[RT(instr)] - reg[RD(instr)];
				break;
			case 0x24:	//10 0100	AND
				reg[RS(instr)] = reg[RT(instr)] & reg[RD(instr)];
				break;
			case 0x25:	//10 0101	OR
				reg[RS(instr)] = reg[RT(instr)] | reg[RD(instr)];
				break;
			case 0x2A:	//10 1010	SLT
				if(reg[RT(instr)] < reg[RD(instr)])
					reg[RS(instr)] = 1;
				else
					reg[RS(instr)] = 0;
				break;
			default:
				break;
			}

			break;
			case 35:	//load	0x23
				reg[RS(instr)] = dataMem[IMM(instr)];
				break;
			case 43:	//store	0x2B
				dataMem[IMM(instr)] = reg[RS(instr)];
				break;
			default:
				exit = true;
				break;
		}
	}
}
