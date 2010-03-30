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
	constant clk_hperiod : time := 10 ns;
	
	component ProcesseurAndCo is
		Port(
			CLK, RESET : in std_logic;
			
			OSCILLATOR : in std_logic;
			
			LED : out std_logic_vector(7 downto 0);
			
			ANODE : out std_logic_vector(3 downto 0);
			SEGMENT : out std_logic_vector(6 downto 0);
			
			SLIDER : in std_logic_vector(7 downto 0);
			PUSHBUTTON : in std_logic_vector(2 downto 0);
			
			HS, VS, R, G, B : out std_logic;
			
			PS2C, PS2D : inout std_logic;
			
			RXD, RXDA : in std_logic;
			TXD, TXDA : out std_logic
		);
	end component;
	
	signal CLK, RESET, OSCILLATOR : std_logic;
	
	signal HS, VS, R, G, B : std_logic;
	
	signal PIN : std_logic_vector(15 downto 0);
	signal POUT : std_logic_vector(15 downto 0);
	
	signal LED : std_logic_vector(7 downto 0);
	
	signal ANODE : std_logic_vector(3 downto 0);
	signal SEGMENT : std_logic_vector(6 downto 0);
	
	signal SLIDER : std_logic_vector(7 downto 0);
	signal PUSHBUTTON : std_logic_vector(2 downto 0);
	
	signal PS2C, PS2D : std_logic;
	
	signal RXD, RXDA, TXD, TXDA : std_logic;
begin
	uut : ProcesseurAndCo
	port map(
		CLK=>CLK,
		RESET=>RESET,
		OSCILLATOR=>OSCILLATOR,
		HS=>HS,
		VS=>VS,
		R=>R,
		G=>G,
		B=>B,
		LED=>LED,
		ANODE=>ANODE,
		SEGMENT=>SEGMENT,
		SLIDER=>SLIDER,
		PUSHBUTTON=>PUSHBUTTON,
		PS2C=>PS2C,
		PS2D=>PS2D,
		RXD=>RXD,
		TXD=>TXD,
		RXDA=>RXDA,
		TXDA=>TXDA
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
		PIN <= x"0000";
		wait for clk_period;
		
		RESET <= '0' ;
		
		PS2C <= '1' ;
		PS2D <= '1' ;
		
		wait for 50 us;
		
		
		
		-- keyboard stimuli : 33 = H
		
		-- start
		PS2D <= '0' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		-- data
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '0' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '0' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '0' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		PS2D <= '0' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		-- parity
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		-- stop
		PS2D <= '1' ;
		
		PS2C <= '0' ;
		wait for 40 us;
		PS2C <= '1' ;
		wait for 40 us;
		
		
		wait;
	end process;
	
end test;
