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
		
		PS2C, PS2D : inout std_logic;
		
		BYTE_ERROR : out std_logic;
		BYTE_AVAIL : out std_logic;
		
		AD : in std_logic_vector(1 downto 0);
		DIN : in std_logic_vector(15 downto 0);
		DOUT : out std_logic_vector(15 downto 0);
		
		CE, OE, WE : in std_logic;
		
		IRQ : out std_logic
	);
end PS2;

--
-- low-level PS/2 driver
--

architecture Behavioral of PS2 is
	component FIFO is
		generic (
			bits  : integer := 8;
			words : integer := 16
		);
		
		port (
			CLK, RESET : in  std_logic;
			
			OE, WE : in std_logic;
			
			DIN  : in  std_logic_vector(bits-1 downto 0);
			DOUT : out std_logic_vector(bits-1 downto 0);
			
			full : out std_logic;
			empty : out std_logic
		);
	end component;
	
	signal sIdle : std_logic;
	
	signal sParity : std_logic;
	signal sBitCount : unsigned(3 downto 0);
	signal sInput : std_logic_vector(8 downto 0);
begin
	-- receive
	process(PS2C)
	begin
		if ( PS2C'event and PS2C='0' ) then
			BYTE_AVAIL <= '0' ;
			
			if ( sIdle='1' ) then
				sIdle <= PS2D ;
				sParity <= '0';
				sBitCount <= x"0";
			elsif ( sBitCount = x"9" ) then
				if ( PS2D='1' and sParity='1' ) then
					-- received a byte, proper parity
					
					BYTE_AVAIL <= '1' ;
				else
					-- transmission error...
					
				end if;
				
				sIdle <= '1' ;
				sParity <= '0' ;
			else
				sBitCount <= sBitCount + 1;
				sInput(to_integer(sBitCount)) <= PS2D;
				sParity <= sParity xor PS2D;
			end if;
		end if;
	end process;
	
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
