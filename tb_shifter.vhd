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
use ieee.numeric_std.all;

entity tb_shifter is
	
end tb_shifter;

architecture test of tb_shifter is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	constant clk_hperiod : time := 10 ns;
	
	component shifter is
		generic(
			size : natural := 16;
			level : natural := 4
		);
		
		Port(
			A : in unsigned(size -1 downto 0);
			D : in unsigned(level -1 downto 0);
			Right : in std_logic;
			Rotate : in std_logic;
			
			S : out unsigned(size -1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	signal CLK : std_logic;
	signal Right, Cin, Cout : std_logic;
	signal A, S : unsigned(15 downto 0);
	signal D : unsigned(3 downto 0);
begin
	uut : shifter
	port map(
		A=>A,
		D=>D,
		Right=>Right,
		Rotate=>'0',
		S=>S,
		Cout=>Cout
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
		A <= x"1248";
		D <= x"1";
		Right <= '0' ;
		
		wait for clk_period;
		
		A <= S;
		wait for clk_period;
		
		A <= S;
		wait for clk_period;
		
		A <= S;
		wait for clk_period;
		
		wait;
	end process;
	
end test;
