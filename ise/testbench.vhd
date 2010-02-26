
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:22:53 02/09/2010
-- Design Name:   FSM
-- Module Name:   /home/k4user/poly-imag/archi2/projet/ise/testbench.vhd
-- Project Name:  ProcesseurAndCo
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FSM
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testbench_vhd IS
END testbench_vhd;

ARCHITECTURE behavior OF testbench_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT FSM
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		IR : IN std_logic_vector(15 downto 0);
		COND : IN std_logic;          
		EIR : OUT std_logic;
		EPC : OUT std_logic;
		CLRPC : OUT std_logic;
		LDPC : OUT std_logic;
		SelPC : OUT std_logic;
		SelPCOff : OUT std_logic;
		op : OUT std_logic_vector(5 downto 0);
		SelCond : OUT std_logic_vector(2 downto 0);
		ImmOff : OUT std_logic_vector(15 downto 0);
		SelRIn : OUT std_logic_vector(2 downto 0);
		SelRa : OUT std_logic_vector(2 downto 0);
		SelRb : OUT std_logic_vector(2 downto 0);
		SelRd : OUT std_logic_vector(2 downto 0);
		ERd : OUT std_logic;
		ECarry : OUT std_logic;
		EOut : OUT std_logic;
		CE : OUT std_logic;
		WE : OUT std_logic;
		OE : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL CLK :  std_logic := '0';
	SIGNAL RESET :  std_logic := '0';
	SIGNAL COND :  std_logic := '0';
	SIGNAL IR :  std_logic_vector(15 downto 0) := (others=>'0');

	--Outputs
	SIGNAL EIR :  std_logic;
	SIGNAL EPC :  std_logic;
	SIGNAL CLRPC :  std_logic;
	SIGNAL LDPC :  std_logic;
	SIGNAL SelPC :  std_logic;
	SIGNAL SelPCOff :  std_logic;
	SIGNAL op :  std_logic_vector(5 downto 0);
	SIGNAL SelCond :  std_logic_vector(2 downto 0);
	SIGNAL ImmOff :  std_logic_vector(15 downto 0);
	SIGNAL SelRIn :  std_logic_vector(2 downto 0);
	SIGNAL SelRa :  std_logic_vector(2 downto 0);
	SIGNAL SelRb :  std_logic_vector(2 downto 0);
	SIGNAL SelRd :  std_logic_vector(2 downto 0);
	SIGNAL ERd :  std_logic;
	SIGNAL ECarry :  std_logic;
	SIGNAL EOut :  std_logic;
	SIGNAL CE :  std_logic;
	SIGNAL WE :  std_logic;
	SIGNAL OE :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: FSM PORT MAP(
		CLK => CLK,
		RESET => RESET,
		IR => IR,
		COND => COND,
		EIR => EIR,
		EPC => EPC,
		CLRPC => CLRPC,
		LDPC => LDPC,
		SelPC => SelPC,
		SelPCOff => SelPCOff,
		op => op,
		SelCond => SelCond,
		ImmOff => ImmOff,
		SelRIn => SelRIn,
		SelRa => SelRa,
		SelRb => SelRb,
		SelRd => SelRd,
		ERd => ERd,
		ECarry => ECarry,
		EOut => EOut,
		CE => CE,
		WE => WE,
		OE => OE
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
