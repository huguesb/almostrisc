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
		CLK, E, L, I, R : in std_logic;
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
	
	component mux_2_16
		Port(
			Sel : in std_logic;
			I0, I1 : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component inc_dec
		Port(
			D : in std_logic;
			I : in std_logic_vector(15 downto 0);
			S : out std_logic_vector(15 downto 0)
		);
	end component;
	
	signal sQ : std_logic_vector(15 downto 0);
begin
	process (CLK, R)
	begin
		if ( R'event and R='1' ) then
			sQ <= x"0000";
			Q <= x"0000";
			
			if ( E='1' ) then
				if ( L='1' ) then
					sQ <= D;
				elsif ( I='1' ) then
					sQ <= x"0001";
				else
					sQ <= x"FFFF";
				end if;
			end if;
		elsif ( CLK'event and CLK='1' ) then
			if ( E='1' ) then
				if ( L='1' ) then
					sQ <= D;
				elsif ( I='1' ) then
					sQ <= std_logic_vector(unsigned(sQ) + 1);
				else
					sQ <= std_logic_vector(unsigned(sQ) - 1);
				end if;
			end if;
			Q <= sQ;
		end if;
	end process;
end Behavioral;
