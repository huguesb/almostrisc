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
		
		ADPROG, ADDATA, DDATAOUT, POUT, IR, PIR : out std_logic_vector(15 downto 0);
		
		COND : out std_logic;
		
		CLK, RESET, SelPC, SelPCOff, CLRPC : in std_logic;
		
		op : in std_logic_vector(5 downto 0);
		SelCond : in std_logic_vector(2 downto 0);
		ImmOff : in std_logic_vector(15 downto 0);
		
		SelRIn, SelRa, SelRb, SelRd : in std_logic_vector(2 downto 0);
		
		EIR, EPC, LDPC, ERd, ECarry, EMUL, EOut : in std_logic;
		
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
	
	component fast_adder
		generic(
			size : natural := 16
		);
		
		Port(
			A : in unsigned(size -1 downto 0);
			B : in unsigned(size -1 downto 0);
			CIN : in std_logic;
			
			S : out unsigned(size -1 downto 0);
			COUT : out std_logic
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
	signal sRdin : reg16array(3 downto 0);
	signal sRegE : std_logic_vector(15 downto 0);
	
	signal sigRa, sigRb, sigRd, sRin : std_logic_vector(15 downto 0);
	
	signal sMulSelRin : std_logic_vector(2 downto 0);
	
	signal sProd : unsigned(31 downto 0);
	
	signal sUAL, sProdH, sProdL, sProdHin : std_logic_vector(15 downto 0);
	signal sCstore, sCsave, sCin, sCout, sCarry, sECarry, sCarryInt, sECarryInt : std_logic;
	
	signal sEPCprev : std_logic;
	signal sIR, sPC, sPCin, sPCinc, sPCnext, sPCprev, sPCIR, sPCorg, sPCoff, sPCload, sPCint : std_logic_vector(15 downto 0);
	
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
		Q=>sIR,
		R=>RESET
	);
	
	IR <= sIR;
	
	-- previous instruction register (pipelining constraint...)
	cPIR : reg16
	port map(
		CLK=>CLK,
		E=>EIR,
		D=>sIR,
		Q=>PIR,
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
	sPCnext <= sPCint when SelReti='1' else sPCinc;
	
	sPCoff <= sigRb when SelPCOff='1' else ImmOff;
	sPCorg <= sPCIR and (15 downto 0 => not SelPC);
	sPCload <= std_logic_vector(unsigned(sPCorg) + unsigned(sPCoff));
	
	sPCin <= sPCload when LDPC='1' else sPCnext;
	
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
	
	cSelRd : process(SelRd, ERd, sINTo)
	begin
		sRegE <= (others => '0' );
		sRegE(to_integer(sINTo & unsigned(SelRd))) <= ERd ;
	end process;
	
	-- SelRin coding :
	--	000	: DDATAIN (lw)
	--	001	: PCIR + 1 = PCprev (brl, bal)
	--	010	: PIN (in)
	--	011	: ImmOff (li)
	--	100	: UAL (op)
	
	-- with SelRIn(2 downto 1) select
	--	sigRd <= sUAL when "10", std_logic_vector(sProd(31 downto 16)) when "11", sRin when others; 
	sigRd <= sUAL when SelRIn(2)='1' else sRin;
	
	sMulSelRin <= std_logic_vector(EMUL & unsigned(SelRIn(1 downto 0)));
	
	with sMulSelRin select
		sRin <=
			DDATAIN when "000",
			sPCprev when "001",
			PIN     when "010",
			ImmOff  when "011",
			sProdL  when "100",
			sProdH  when "101",
			(others => 'Z') when others;
	
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
		E=>sECarry,
		R=>RESET,
		D=>sCout,
		Q=>sCarry
	);
	
	cCarryInt : reg1
	port map(
		CLK=>CLK,
		E=>sECarryInt,
		R=>RESET,
		D=>sCout,
		Q=>sCarryInt
	);
	
	sECarry <= ECarry and not sINTo;
	sECarryInt <= ECarry and sINTo;
	
	sCin <= sCarryInt when sINTo='1' else sCarry;
	
	sProd <= unsigned(sigRa) * unsigned(sigRb);
	
	sProdHin <= std_logic_vector(sProd(31 downto 16));
	sProdL <= std_logic_vector(sProd(15 downto  0));
	
	cProdH : reg16
	port map(
		CLK=>CLK,
		R=>RESET,
		E=>EMUL,
		D=>sProdHin,
		Q=>sProdH
	);
	
	-- memory
	
	ADPROG <= sPC;
	ADDATA <= sigRa;
	
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
