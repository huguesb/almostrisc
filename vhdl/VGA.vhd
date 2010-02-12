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

entity VGA is
	Port(
		CLK : in std_logic;
		
		AD : out std_logic_vector(12 downto 0);
		DATA : in std_logic_vector(15 downto 0);
		
		HS, VS  : out std_logic;
		R, G, B : out std_logic
	);
end VGA;

architecture Behavioral of VGA is
	component GeneRGB
		Port(
			CLK : in std_logic;
			X : in  std_logic_vector (9 downto 0);
			Y : in  std_logic_vector (8 downto 0);
			IMG : in  std_logic;
			
			AD : out std_logic_vector(12 downto 0);
			DATA : in std_logic_vector(15 downto 0);
			
			R : out  std_logic;
			G : out  std_logic;
			B : out  std_logic
		);
	end component;
	
	component GeneSync
		Port(
			CLK : in std_logic;
			HSYNC : out std_logic;
			VSYNC : out std_logic;
			IMG : out std_logic;
			X : out std_logic_vector(9 downto 0);
			Y : out std_logic_vector(8 downto 0)
		);
	end component;
	
	signal Xi : std_logic_vector(9 downto 0);
	signal Yi : std_logic_vector(8 downto 0);
	signal IMGi : std_logic;
begin
	cSync : GeneSync 
	port map(
		CLK=>CLK,
		HSYNC=>HS,
		VSYNC=>VS,
		IMG=>IMGi,
		X=>Xi,
		Y=>Yi
	);
	
	cRGB : GeneRGB
	port map(
		CLK=>CLK,
		X=>Xi,
		Y=>Yi,
		IMG=>IMGi,
		AD=>AD,
		DATA=>DATA,
		R=>R,
		G=>G,
		B=>B
	);

end Behavioral;
