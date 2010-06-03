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

entity tb_po is
	
end tb_po;

architecture test of tb_po is
	constant clk_cycles : integer := 10;
	constant clk_period : time := 20 ns;
	
	component PO
		Port(
			CLK : in std_logic;
			
			ADPROG : out std_logic_vector(15 downto 0);
			DPROG : in std_logic_vector(15 downto 0);
			IR : out std_logic_vector(15 downto 0);
			
			ADDATA : out std_logic_vector(15 downto 0);
			DDATAIN : in std_logic_vector(15 downto 0);
			DDATAOUT : out std_logic_vector(15 downto 0);
			
			PIN : in std_logic_vector(15 downto 0);
			POUT : out std_logic_vector(15 downto 0);
			
			COND : out std_logic;
			
			EIR : in std_logic;
			
			EPC, CLRPC, LDPC, SelPC, SelPCOff : in std_logic;
			
			op : in std_logic_vector(5 downto 0);
			SelCond : in std_logic_vector(2 downto 0);
			ImmOff : in std_logic_vector(15 downto 0);
			
			SelRIn ,SelRa, SelRb, SelRd : in std_logic_vector(2 downto 0);
			
			ERd, ECarry, EOut : in std_logic
		);
	end component;
	
	signal CLK : std_logic;
	signal ADPROG : std_logic_vector(15 downto 0);
	signal DPROG : std_logic_vector(15 downto 0);
	signal IR : std_logic_vector(15 downto 0);
	signal ADDATA : std_logic_vector(15 downto 0);
	signal DDATAIN : std_logic_vector(15 downto 0);
	signal DDATAOUT : std_logic_vector(15 downto 0);
	signal PIN : std_logic_vector(15 downto 0);
	signal POUT : std_logic_vector(15 downto 0);
	signal COND : std_logic;
	signal EIR : std_logic;
	signal EPC, CLRPC, LDPC, SelPC, SelPCOff : std_logic;
	signal op : std_logic_vector(5 downto 0);
	signal SelCond : std_logic_vector(2 downto 0);
	signal ImmOff : std_logic_vector(15 downto 0);
	signal SelRIn ,SelRa, SelRb, SelRd : std_logic_vector(2 downto 0);
	signal ERd, ECarry, EOut : std_logic;
	signal CE, OE, WE : std_logic;
begin
	uut : PO
	port map(
		CLK=>CLK,
		ADPROG=>ADPROG,
		DPROG=>DPROG,
		IR=>IR,
		ADDATA=>ADDATA,
		DDATAIN=>DDATAIN,
		DDATAOUT=>DDATAOUT,
		PIN=>PIN,
		POUT=>POUT,
		EIR=>EIR,
		EPC=>EPC,
		CLRPC=>CLRPC,
		LDPC=>LDPC,
		ERd=>ERd,
		ECarry=>ECarry,
		EOut=>EOut,
		SelPC=>SelPC,
		SelPCOff=>SelPCOff,
		SelRIn=>SelRIn,
		SelRa=>SelRa,
		SelRb=>SelRb,
		SelRd=>SelRd,
		op=>op,
		COND=>COND,
		SelCond=>SelCond,
		ImmOff=>ImmOff
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
		
		op <= "000000";
		SelRb <= "000";
		SelRa <= "000";
		SelRd <= "000";
		SelCond <= "000";
		
		-- default values to avoid latch inference
		SelRIn <= "000";
		SelPC <= '0' ;
		SelPCOff <= '0' ;
		ImmOff <= x"0000";
		
		-- no PC change, no IR change unless otherwise notified
		EPC <= '0' ;
		EIR <= '0' ;
		LDPC <= '0' ;
		CLRPC <= '0' ;
		SelPC <= '0' ;
		
		-- no RAM I/O unless otherwise notified
		CE <= '1' ;
		WE <= '0' ;
		OE <= '0' ;
			
		-- no port output unless otherwise notified
		EOUT <= '0' ;
		
		-- no register change unless otherwise notified
		ERd <= '0' ;
		ECarry <= '0' ;
		
		CLRPC <= '1' ;
		wait for clk_period * 2;
		
		CLRPC <= '0' ;
		EPC <= '1' ;
		wait for clk_period * 2;
		
		EPC <= '0' ;
		wait for clk_period * 2;
		
		CLRPC <= '1' ;
		wait for clk_period * 2;
		
		CLRPC <= '0' ;
		EPC <= '1' ;
		wait for clk_period * 2;
		
		EPC <= '0' ;
		wait for clk_period * 4;
		
		CLRPC <= '1' ;
		EPC <= '1' ;
		wait for clk_period * 2;
		
		CLRPC <= '0' ;
		wait;
	end process;
	
end test;
