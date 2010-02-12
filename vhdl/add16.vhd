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

entity add16 is
	Port(
		A, B : in std_logic_vector(15 downto 0);
		S : out std_logic_vector(15 downto 0)
	);
end add16;

architecture Behavioral of add16 is
begin
	S <= std_logic_vector(unsigned(A) + unsigned(B));
end Behavioral;
