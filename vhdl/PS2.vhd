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

entity PS2 is
	Port(
		CLK, RESET : in std_logic;
		
		PS2C, PS2D : in std_logic;
		
		AD : in std_logic_vector(1 downto 0);
		DIN : in std_logic_vector(15 downto 0);
		DOUT : out std_logic_vector(15 downto 0);
		
		CE, OE, WE : in std_logic;
		
		IRQ : out std_logic
	);
end PS2;

--
-- PS/2 driver
--

architecture Behavioral of PS2 is
	
begin
	process (CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			IRQ <= '0' ;
			DOUT <= x"0000";
			
			if ( CE='1' ) then
				IRQ <= '1' ;
			end if;
		end if;
	end process;
end Behavioral;
