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

entity tb_fifo is
	
end tb_fifo;

architecture test of tb_fifo is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	constant clk_hperiod : time := 10 ns;
	
	component FIFO is
		generic (
			bits  : integer := 16;
			words : integer := 4
		);
		
		port (
			CLK, RESET : in  std_logic;
			
			OE, WE : in std_logic;
			
			DIN  : in  std_logic_vector(bits-1 downto 0);
			DOUT : out std_logic_vector(bits-1 downto 0);
			
			full : out std_logic;
			empty : out std_logic
		);
	end component;
	
	signal CLK, RESET : std_logic;
	signal OE, WE : std_logic;
	signal DIN, DOUT : std_logic_vector(15 downto 0);
	signal full, empty : std_logic;
begin
	uut : FIFO
	port map(
		CLK=>CLK,
		RESET=>RESET,
		OE=>OE,
		WE=>WE,
		DIN=>DIN,
		DOUT=>DOUT,
		full=>full,
		empty=>empty
	);
	
	-- clock the simulation
	clock_gen : process is
	begin
		CLK <= '1' ;
		wait for clk_hperiod;
		CLK <= '0' ;
		wait for clk_hperiod;
	end process clock_gen;
	
	
	-- feed some input stimuli to the simulation
	tb : process
	begin
		RESET <= '1' ;
		
		OE <= '0' ;
		WE <= '0' ;
		DIN <= x"0000";
		
		wait for clk_period;
		
		RESET <= '0' ;
		
		WE <= '1' ;
		DIN <= x"1234";
		wait for clk_period;
		
		DIN <= x"5678";
		wait for clk_period;
		
		DIN <= x"9ABC";
		wait for clk_period;
		
		DIN <= x"DEF0";
		wait for clk_period;
		
		DIN <= x"0FED";
		wait for clk_period;
		
		DIN <= x"CBA9";
		wait for clk_period;
		
		DIN <= x"8765";
		wait for clk_period;
		
		DIN <= x"4321";
		wait for clk_period;
		
		WE <= '0' ;
		OE <= '1' ;
		
		wait for clk_period * 8;
		
		
		WE <= '1' ;
		OE <= '1' ;
		
		DIN <= x"0001";
		wait for clk_period;
		DIN <= x"0002";
		wait for clk_period;
		DIN <= x"0003";
		wait for clk_period;
		DIN <= x"0004";
		wait for clk_period;
		DIN <= x"0005";
		wait for clk_period;
		
		WE <= '0' ;
		OE <= '1' ;
		wait for clk_period * 2;
		
		WE <= '1' ;
		OE <= '0' ;
		wait for clk_period * 16;
		
		WE <= '0' ;
		
		wait;
	end process;
	
end test;
