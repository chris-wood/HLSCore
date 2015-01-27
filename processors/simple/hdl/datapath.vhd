----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:47:26 01/26/2015 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
	PORT(
         ap_clk : IN  std_logic;
         ap_rst : IN  std_logic;
			
         instrMem_address0 : OUT  std_logic_vector(5 downto 0);
         instrMem_ce0 : OUT  std_logic;
         instrMem_q0 : IN  std_logic_vector(31 downto 0);
			
         dataMem_address0 : OUT  std_logic_vector(5 downto 0);
         dataMem_ce0 : OUT  std_logic;
         dataMem_we0 : OUT  std_logic;
         dataMem_d0 : OUT  std_logic_vector(31 downto 0);
         dataMem_q0 : IN  std_logic_vector(31 downto 0)
        );
end datapath;

architecture Behavioral of datapath is

type reg_array is array(7 downto 0) of std_logic_vector(31 downto 0);
signal reg : reg_array;

signal pc : std_logic_vector(31 downto 0);
signal inst : std_logic_vector(31 downto 0);

type states is (fetch,execute,load,store);
signal current : states;

--signal instMem_addr : std_logic_vector(5 downto 0);
signal instMem_ce : std_logic := '0';
signal dataMem_addr : std_logic_vector(5 downto 0);
signal dataMem_ce : std_logic := '0';
signal dataMem_we : std_logic := '0';
signal dataMem_d : std_logic_vector(31 downto 0);

signal opcode : std_logic_vector(5 downto 0);
signal opcode_inst : std_logic_vector(5 downto 0);
signal rs : std_logic_vector(4 downto 0);
signal rt : std_logic_vector(4 downto 0);
signal rd : std_logic_vector(4 downto 0);
signal shamt : std_logic_vector(4 downto 0);
signal funct : std_logic_vector(5 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal imm_inst : std_logic_vector(15 downto 0);

signal aluResult : std_logic_vector(31 downto 0);

begin

	--assignments to external ports
	instrMem_address0 <= pc(5 downto 0);
	instrMem_ce0 <= '1';
	dataMem_address0 <= dataMem_addr;
	dataMem_ce0 <= '1';
	dataMem_we0 <= dataMem_we;
	dataMem_d0 <= dataMem_d;
	
	--instruction breakup	
	opcode <= instrMem_q0(31 downto 26);
	imm <= instrMem_q0(15 downto 0);
	
	opcode_inst <= inst(31 downto 26);
	rs <= inst(25 downto 21);
	rt <= inst(20 downto 16);
	rd <= inst(15 downto 11);
	shamt <= inst(10 downto 6);
	funct <= inst(5 downto 0);
	imm_inst <= inst(15 downto 0);
	
	--main statemachine for processor
	state_machine: process(ap_clk, ap_rst, current)
	begin
		if rising_edge(ap_clk) then
			--reset condition
			if ap_rst = '1' then
				current <= fetch;
				pc <= (others => '0');
			else
				case current is						
					when fetch =>
						pc <= std_logic_vector(to_unsigned(to_integer(unsigned(pc)) + 1, 32));
						current <= execute;
						inst <= instrMem_q0;
						
						case opcode is
							when "100011" =>	--load
								dataMem_addr <= imm(5 downto 0);
							when others =>
						end case;
					when execute =>						
						--instruction decode
						case opcode_inst is
							when "000000" =>	--R-type
								--ALU type decode
								case funct is
									when "100000" =>	--add
										reg(to_integer(unsigned(rs))) <= std_logic_vector(to_unsigned(	--convert back to slv
											to_integer(unsigned(	--convert to integer to perform operation
												reg(to_integer(unsigned(rt))))) 	--index into register file
											+ --perform operation
											to_integer(unsigned(	--convert to integer to perform operation
												reg(to_integer(unsigned(rd)))))	--index into register file
												, 32));
									when "100010" =>	--sub
										reg(to_integer(unsigned(rs))) <= std_logic_vector(to_unsigned(	--convert back to slv
											to_integer(unsigned(	--convert to integer to perform operation
												reg(to_integer(unsigned(rt))))) 	--index into register file
											- --perform operation
											to_integer(unsigned(	--convert to integer to perform operation
												reg(to_integer(unsigned(rd)))))	--index into register file
												, 32));
									when "100100" =>	--and
										reg(to_integer(unsigned(rs))) <= 
												reg(to_integer(unsigned(rt))) 	--index into register file
											and --perform operation
												reg(to_integer(unsigned(rd)));	--index into register file
									when "100101" =>	--or
										reg(to_integer(unsigned(rs))) <= 
												reg(to_integer(unsigned(rt))) 	--index into register file
											or --perform operation
												reg(to_integer(unsigned(rd)));	--index into register file
									when "101010" =>	--slt (set less than)
										if reg(to_integer(unsigned(rt))) < reg(to_integer(unsigned(rd))) then
											reg(to_integer(unsigned(rs))) <= x"00000001";
										else
											reg(to_integer(unsigned(rs))) <= x"00000000";
										end if;
									when others =>
								end case;
								current <= fetch;
							when "100011" =>	--load
								current <= load;
							when "101011" =>	--store
								dataMem_addr <= imm_inst(5 downto 0);
								dataMem_we <= '1';
								dataMem_d <= reg(to_integer(unsigned(rs)));
								current <= store;
							when others =>
						end case;
					when load =>
								reg(to_integer(unsigned(rs))) <= dataMem_q0;
								current <= fetch;
					when store =>
								dataMem_we <= '0';
								current <= fetch;
				end case;
			end if;
		end if;
	end process;

end Behavioral;

