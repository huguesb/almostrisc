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

entity mux_4_16 is
	Port(
		Sel : in std_logic_vector(1 downto 0);
		I0, I1, I2, I3 : in std_logic_vector(15 downto 0);
		S : out std_logic_vector(15 downto 0)
	);
end mux_4_16;

architecture Behavioral of mux_4_16 is
begin
	with Sel select
		S <=
			I0 when "00",
			I1 when "01",
			I2 when "10",
			I3 when others;
	
-- 	process (Sel, I0, I1, I2, I3)
-- 	begin
-- 		case Sel is
-- 			when "00" => S <= I0;
-- 			when "01" => S <= I1;
-- 			when "10" => S <= I2;
-- 			when others => S <= I3;
-- 		end case;
-- 	end process;
end Behavioral;
