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

entity cond_checker is
	Port(
		I : in std_logic_vector(15 downto 0);
		C : in std_logic_vector(2 downto 0);
		R : out std_logic
	);
end cond_checker;

architecture Behavioral of cond_checker is
	signal sNnull : std_logic;
begin
	sNnull <=
		I(15) or I(14) or I(13) or I(12) or I(11) or I(10) or I(9) or I(8) or
		I( 7) or I( 6) or I( 5) or I( 4) or I( 3) or I( 2) or I(1) or I(0);
	
	R <= C(2) xor ((not sNnull) or (C(1) and I(15)) or (C(0) and not I(15)));
end Behavioral;
