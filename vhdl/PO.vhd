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
			CLK, E : in std_logic;
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
			CLK, E, I, R : in std_logic;
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
	
	signal sIR, sPC, sPCn, sPCi, sPCoff : std_logic_vector(15 downto 0);
	
	signal sUAL : std_logic_vector(15 downto 0);
	signal sCin, sCout : std_logic;
	
	signal sNotLDPC : std_logic;
	
	-- damn it : id are not case sensistive and SRA is already defined (Shift Right Arithmetic)
	signal sigRa, sRb, sRd, sR0, sR1, sR2, sR3, sR4, sR5, sR6, sR7 : std_logic_vector(15 downto 0);
	
	signal ER0, ER1, ER2, ER3, ER4, ER5, ER6, ER7 : std_logic;
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
	
	cPC : reg16inc
	port map(
		CLK=>CLK,
		D=>sPCn,
		Q=>sPC,
		E=>EPC,
		I=>sNotLDPC,
		R=>CLRPC
	);
	
	sNotLDPC <= not LDPC;
	
	-- compute intermediate PC value (PC + offset)
	cPCi : add16
	port map(
		A=>sPC,
		B=>sPCoff,
		S=>sPCi
	);
	
	-- select offset to add to PC for rel jump (register or immediate)
	cPCoffsel : mux_2_16
	port map(
		Sel=>SelPCOff,
		I0=>ImmOff,
		I1=>sRb,
		S=>sPCoff
	);
	
	-- select next PC value (absolute or relative jump)
	cPCsel : mux_2_16
	port map(
		Sel=>SelPC,
		I0=>sPCi,
		I1=>sRb,
		S=>sPCn
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
	
	cR0 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR0,
		E=>ER0,
		R=>'0'
	);
	
	cR1 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR1,
		E=>ER1,
		R=>'0'
	);
	
	cR2 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR2,
		E=>ER2,
		R=>'0'
	);
	
	cR3 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR3,
		E=>ER3,
		R=>'0'
	);
	
	cR4 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR4,
		E=>ER4,
		R=>'0'
	);
	
	cR5 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR5,
		E=>ER5,
		R=>'0'
	);
	
	cR6 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR6,
		E=>ER6,
		R=>'0'
	);
	
	cR7 : reg16
	port map(
		CLK=>CLK,
		D=>sRd,
		Q=>sR7,
		E=>ER7,
		R=>'0'
	);
	
	cSelRa : mux_8_16
	port map(
		Sel=>SelRa,
		I0=>sR0,
		I1=>sR1,
		I2=>sR2,
		I3=>sR3,
		I4=>sR4,
		I5=>sR5,
		I6=>sR6,
		I7=>sR7,
		S=>sigRa
	);
	
	cSelRb : mux_8_16
	port map(
		Sel=>SelRb,
		I0=>sR0,
		I1=>sR1,
		I2=>sR2,
		I3=>sR3,
		I4=>sR4,
		I5=>sR5,
		I6=>sR6,
		I7=>sR7,
		S=>sRb
	);
	
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
		S=>sRd
	);
	
	cSelRd : demux_8_1
	port map(
		Sel=>SelRd,
		I=>ERd,
		S0=>ER0,
		S1=>ER1,
		S2=>ER2,
		S3=>ER3,
		S4=>ER4,
		S5=>ER5,
		S6=>ER6,
		S7=>ER7
	);
	
	ADDATA <= sigRa;
	
	-- UAL and related
	
	cUAL : UAL
	port map(
		A=>sigRa,
		B=>sRb,
		S=>sUAL,
		CIN=>sCin,
		COUT=>sCout,
		op=>op
	);
	
	cCarry : reg1
	port map(
		CLK=>CLK,
		E=>ECarry,
		D=>sCout,
		Q=>sCin
	);
	
	-- memory
	
	cSelRs : mux_8_16
	port map(
		Sel=>SelRd,
		I0=>sR0,
		I1=>sR1,
		I2=>sR2,
		I3=>sR3,
		I4=>sR4,
		I5=>sR5,
		I6=>sR6,
		I7=>sR7,
		S=>DDATAOUT
	);
	
	-- ports
	
	cRout : reg16
	port map(
		CLK=>CLK,
		D=>sRb,
		Q=>POUT,
		E=>EOUT,
		R=>'0'
	);
	
end Behavioral;
