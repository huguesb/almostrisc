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

entity tb_ps2 is
	
end tb_ps2;

architecture test of tb_ps2 is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	constant clk_hperiod : time := 10 ns;
	
	component PS2
		Port(
			CLK, RESET : in std_logic;
			
			PS2C, PS2D : inout std_logic;
			
			BYTE_ERROR : out std_logic;
			BYTE_AVAIL : out std_logic;
			
			AD : in std_logic_vector(1 downto 0);
			DIN : in std_logic_vector(15 downto 0);
			DOUT : out std_logic_vector(15 downto 0);
			
			CE, OE, WE : in std_logic;
			
			IRQ : out std_logic
		);
	end component;
	
	signal CLK, RESET : std_logic;
	signal CE, OE, WE : std_logic;
	signal PS2C, PS2D : std_logic;
	signal BYTE_ERROR : std_logic;
	signal BYTE_AVAIL : std_logic;
	signal AD : std_logic_vector(1 downto 0);
	signal DIN, DOUT : std_logic_vector(15 downto 0);
	signal full, empty, IRQ : std_logic;
begin
	uut : PS2
	port map(
		CLK=>CLK,
		RESET=>RESET,
		PS2C=>PS2C,
		PS2D=>PS2D,
		CE=>CE,
		OE=>OE,
		WE=>WE,
		AD=>AD,
		DIN=>DIN,
		DOUT=>DOUT,
		BYTE_AVAIL=>BYTE_AVAIL,
		BYTE_ERROR=>BYTE_ERROR,
		IRQ=>IRQ
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
		CE <= '1' ;
		OE <= '0' ;
		WE <= '0' ;
		
		AD <= "00";
		DIN <= x"0000";
		
		PS2C <= '1';
		PS2D <= '1';
		
		wait for clk_period;
		
		RESET <= '0' ;
		wait for clk_period * 20;
		
		PS2C <= '0' ;
		wait for clk_period * 2;
		PS2C <= '1' ;
		wait for clk_period * 3;
		PS2C <= '0' ;
		wait for clk_period * 2;
		
		wait for 10 us;
		
		PS2C <= '1' ;
		wait for clk_period * 3;
		PS2C <= '0' ;
		wait for clk_period * 2;
		PS2C <= '1' ;
		wait for clk_period * 3;
		
		wait for 10 us;
		
		PS2C <= '0' ;
		wait for clk_period * 2;
		PS2C <= '1' ;
		wait for clk_period * 3;
		PS2C <= '0' ;
		wait for clk_period * 2;
		
		wait for 10 us;
		
		PS2C <= '1' ;
		wait for clk_period * 3;
		PS2C <= '0' ;
		wait for clk_period * 2;
		PS2C <= '1' ;
		wait for clk_period * 3;
		
		wait;
	end process;
	
end test;
