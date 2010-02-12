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

entity Processeur is
	Port(
		ADPROG : out std_logic_vector(15 downto 0);
		DPROG : in std_logic_vector(15 downto 0);
		
		ADDATA, DDATAOUT : out std_logic_vector(15 downto 0);
		DDATAIN : in std_logic_vector(15 downto 0);
		
		CLK, RESET : in std_logic;
		CE, WE, OE : out std_logic;
		
		PIN : in std_logic_vector(15 downto 0);
		POUT : out std_logic_vector(15 downto 0)
	);
end Processeur;

architecture Behavioral of Processeur is
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
	
	component FSM
		Port(
			CLK : in std_logic;
			RESET : in std_logic;
			IR : in std_logic_vector(15 downto 0);
			
			COND : in std_logic;
			
			EIR : out std_logic;
			
			EPC, CLRPC, LDPC, SelPC, SelPCOff : out std_logic;
			
			op : out std_logic_vector(5 downto 0);
			SelCond : out std_logic_vector(2 downto 0);
			ImmOff : out std_logic_vector(15 downto 0);
			
			SelRIn, SelRa, SelRb, SelRd : out std_logic_vector(2 downto 0);
			
			ERd, ECarry, EOut : out std_logic;
			
			CE, WE, OE : out std_logic
		);
	end component ;
	
	signal IR : std_logic_vector(15 downto 0);
	signal SelCond : std_logic_vector(2 downto 0);
	signal ImmOff : std_logic_vector(15 downto 0);
	signal op : std_logic_vector(5 downto 0);
	signal EIR, EPC, CLRPC, LDPC, ERd, ECarry, EOut, COND : std_logic;
	signal SelPC, SelPCOff : std_logic;
	signal SelRIn, SelRa, SelRb, SelRd : std_logic_vector(2 downto 0);
begin
	cFSM : FSM
	port map (
		CLK=>CLK,
		RESET=>RESET,
		IR=>IR,
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
		ImmOff=>ImmOff,
		CE=>CE,
		WE=>WE,
		OE=>OE
	);
	
	cDataPath : PO
	port map (
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
	
end Behavioral;
