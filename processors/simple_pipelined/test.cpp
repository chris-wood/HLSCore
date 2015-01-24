
#include <stdio.h>


#define instr(rs,rt,rd,shamt,funct) ((0 << 26) \
		| (((rs) << 21)   & 0x03E00000) \
		| (((rt) << 16)   & 0x001F0000) \
		| (((rd) << 11)   & 0x0000F800) \
		| (((shamt) << 6) & 0x000007C0) \
		| (((funct) << 0) & 0x0000003F));

#define instl(rs,rt,addr) ((35 << 26) \
		| (((rs) << 21)   & 0x03E00000) \
		| (((rt) << 16)   & 0x001F0000) \
		| (((addr) << 0) & 0x0000003F));

#define insts(rs,rt,addr) ((43 << 26) \
		| (((rs) << 21)   & 0x03E00000) \
		| (((rt) << 16)   & 0x001F0000) \
		| (((addr) << 0) & 0x0000003F));

#define inst_end 0xFFFFFFFF

void datapath(unsigned int instrMem[], unsigned int dataMem[]);

int main() {
	printf("Calling function...\n");

	unsigned int PC = 0;

	unsigned int numInstr = 5;
	unsigned int instructions[5];
	instructions[0] = instl(1,0,0x0);
	instructions[1] = instl(2,0,0x1);
	instructions[2] = instr(0,1,2,0,0x20);
	instructions[3] = insts(0,0,0x2);
	instructions[4] = inst_end;

	unsigned int numData = 3;
	unsigned int data[] = {
			0x1,
			0x2,
			0x0,
	};

	printf("Instruction Memory:\n");
	for(int i=0; i<numInstr; i++) {
		printf("%08X\n",instructions[i]);
	}
	printf("\n");

	printf("Data Memory:\n");
	for(int i=0; i<numData; i++) {
		printf("%08X\n",data[i]);
	}
	printf("\n");

	datapath(instructions, data);

	printf("Done!\n");

	printf("Data Memory:\n");
	for(int i=0; i<numData; i++) {
		printf("%08X\n",data[i]);
	}
	printf("\n");

	return 0;
}
