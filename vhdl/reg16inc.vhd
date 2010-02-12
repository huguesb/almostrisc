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

entity reg16inc is
	Port(
		CLK, E, I, R : in std_logic;
		D : in std_logic_vector(15 downto 0);
		Q : out std_logic_vector(15 downto 0)
	);
end reg16inc;

architecture Behavioral of reg16inc is
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component mux_2_16 is
		Port(
			Sel : in std_logic;
			I0, I1 : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal sD, sQ, sQn : std_logic_vector(15 downto 0);
begin
	
	sQn <= std_logic_vector(unsigned(sQ) + 1);
	Q <= sQ;
	
	cReg : reg16
	port map(
		CLK=>CLK,
		E=>E,
		R=>R,
		D=>sD,
		Q=>sQ
	);
	
	cMux : mux_2_16
	port map(
		Sel=>I,
		I0=>D,
		I1=>sQn,
		S=>sD
	);
	
end Behavioral;
