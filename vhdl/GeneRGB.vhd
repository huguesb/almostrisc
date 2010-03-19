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
	component fast_adder
		generic(
			size : natural := 13
		);
		
		Port(
			A : in unsigned(size -1 downto 0);
			B : in unsigned(size -1 downto 0);
			CIN : in std_logic;
			
			S : out unsigned(size -1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	signal Yx16, Yx4, Yx20, Xpad, sAD : unsigned(12 downto 0);
	
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
	
	-- simple but STUPID : wastes 12 out of 32 words => 2880 words wasted...
	--AD <= Y(8 downto 1) & X(9 downto 5);
	
	-- more complicated but does not waste space...
	-- AD = 20 * Y(8 downto 1) + X(9 downto 5)
	
	Yx16 <=  "0" & unsigned(Y(8 downto 1)) & "0000";
	Yx4 <= "000" & unsigned(Y(8 downto 1)) & "00";
	
	cAdd20Y : fast_adder
	port map(
		A=>Yx16,
		B=>Yx4,
		cin=>'0',
		S=>Yx20
	);
	
	Xpad <= "00000000" & unsigned(X(9 downto 5));
	
	cAddYX : fast_adder
	port map(
		A=>Yx20,
		B=>Xpad,
		cin=>'0',
		S=>sAD
	);
	
	AD <=std_logic_vector(sAD);
	
	R <= IMG and sPixel;
	G <= IMG and sPixel;
	B <= IMG and sPixel;
end Behavioral;
