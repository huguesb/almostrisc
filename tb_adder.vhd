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

entity tb_adder is
	
end tb_adder;

architecture test of tb_adder is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	constant clk_hperiod : time := 10 ns;
	
	component fast_adder
		generic ( size : natural := 16 ) ;
		
		Port(
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			Cin : in std_logic;
			
			S : out std_logic_vector(15 downto 0);
			Cout : out std_logic
		);
	end component;
	
	signal CLK : std_logic;
	signal Cin, Cout : std_logic;
	signal A, B, S : std_logic_vector(15 downto 0);
begin
	uut : fast_adder
	port map(
		A=>A,
		B=>B,
		Cin=>Cin,
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
		A <= x"0000";
		B <= x"0000";
		Cin <= '1' ;
		
		for i in 0 to 100 loop
			wait for clk_period;
			
			B <= A;
			A <= S;
			Cin <= Cout;
		end loop;
		
		wait;
	end process;
	
end test;
