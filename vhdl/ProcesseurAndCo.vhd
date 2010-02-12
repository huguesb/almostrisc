----------------------------------------------------------------------------------
--
-- Copyright 2010 Hugues Bruant. All rights reserved.
--
-- <hugues.bruant@ensimag.imag.fr>
--
--
-- This file is part of a school project and licensed under the terms of FreeBSD
-- license (2-clause BSD also refered to as Simplified BSD License)
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ProcesseurAndCo is
	Port(
		CLK, RESET : in std_logic;
		
		HS, VS, R, G, B : out std_logic;
		
		PIN : in std_logic_vector(15 downto 0);
		POUT : out std_logic_vector(15 downto 0)
	);
end ProcesseurAndCo;

architecture Behavioral of ProcesseurAndCo is
	component Processeur
		Port (
			ADPROG : out std_logic_vector(15 downto 0);
			DPROG : in std_logic_vector(15 downto 0);
			
			ADDATA : out std_logic_vector(15 downto 0);
			DDATAIN : in std_logic_vector(15 downto 0);
			DDATAOUT : out std_logic_vector(15 downto 0);
			
			CLK, RESET : in std_logic;
			CE, WE, OE : out std_logic;
			
			PIN : in std_logic_vector(15 downto 0);
			POUT : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component ROMPROG
		Port (
			AD : in std_logic_vector (12 downto 0);
			D : out std_logic_vector (15 downto 0);
			CLK : in std_logic
		);
	end component;
	
	component RAMDoublePort
		Port (
			AD1 : in std_logic_vector (12 downto 0);
			AD2 : in std_logic_vector (12 downto 0);
			DIN1 : in std_logic_vector (15 downto 0);
			DOUT1 : out std_logic_vector (15 downto 0);
			WE1 : in std_logic;
			DOUT2 : out std_logic_vector (15 downto 0);
			OE1 : in std_logic;
			CE1 : in std_logic;
			CLK : in std_logic
		);
	end component;
	
	component VGA
		Port(
			CLK : in std_logic;
			
			AD : out std_logic_vector(12 downto 0);
			DATA : in std_logic_vector(15 downto 0);
			
			HS, VS  : out std_logic;
			R, G, B : out std_logic
		);
	end component;
	
	signal ADPROG, ADDATA, ADVGA : std_logic_vector(15 downto 0);
	signal DPROG, DDATAIN, DDATAOUT, DVGA : std_logic_vector(15 downto 0);
	signal WE, CE, OE : std_logic;
begin
	cProcesseur : Processeur
	port map(
		CLK=>CLK,
		RESET=>RESET,
		ADPROG=>ADPROG,
		DPROG=>DPROG,
		ADDATA=>ADDATA,
		DDATAIN=>DDATAIN,
		DDATAOUT=>DDATAOUT,
		PIN=>PIN,
		POUT=>POUT,
		WE=>WE,
		CE=>CE,
		OE=>OE
	);
	
	cROMPROG : ROMPROG
	port map(
		CLK=>CLK,
		AD=>ADPROG(12 downto 0),
		D=>DPROG
	);
	
	cRAMDoublePort : RAMDoublePort
	port map(
		CLK=>CLK,
		AD1=>ADDATA(12 downto 0),
		DIN1=>DDATAOUT,
		DOUT1=>DDATAIN,
		AD2=>ADVGA(12 downto 0),
		DOUT2=>DVGA,
		WE1=>WE,
		CE1=>CE,
		OE1=>OE
	);
	
	cVGA : VGA
	port map(
		CLK=>CLK,
		AD=>ADVGA(12 downto 0),
		DATA=>DVGA,
		HS=>HS,
		VS=>VS,
		R=>R,
		G=>G,
		B=>B
	);
	
end Behavioral;
