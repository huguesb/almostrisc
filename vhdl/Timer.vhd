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

entity Timer is
	Port(
		CLK, RESET : in std_logic;
		
		AD : in std_logic_vector(2 downto 0);
		DIN : in std_logic_vector(15 downto 0);
		DOUT : out std_logic_vector(15 downto 0);
		
		CE, OE, WE : in std_logic;
		
		IRQ : out std_logic
	);
end Timer;

--
-- Timer(s) driver : basically clock divider which generate interrupts
--

architecture Behavioral of Timer is
	
begin
	process (CLK)
	begin
		IRQ <= '0' ;
		DOUT <= x"0000";
		
		if ( CLK'event and CLK='1' ) then
			if ( CE='1' ) then
				
			end if;
		end if;
	end process;
end Behavioral;
