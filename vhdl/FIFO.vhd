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
		bits  : integer := 8;
		words : integer := 4
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
	type vector_array is array (0 to (2**words)-1) of std_logic_vector(bits-1 downto 0);
	signal memory : vector_array;
	signal sEmpty, sFull : std_logic;
	signal top, queue : unsigned(words-1 downto 0);
begin
	process(CLK, RESET)
	begin
		if ( RESET='1' ) then
			top <= (others => '0' );
			queue <= (others => '0' );
			
			DOUT <= (others => 'Z');
			sFull <= '0' ;
			sEmpty <= '1' ;
		elsif ( CLK'event and CLK='1' ) then
			DOUT <= (others => 'Z');
			
			sFull <= '0' ;
			sEmpty <= '0' ;
			
			if ( top = queue ) then
				sEmpty <= '1';
			elsif ( top + 1 = queue ) then
				sFull <= '1';
			end if;
			
			if ( OE='1' and sEmpty='0' ) then
				DOUT <= memory(to_integer(queue));
				queue <= queue + 1;
			end if;
			
			if ( WE='1' and sFull='0' ) then
				memory(to_integer(top)) <= DIN;
				top <= top + 1;
			end if;
		end if;
	end process;
	full <= sFull;
	empty <= sEmpty;
end Behavioral;
