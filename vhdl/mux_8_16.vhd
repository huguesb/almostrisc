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

entity mux_8_16 is
	Port(
		Sel : in std_logic_vector(2 downto 0);
		I0, I1, I2, I3, I4, I5, I6, I7 : in std_logic_vector(15 downto 0);
		S : out std_logic_vector(15 downto 0)
	);
end mux_8_16;

architecture Behavioral of mux_8_16 is
begin
	process (Sel, I0, I1, I2, I3, I4, I5, I6, I7)
	begin
		case Sel is
			when "000" => S <= I0;
			when "001" => S <= I1;
			when "010" => S <= I2;
			when "011" => S <= I3;
			when "100" => S <= I4;
			when "101" => S <= I5;
			when "110" => S <= I6;
			when others => S <= I7;
		end case;
	end process;
end Behavioral;
