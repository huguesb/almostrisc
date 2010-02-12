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

entity reg16 is
	Port(
		CLK, E, R : in std_logic;
		D : in std_logic_vector(15 downto 0);
		Q : out std_logic_vector(15 downto 0)
	);
end reg16;

architecture Behavioral of reg16 is
begin
	process (CLK, R)
	begin
		if ( R = '1' ) then 
			Q <= x"0000";
		elsif ( CLK'event and CLK='1' and E='1' ) then
			Q <= D;
		end if;
	end process;
end Behavioral;
