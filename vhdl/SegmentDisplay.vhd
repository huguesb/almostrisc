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

entity SegmentDisplay is
	Port(
		CLK, RESET : in std_logic;
		VALUE : in std_logic_vector(15 downto 0);
		ANODE : out std_logic_vector(3 downto 0);
		SEGMENT : out std_logic_vector(6 downto 0)
	);
end SegmentDisplay;

architecture Behavioral of SegmentDisplay is
	type nibble_array is array(integer range <>) of std_logic_vector(3 downto 0);
	signal seg_value : nibble_array(3 downto 0);
	signal cur_seg : std_logic_vector(3 downto 0);
	signal seg_counter : unsigned(1 downto 0);
	signal delay_counter : unsigned(16 downto 0);
begin
	seg_value(0) <= VALUE(3 downto 0);
	seg_value(1) <= VALUE(7 downto 4);
	seg_value(2) <= VALUE(11 downto 8);
	seg_value(3) <= VALUE(15 downto 12);
	
	process(CLK, RESET)
	begin
		if ( RESET='1' ) then
			ANODE <= x"F";
			SEGMENT <= (others => '1' );
			seg_counter <= "00";
			delay_counter <= (others => '1' );
		elsif ( CLK'event and CLK='1' ) then
			delay_counter <= delay_counter - 1;
			
			if ( delay_counter = (16 downto 0 => '0' ) ) then
				delay_counter <= (others => '1' );
				
				ANODE <= x"F";
				ANODE(to_integer(seg_counter)) <= '0' ;
				
				cur_seg <= seg_value(to_integer(seg_counter));
				
				case cur_seg is
					when x"0" => SEGMENT <= "1000000";
					when x"1" => SEGMENT <= "1111001";
					when x"2" => SEGMENT <= "0100100";
					when x"3" => SEGMENT <= "0110000";
					when x"4" => SEGMENT <= "0011001";
					when x"5" => SEGMENT <= "0010010";
					when x"6" => SEGMENT <= "0000010";
					when x"7" => SEGMENT <= "1111000";
					when x"8" => SEGMENT <= "0000000";
					when x"9" => SEGMENT <= "0010000";
					when x"A" => SEGMENT <= "0001000";
					when x"B" => SEGMENT <= "0000011";
					when x"C" => SEGMENT <= "1000110";
					when x"D" => SEGMENT <= "0100001";
					when x"E" => SEGMENT <= "0000110";
					when others => SEGMENT <= "0001110";
				end case;
				
				seg_counter <= seg_counter + 1;
			end if;
		end if;
	end process;
end Behavioral;
