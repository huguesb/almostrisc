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

entity reg1 is
	Port(
		CLK, E : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end reg1;

architecture Behavioral of reg1 is
begin
	process (CLK)
	begin
		if ( CLK'event and CLK='1' and E='1' ) then
			Q <= D;
		end if;
	end process;
end Behavioral;
