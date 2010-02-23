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

entity FIFO is
	generic (
		bits  : integer;
		words : integer
	);
	
	port (
		CLK, RESET : in  std_logic;
		
		OE, WE : in std_logic;
		
		DIN  : in  std_logic_vector(bits-1 downto 0);
		DOUT : out std_logic_vector(bits-1 downto 0);
		
		full : out std_logic;
		empty : out std_logic
	);
end FIFO;

-- 
-- Simple FIFO
-- 

architecture Behavioral of FIFO is
	type vector_array is array (0 to words-1) of std_logic_vector(bits-1 downto 0);
	signal memory : vector_array;
	signal sEmpty, sFull : std_logic;
begin
	process(CLK, RESET)
		variable top : integer range 0 to words;
	begin
		if ( RESET='1' ) then
			top := 0;
			
			DOUT <= (others => 'Z');
			sFull <= '0' ;
			sEmpty <= '1' ;
		elsif ( CLK'event and CLK='1' ) then
			DOUT <= (others => 'Z');
			
			if ( OE='1' and sEmpty='0' ) then
				top := top - 1;
				DOUT <= memory(top);
			end if;
			
			if ( WE='1' and sFull='0' ) then
				memory(top) <= DIN;
				top := top + 1;
			end if;
			
			sFull <= '0' ;
			sEmpty <= '0' ;
			
			if ( top = 0 ) then
				sEmpty <= '1';
			elsif ( top = words ) then
				sFull <= '1';
			end if;
		end if;
	end process;
	full <= sFull;
	empty <= sEmpty;
end Behavioral;
