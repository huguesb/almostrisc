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

entity MMU is
	Port(
		AD : in std_logic_vector(15 downto 0);
		CE : in std_logic;
		
		CEram : out std_logic;
		CEirq : out std_logic;
		CEps2 : out std_logic;
		CEtmr : out std_logic;
		CE232 : out std_logic
	);
end MMU;

--
-- pseudo MMU : simple peripheral mappings
--

--
-- 0x0000 - 0x1FFF : RAM    (8192 * 16b)
--
-- 0x2000 - 0x2003 : IRQ    (   4 * 16b)
-- 0x2004 - 0x2007 : PS2    (   4 * 16b)
-- 0x2008 - 0x200F : Timers (   8 * 16b)
-- 0x2010 - 0x2013 : RS232  (   4 * 16b)
-- 
-- 0x4000 - 0xFFFF : mapping of SRAM ???
--

architecture Behavioral of MMU is
	signal CEi : unsigned(2 downto 0);
begin
	process(AD, CE)
	begin
		CEram <= '0' ;
		CEirq <= '0' ;
		CEps2 <= '0' ;
		CEtmr <= '0' ;
		
		if ( AD(15 downto 13) = "000" ) then
			CEram <= CE;
		elsif ( AD(15 downto 13) = "001" )then
			if ( AD(12 downto 2) = "00000000000" ) then
				CEirq <= CE;
			elsif ( AD(12 downto 2) = "00000000001" ) then
				CEps2 <= CE;
			elsif ( AD(12 downto 3) = "0000000001" ) then
				CEtmr <= CE;
			elsif ( AD(12 downto 3) = "00000000100" ) then
				CE232 <= CE;
			else
				-- raise MMU exception?
			end if;
		else
			-- raise MMU exception?
		end if;
	end process;
end Behavioral;
