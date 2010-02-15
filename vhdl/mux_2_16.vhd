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

entity mux_2_16 is
	Port(
		Sel : in std_logic;
		I0, I1 : in std_logic_vector(15 downto 0);
		S : out std_logic_vector(15 downto 0)
	);
end mux_2_16;

architecture Behavioral of mux_2_16 is
begin
-- 	process (Sel, I0, I1)
-- 	begin
-- 		case Sel is
-- 			when '0' => S <= I0;
-- 			when others => S <= I1;
-- 		end case;
-- 	end process;
	S <= (I0 and (15 downto 0 => not Sel)) or (I1 and (15 downto 0 => Sel));
end Behavioral;
