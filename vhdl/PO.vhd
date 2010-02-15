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

entity PO is
	Port(
		DPROG, DDATAIN, PIN : in std_logic_vector(15 downto 0);
		
		ADPROG, ADDATA, DDATAOUT, POUT, IR : out std_logic_vector(15 downto 0);
		
		COND : out std_logic;
		
		CLK, SelPC, SelPCOff, CLRPC : in std_logic;
		
		op : in std_logic_vector(5 downto 0);
		SelCond : in std_logic_vector(2 downto 0);
		ImmOff : in std_logic_vector(15 downto 0);
		
		SelRIn, SelRa, SelRb, SelRd : in std_logic_vector(2 downto 0);
		
		EIR, EPC, LDPC, ERd, ECarry, EOut : in std_logic
		
		--
		-- Note on divergence from proposed solution :
		--
		--	* PC "block" use a "private" adder instead of the UAL
		--	* SelPC : switch between relative (0) and absolute (1) load (jumps)
		--	* SelPCOff : switch between immediate (0) and register (1) offset for relative loads
		--	* abstract away PC increment in a reg16inc component
		--
	);
end PO;

architecture Behavioral of PO is
	component reg1
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic;
			Q : out std_logic
		);
	end component;
	
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component reg16inc
		Port(
			CLK, E, L, I, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component mux_2_16
		Port(
			Sel : in std_logic;
			I0, I1 : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component mux_4_16
		Port(
			Sel : in std_logic_vector(1 downto 0);
			I0, I1, I2, I3 : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component mux_8_16
		Port(
			Sel : in std_logic_vector(2 downto 0);
			I0, I1, I2, I3, I4, I5, I6, I7 : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component demux_8_1
		Port(
			Sel : in std_logic_vector(2 downto 0);
			I : in std_logic;
			S0, S1, S2, S3, S4, S5, S6, S7 : out std_logic
		);
	end component;
	
	component add16
		Port(
			A, B : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component cond_checker
		Port(
			I : in std_logic_vector(15 downto 0);
			C : in std_logic_vector(2 downto 0);
			R : out std_logic
		);
	end component;
	
	component UAL
		Port (
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			op : in std_logic_vector(5 downto 0);
			CIN : in std_logic;
			S : out std_logic_vector(15 downto 0);
			COUT : out std_logic
		);
	end component;
	
	type reg16array is array (integer range <>) of std_logic_vector(15 downto 0);
	signal sR: reg16array(7 downto 0);
	signal sRegE : std_logic_vector(7 downto 0);
	
	signal sigRa, sigRb, sigRd : std_logic_vector(15 downto 0);
	
	signal sIR : std_logic_vector(15 downto 0);
	
	signal sUAL : std_logic_vector(15 downto 0);
	signal sCrst, sCin, sCout : std_logic;
	
	signal sEPCprev : std_logic;
	signal sPC, sPCin, sPCnext, sPCprev, sPCIR, sPCrel, sPCabs, sPCload : std_logic_vector(15 downto 0);
begin
	
	-- internal registers (PC, IR, SP) and related
	cIR : reg16
	port map(
		CLK=>CLK,
		D=>DPROG,
		Q=>sIR,
		E=>EIR,
		R=>'0'
	);
	
	IR <= sIR;
	
	cPC : reg16
	port map(
		CLK=>CLK,
		D=>sPCin,
		Q=>sPC,
		E=>EPC,
		R=>CLRPC
	);
	
	
	-- keep track of value of PC associated with IR
	-- to reuse it in absolute jumps.
	-- this is required by instruction pipelining :
	--  clk    ^    ^
	--  ad   a   b    c
	--  d       m(a) m(b)
	--  ir           m(a)
	
	cPCprev : reg16
	port map(
		CLK=>CLK,
		D=>sPC,
		Q=>sPCprev,
		E=>sEPCprev,
		R=>'0'
	);
	
	cPCIR : reg16
	port map(
		CLK=>CLK,
		D=>sPCprev,
		Q=>sPCIR,
		E=>sEPCprev,
		R=>'0'
	);
	
	sEPCprev <= EPC or CLRPC;
	
	sPCnext <= std_logic_vector(unsigned(sPC) + 1);
	
	cMuxPCin : mux_2_16
	port map(
		Sel=>LDPC,
		I0=>sPCnext,
		I1=>sPCload,
		S=>sPCin
	);
	
	cMuxPCoff : mux_2_16
	port map(
		Sel=>SelPCOff,
		I0=>ImmOff,
		I1=>sigRb,
		S=>sPCabs
	);
	
	sPCrel <= std_logic_vector(unsigned(sPCIR) + unsigned(sPCabs));
	
	cMuxPCload : mux_2_16
	port map(
		Sel=>SelPC,
		I0=>sPCrel,
		I1=>sPCabs,
		S=>sPCload
	);
	
	ADPROG <= sPC;
	
	-- condition checker
	cCC : cond_checker
	port map(
		I=>sigRa,
		C=>SelCond,
		R=>COND
	);
	
	-- gp registers and related
	
	cRegs: for idx in sR'Range generate
		cReg: reg16
		port map(
			CLK=>CLK,
			D=>sigRd,
			Q=>sR(idx),
			E=>sRegE(idx),
			R=>'0'
		);
	end generate;
	
-- 	cSelRa : mux_8_16
-- 	port map(
-- 		Sel=>SelRa,
-- 		I0=>sR(0),
-- 		I1=>sR(1),
-- 		I2=>sR(2),
-- 		I3=>sR(3),
-- 		I4=>sR(4),
-- 		I5=>sR(5),
-- 		I6=>sR(6),
-- 		I7=>sR(7),
-- 		S=>sigRa
-- 	);
-- 	
-- 	cSelRb : mux_8_16
-- 	port map(
-- 		Sel=>SelRb,
-- 		I0=>sR(0),
-- 		I1=>sR(1),
-- 		I2=>sR(2),
-- 		I3=>sR(3),
-- 		I4=>sR(4),
-- 		I5=>sR(5),
-- 		I6=>sR(6),
-- 		I7=>sR(7),
-- 		S=>sigRb
-- 	);
	
	sigRa <= sR(to_integer(unsigned(SelRa)));
	sigRb <= sR(to_integer(unsigned(SelRb)));
	
	cSelRIn : mux_8_16
	port map(
		Sel=>SelRIn,
		I0=>sUAL,
		I1=>DDATAIN,
		I2=>sPC,
		I3=>PIN,
		I4=>ImmOff,
		I5=>x"0000",
		I6=>x"0000",
		I7=>x"0000",
		S=>sigRd
	);
	
	cSelRd : demux_8_1
	port map(
		Sel=>SelRd,
		I=>ERd,
		S0=>sRegE(0),
		S1=>sRegE(1),
		S2=>sRegE(2),
		S3=>sRegE(3),
		S4=>sRegE(4),
		S5=>sRegE(5),
		S6=>sRegE(6),
		S7=>sRegE(7)
	);
	
	ADDATA <= sigRa;
	
	-- UAL and related
	
	cUAL : UAL
	port map(
		A=>sigRa,
		B=>sigRb,
		S=>sUAL,
		CIN=>sCin,
		COUT=>sCout,
		op=>op
	);
	
	cCarry : reg1
	port map(
		CLK=>CLK,
		E=>ECarry,
		R=>sCrst,
		D=>sCout,
		Q=>sCin
	);
	
	sCrst <= '0';
	
	-- memory
	
	DDATAOUT <= sR(to_integer(unsigned(SelRd)));
	
	-- ports
	
	cRout : reg16
	port map(
		CLK=>CLK,
		D=>sigRb,
		Q=>POUT,
		E=>EOUT,
		R=>'0'
	);
	
end Behavioral;
