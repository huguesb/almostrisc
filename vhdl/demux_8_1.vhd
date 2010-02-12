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

entity demux_8_1 is
	Port(
		Sel : in std_logic_vector(2 downto 0);
		I : in std_logic;
		S0, S1, S2, S3, S4, S5, S6, S7 : out std_logic
	);
end demux_8_1;

architecture Behavioral of demux_8_1 is
	signal s_tmp : std_logic_vector(7 downto 0);
begin
	process (Sel, I)
	begin
		if ( I='1' ) then 
			case Sel is
				-- note quite sure about the coma syntax...
				when "000" => s_tmp <=  "00000001";
				when "001" => s_tmp <=  "00000010";
				when "010" => s_tmp <=  "00000100";
				when "011" => s_tmp <=  "00001000";
				when "100" => s_tmp <=  "00010000";
				when "101" => s_tmp <=  "00100000";
				when "110" => s_tmp <=  "01000000";
				when others => s_tmp <= "10000000";
			end case;
		else
			s_tmp <= "00000000";
		end if;
	end process;
	
	S0 <= s_tmp(0);
	S1 <= s_tmp(1);
	S2 <= s_tmp(2);
	S3 <= s_tmp(3);
	S4 <= s_tmp(4);
	S5 <= s_tmp(5);
	S6 <= s_tmp(6);
	S7 <= s_tmp(7);
end Behavioral;
