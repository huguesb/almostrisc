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

entity GeneRGB is
	Port (
		CLK, RESET : in std_logic;
		
		X : in  STD_LOGIC_VECTOR (9 downto 0);
		Y : in  STD_LOGIC_VECTOR (8 downto 0);
		IMG : in  STD_LOGIC;
		
		AD : out std_logic_vector(12 downto 0);
		DATA : in std_logic_vector(15 downto 0);
		
		R : out  STD_LOGIC;
		G : out  STD_LOGIC;
		B : out  STD_LOGIC);
end GeneRGB;

architecture Behavioral of GeneRGB is
	component mux_16_1 is
		Port(
			Sel : in std_logic_vector(3 downto 0);
			I0, I1, I2 , I3 , I4 , I5 , I6 , I7  : in std_logic;
			I8, I9, I10, I11, I12, I13, I14, I15 : in std_logic;
			S : out std_logic
		);
	end component;
	
	signal S : std_logic_vector(3 downto 0);
	signal sPixel : std_logic;
begin
	-- first example
	-- R <= IMG and X(4);
	-- G <= IMG and X(5);
	-- B <= IMG and X(6);
	
	-- second example
	-- R <= IMG and not X(5) and not X(6);
	-- B <= IMG and not X(6) and X(5);
	-- G <= IMG and not X(5) and X(6);
	
	-- project code
	
	process (CLK)
	begin
		if ( CLK'event and CLK='1' )
		then 
			if ( RESET='1' ) then
				S <= (others => '0');
			else
				S <= X(4 downto 1);
			end if;
		end if;
	end process;
	
	-- same but :
	-- sPixel <= DATA(TO_INTEGER(unsigned(15 - S))); -- clearer
	sPixel <= DATA(TO_INTEGER(unsigned(not S)));  -- potentially more synthesis-friendly
	
	AD <= Y(8 downto 1) & X(9 downto 5);
	
	R <= IMG and sPixel;
	G <= IMG and sPixel;
	B <= IMG and sPixel;
end Behavioral;
