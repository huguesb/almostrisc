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

--
-- Here'are the tricks with VHDL testbench : 
--	* you need to create a test entity
--	* you need to manually clock the simulation in a process
--	* you can send other stimuli in one (or more) other process(es)
--	* you have to end the feeding processes with a wait statement
--

entity testbench is
	
end testbench;

architecture test of testbench is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	
	component ProcesseurAndCo is
		Port(
			CLK, RESET : in std_logic;
			
			HS, VS, R, G, B : out std_logic;
			
			PIN : in std_logic_vector(15 downto 0);
			POUT : out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal CLK, RESET : std_logic;
	
	signal HS, VS, R, G, B : std_logic;
	
	signal PIN : std_logic_vector(15 downto 0);
	signal POUT : std_logic_vector(15 downto 0);
begin
	uut : ProcesseurAndCo
	port map(
		CLK=>CLK,
		RESET=>RESET,
		HS=>HS,
		VS=>VS,
		R=>R,
		G=>G,
		B=>B,
		PIN=>PIN,
		POUT=>POUT
	);
	
	-- clock the simulation
	clock_gen : process is
	begin
		CLK <= '1' ;
		wait for clk_period;
		CLK <= '0' ;
		wait for clk_period;
	end process clock_gen;
	
	
	-- feed some input stimuli to the simulation
	tb : process
	begin
		RESET <= '1' ;
		
		wait for clk_period * 2;
		
		RESET <= '0' ;
		
		PIN <= x"FFFF";
		
		wait for clk_period * 20;
		
		PIN <= x"0000";
		
		wait for clk_period * 20;
		
		PIN <= x"FFFF";
		
		wait;
	end process;
	
end test;
