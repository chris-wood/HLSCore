--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:44:44 01/06/2015
-- Design Name:   
-- Module Name:   C:/Users/Sam/Documents/GitHub/HLSCore/processors/simple/testing/tb_top.vhd
-- Project Name:  testing
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 

	COMPONENT dataBRAM
	PORT (
		 clka : IN STD_LOGIC;
		 ena : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT instBRAM
	PORT (
		 clka : IN STD_LOGIC;
		 ena : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	END COMPONENT;
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ap_rst : std_logic := '1';
   signal instrMem_q0 : std_logic_vector(31 downto 0) := (others => '0');
   signal dataMem_q0 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal instrMem_address0 : std_logic_vector(5 downto 0);
   signal instrMem_ce0 : std_logic;
	signal instrMem_we0 : std_logic := '0';
	signal instrMem_we_sig : std_logic_vector(0 downto 0);
	signal instrMem_d0 : std_logic_vector(31 downto 0);
   signal dataMem_address0 : std_logic_vector(5 downto 0);
   signal dataMem_ce0 : std_logic;
   signal dataMem_we0 : std_logic;
	signal dataMem_we_sig : std_logic_vector(0 downto 0);
   signal dataMem_d0 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	instrMem_we_sig(0) <= instrMem_we0;
	dataMem_we_sig(0) <= dataMem_we0;

	dataMem : dataBRAM PORT MAP (
		clka => clk,
		ena => dataMem_ce0,
		wea => dataMem_we_sig,
		addra => dataMem_address0,
		dina => dataMem_d0,
		douta => dataMem_q0
	);
  
  	instMem : instBRAM PORT MAP (
		clka => clk,
		ena => instrMem_ce0,
		wea => instrMem_we_sig,
		addra => instrMem_address0,
		dina => instrMem_d0,
		douta => instrMem_q0
	);
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          ap_clk => clk,
          ap_rst => ap_rst,
          instrMem_address0 => instrMem_address0,
          instrMem_ce0 => instrMem_ce0,
          instrMem_q0 => instrMem_q0,
          dataMem_address0 => dataMem_address0,
          dataMem_ce0 => dataMem_ce0,
          dataMem_we0 => dataMem_we0,
          dataMem_d0 => dataMem_d0,
          dataMem_q0 => dataMem_q0
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
		ap_rst <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		ap_rst <= '0';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
