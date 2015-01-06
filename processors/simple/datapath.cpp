#define NUM_REGISTERS 8


void datapath(unsigned int instrMem[64], unsigned int dataMem[64]) {
	//SETUP
	//------------------------
	int reg[NUM_REGISTERS];

	int PC = 0;

	//MAIN LOOP
	//------------------------
	while(true) {
		//get next instruction
		unsigned int instr = instrMem[PC];
		PC += 1;

		//instruction decode
		unsigned int instrType = (instr >> 26) & 0x3F; //leaving bits 31:26

		//R-type declarations
		unsigned int rs,rt,rd,shamt,funct;

		//Load/Store declarations
		unsigned int addr;

		unsigned int aluResult;

		switch(instrType) {
		case 0:		//R-type
			rs = (0x3E00000 & instr) >> 21;	//leaving bits 25:21
			rt = (0x1F0000 & instr) >> 16; //leaving bits 20:16
			rd = (0xF800 & instr) >> 11; //leaving bits 15:11
			shamt = (0x7C0 & instr) >> 6; //leaving bits 10:6
			funct = (0x3F & instr);	//leaving bits 5:0

			//ALU
			switch(funct) {
			case 0x20:	//10 0000	Add
				aluResult = reg[rt] + reg[rd];
				break;
			case 0x22:	//10 0010	Sub
				aluResult = reg[rt] - reg[rd];
				break;
			case 0x24:	//10 0100	AND
				aluResult = reg[rt] & reg[rd];
				break;
			case 0x25:	//10 0101	OR
				aluResult = reg[rt] | reg[rd];
				break;
			case 0x2A:	//10 1010	SLT
				if(reg[rt] < reg[rd])
					aluResult = 1;
				else
					aluResult = 0;
				break;
			default:
				aluResult = -1;
				break;
			}

			reg[rs] = aluResult;

			break;
			case 35:	//load	0x23
				rs = (0x3E00000 & instr) >> 21;	//leaving bits 25:21
				//rt = (0x1F0000 & instr) >> 16; //leaving bits 20:16
				addr = (0x0000FFFF & instr);

				reg[rs] = dataMem[addr];
				break;
			case 43:	//store	0x2B
				rs = (0x3E00000 & instr) >> 21;	//leaving bits 25:21
				//rt = (0x1F0000 & instr) >> 16; //leaving bits 20:16
				addr = (0x0000FFFF & instr);

				dataMem[addr] = reg[rs];
				break;
			default:
				return;
				break;
		}
	}
}
