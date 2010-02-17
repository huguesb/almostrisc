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
		
		CLK, RESET, SelPC, SelPCOff, CLRPC : in std_logic;
		
		op : in std_logic_vector(5 downto 0);
		SelCond : in std_logic_vector(2 downto 0);
		ImmOff : in std_logic_vector(15 downto 0);
		
		SelRIn, SelRa, SelRb, SelRd : in std_logic_vector(2 downto 0);
		
		EIR, EPC, LDPC, ERd, ECarry, EOut : in std_logic;
		
		SelReti : in std_logic;
		EINT : in std_logic;
		INTi : in std_logic;
		INTo : out std_logic
		
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
	-- use 16 regs instead of 8 : alternate register bank for interrupts
	signal sR : reg16array(15 downto 0);
	signal sRegE : std_logic_vector(15 downto 0);
	
	signal sigRa, sigRb, sigRd, sRin : std_logic_vector(15 downto 0);
	
	signal sUAL : std_logic_vector(15 downto 0);
	signal sCstore, sCsave, sCin, sCout : std_logic;
	
	signal sEPCprev : std_logic;
	signal sPC, sPCin, sPCinc, sPCnext, sPCprev, sPCIR, sPCorg, sPCoff, sPCload, sPCint : std_logic_vector(15 downto 0);
	
	signal sINTo : std_logic;
begin
	-- interrupt status register
	cINT : reg1
	port map(
		CLK=>CLK,
		E=>EINT,
		D=>INTi,
		Q=>sINTo,
		R=>RESET
	);
	
	INTo <= sINTo;
	
	-- interrupt return address reg
	cPCint : reg16
	port map(
		CLK=>CLK,
		E=>EINT,
		D=>sPCIR,
		Q=>sPCint,
		R=>RESET
	);
	
	-- instruction register
	cIR : reg16
	port map(
		CLK=>CLK,
		E=>EIR,
		D=>DPROG,
		Q=>IR,
		R=>RESET
	);
	
	-- program counter
	cPC : reg16
	port map(
		CLK=>CLK,
		E=>EPC,
		D=>sPCin,
		Q=>sPC,
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
		E=>sEPCprev,
		D=>sPC,
		Q=>sPCprev,
		R=>RESET
	);
	
	cPCIR : reg16
	port map(
		CLK=>CLK,
		E=>sEPCprev,
		D=>sPCprev,
		Q=>sPCIR,
		R=>RESET
	);
	
	sEPCprev <= EPC or CLRPC;
	
	-- mux and adders to select value to load into pc
	
	sPCinc <= std_logic_vector(unsigned(sPC) + 1);
	
	cMuxPCnext : mux_2_16
	port map(
		Sel=>SelReti,
		I0=>sPCinc,
		I1=>sPCint,
		S=>sPCnext
	);
	
	cMuxPCin : mux_2_16
	port map(
		Sel=>LDPC,
		I0=>sPCnext,
		I1=>sPCload,
		S=>sPCin
	);
	
	sPCorg <= sPCIR and (15 downto 0 => not SelPC);
	
	cMuxPCoff : mux_2_16
	port map(
		Sel=>SelPCOff,
		I0=>ImmOff,
		I1=>sigRb,
		S=>sPCoff
	);
	
	sPCload <= std_logic_vector(unsigned(sPCorg) + unsigned(sPCoff));
	
	-- gp registers and related
	
	cRegs: for idx in sR'Range generate
		cReg: reg16
		port map(
			CLK=>CLK,
			D=>sigRd,
			Q=>sR(idx),
			E=>sRegE(idx),
			R=>RESET
		);
	end generate;
	
	sigRa <= sR(to_integer(sINTo & unsigned(SelRa)));
	sigRb <= sR(to_integer(sINTo & unsigned(SelRb)));
	
	cSelRd : process(SelRd, ERd)
	begin
		sRegE <= (others => '0' );
		sRegE(to_integer(sINTo & unsigned(SelRd))) <= ERd ;
	end process;
	
	ADPROG <= sPC;
	ADDATA <= sigRa;
	
	-- SelRin coding :
	--	000	: DDATAIN
	--	001	: PCIR + 1 = PCprev
	--	010	: PIN
	--	011	: ImmOff
	--	100	: UAL
	
	-- prioritize UAL to decrease critical timings
	cSelRInUAL : mux_2_16
	port map(
		Sel=>SelRIn(2),
		I0=>sRin,
		I1=>sUAL,
		S=>sigRd
	);
	
	cSelRIn : mux_4_16
	port map(
		Sel=>SelRIn(1 downto 0),
		I0=>DDATAIN,
		I1=>sPCprev,
		I2=>PIN,
		I3=>ImmOff,
		S=>sRin
	);
	
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
		R=>RESET,
		D=>sCstore,
		Q=>sCin
	);
	
	cCarrySave : reg1
	port map(
		CLK=>CLK,
		E=>INTi,
		R=>RESET,
		D=>sCin,
		Q=>sCsave
	);
	
	sCstore <= (sCsave and SelReti) or (sCout and not SelReti);
	
	-- memory
	
	DDATAOUT <= sR(to_integer(sINTo & unsigned(SelRd)));
	
	-- ports
	
	cRout : reg16
	port map(
		CLK=>CLK,
		D=>sigRb,
		Q=>POUT,
		E=>EOUT,
		R=>RESET
	);
	
	-- condition checker
	cCC : cond_checker
	port map(
		I=>sigRa,
		C=>SelCond,
		R=>COND
	);
	
end Behavioral;
