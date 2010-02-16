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

entity IRQ is
	Port(
		CLK, RESET : in std_logic;
		
		AD : in std_logic_vector(1 downto 0);
		DIN : in std_logic_vector(15 downto 0);
		DOUT : out std_logic_vector(15 downto 0);
		
		CE, OE, WE : in std_logic;
		
		IRQin : in std_logic_vector(15 downto 0);
		IRQout : out std_logic
	);
end IRQ;

architecture Behavioral of IRQ is
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal sR, sW : std_logic;
	signal sE : std_logic_vector(3 downto 0);
	signal sSens, sMask, sVal, sSig, sSigIn, sOut : std_logic_vector(15 downto 0);
begin
	sR <= CE and OE and not WE;
	sW <= CE and WE and not OE;
	
	process (AD, sW)
	begin
		sE <= "0000";
		sE(to_integer(unsigned(AD))) <= sW;
	end process;
	
	process (AD, sSens, sMask, IRQin)
	begin
		case AD is
			when "00" => sOut <= sMask;
			when "01" => sOut <= sSens;
			when others => sOut <= IRQin;
		end case;
	end process;
	
	cIRQMask : reg16
	port map(
		CLK=>CLK,
		E=>sE(0),
		R=>RESET,
		D=>DIN,
		Q=>sSens
	);
	
	cIRQSens : reg16
	port map(
		CLK=>CLK,
		E=>sE(1),
		R=>RESET,
		D=>DIN,
		Q=>sMask
	);
	
	cIRQVal : reg16
	port map(
		CLK=>CLK,
		E=>'1',
		R=>RESET,
		D=>IRQin,
		Q=>sVal
	);
	
	sSigIn <= sMask and (((sVal xor IRQin) and sSens) or (IRQin and not sSens));
	
	cIRQsig : process(CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			sSig <= sSigIn;
			
			if ( sE(2)='1' ) then
				sSig <= sSig and not DIN;
			end if;
		end if;
	end process;
	
	IRQout <= sSig(15) or sSig(14) or sSig(13) or sSig(12) or sSig(11) or sSig(10) or sSig(9) or sSig(8)
			or sSig(7) or sSig(6) or sSig(5) or sSig(4) or sSig(3) or sSig(2) or sSig(1) or sSig(0);
	
	DOUT <= sOut and (15 downto 0 => sR);
end Behavioral;
