----------------------------------------------------------------------------------
--
-- Copyright 2010 Hugues Bruant. All rights reserved.
--
-- <hugues.bruant@ensimag.imag.fr>
--
-- This file is part of a school project and licensed under the terms of FreeBSD
-- license (2-clause BSD also refered to as Simplified BSD License)
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--
-- Here'are the tricks with VHDL testbench : 
--	* you need to create a test entity
--	* you need to manually clock the simulation in a process
--	* you can send other stimuli in one (or more) other process(es)
--	* you have to end the feeding processes with a wait statement
--

entity tb_ram is
	
end tb_ram;

architecture test of tb_ram is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	constant clk_hperiod : time := 10 ns;
	
	component RAMDoublePort is
    Port ( AD1 : in  STD_LOGIC_VECTOR (12 downto 0);
           AD2 : in  STD_LOGIC_VECTOR (12 downto 0);
           DIN1 : in  STD_LOGIC_VECTOR (15 downto 0);
           DOUT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           WE1 : in  STD_LOGIC;
           DOUT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           OE1 : in  STD_LOGIC;
           CE1 : in  STD_LOGIC;
			  CLK : in STD_LOGIC);
	end component;
	
	signal CLK, CE1, OE1, WE1 : std_logic;
	signal AD1 : std_logic_vector(12 downto 0) := '1' & x"2C0";
	signal AD2 : std_logic_vector(12 downto 0) := (others => '0' );
	signal DIN1, DOUT1, DOUT2 : std_logic_vector(15 downto 0);
begin
	uut : RAMDoublePort
	port map(
		CLK=>CLK,
		AD1=>AD1,
		CE1=>CE1,
		OE1=>OE1,
		WE1=>WE1,
		DIN1=>DIN1,
		DOUT1=>DOUT1,
		AD2=>AD2,
		DOUT2=>DOUT2
	);
	
	-- clock the simulation
	clock_gen : process
	begin
		CLK <= '1' ;
		wait for clk_hperiod;
		CLK <= '0' ;
		wait for clk_hperiod;
	end process clock_gen;
	
	addr_up : process(CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			AD1 <= AD1 + 1;
			AD2 <= AD2 - 1;
		end if;
	end process;
	
	-- feed some input stimuli to the simulation
	tb : process
	begin
		CE1 <= '1' ;
		OE1 <= '1' ;
		WE1 <= '0' ;
		
		DIN1 <= x"FFFF";
		
		
		wait;
	end process;
	
end test;
