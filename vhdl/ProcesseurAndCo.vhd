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
use ieee.numeric_std.all;

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
			
			CLK, RESET, INT : in std_logic;
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
	
	component MMU
		Port(
			AD : in std_logic_vector(15 downto 0);
			CE : in std_logic;
			
			CEram : out std_logic;
			CEirq : out std_logic;
			CEps2 : out std_logic;
			CEtmr : out std_logic
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
	
	component IRQ is
		Port(
			CLK, RESET : in std_logic;
			
			AD : in std_logic_vector(1 downto 0);
			DIN : in std_logic_vector(15 downto 0);
			DOUT : out std_logic_vector(15 downto 0);
			
			CE, OE, WE : in std_logic;
			
			IRQin : in std_logic_vector(15 downto 0);
			IRQout : out std_logic
		);
	end component;
	
	
	component VGA
		Port(
			CLK, RESET : in std_logic;
			
			AD : out std_logic_vector(12 downto 0);
			DATA : in std_logic_vector(15 downto 0);
			
			HS, VS  : out std_logic;
			R, G, B : out std_logic
		);
	end component;
	
	component PS2
		Port(
			CLK, RESET : in std_logic;
			
			AD : in std_logic_vector(1 downto 0);
			DIN : in std_logic_vector(15 downto 0);
			DOUT : out std_logic_vector(15 downto 0);
			
			CE, OE, WE : in std_logic;
			
			IRQ : out std_logic
		);
	end component;
	
	component Timer
		Port(
			CLK, RESET : in std_logic;
			
			AD : in std_logic_vector(2 downto 0);
			DIN : in std_logic_vector(15 downto 0);
			DOUT : out std_logic_vector(15 downto 0);
			
			CE, OE, WE : in std_logic;
			
			IRQ : out std_logic
		);
	end component;
	
	signal INT : std_logic;
	signal ADPROG, ADDATA, ADVGA : std_logic_vector(15 downto 0);
	signal DPROG, DDATAIN, DDATAOUT, DVGA : std_logic_vector(15 downto 0);
	signal sRAMout, sIRQout, sPS2out, sTMRout, sIRQin : std_logic_vector(15 downto 0);
	signal WE, CE, OE : std_logic;
	signal CEram, CEirq, CEps2, CEtmr : std_logic;
begin
	cProcesseur : Processeur
	port map(
		CLK=>CLK,
		RESET=>RESET,
		INT=>INT,
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
	
	cMMU : MMU
	port map(
		AD=>ADDATA,
		CE=>CE,
		CEram=>CEram,
		CEirq=>CEirq,
		CEps2=>CEps2,
		CEtmr=>CEtmr
	);
	
	cRAMDoublePort : RAMDoublePort
	port map(
		CLK=>CLK,
		AD1=>ADDATA(12 downto 0),
		DIN1=>DDATAOUT,
		DOUT1=>sRAMout,
		AD2=>ADVGA(12 downto 0),
		DOUT2=>DVGA,
		WE1=>WE,
		CE1=>CEram,
		OE1=>OE
	);
	
	sIRQin(15 downto 2) <= (others => '1' );
	
	cIRQ : IRQ
	port map(
		CLK=>CLK,
		RESET=>RESET,
		AD=>ADDATA(1 downto 0),
		DIN=>DDATAOUT,
		DOUT=>sIRQout,
		CE=>CEirq,
		WE=>WE,
		OE=>OE,
		IRQin=>sIRQin,
		IRQout=>INT
	);
	
	DDATAIN <= sRAMout or sIRQout or sPS2out or sTMRout;
	
	cVGA : VGA
	port map(
		CLK=>CLK,
		RESET=>RESET,
		AD=>ADVGA(12 downto 0),
		DATA=>DVGA,
		HS=>HS,
		VS=>VS,
		R=>R,
		G=>G,
		B=>B
	);
	
	cPS2 : PS2
	port map(
		CLK=>CLK,
		RESET=>RESET,
		AD=>ADDATA(1 downto 0),
		DIN=>DDATAOUT,
		DOUT=>sPS2out,
		CE=>CEps2,
		WE=>WE,
		OE=>OE,
		IRQ=>sIRQin(0)
	);
	
	cTimer : Timer
	port map(
		CLK=>CLK,
		RESET=>RESET,
		AD=>ADDATA(2 downto 0),
		DIN=>DDATAOUT,
		DOUT=>sTMRout,
		CE=>CEtmr,
		WE=>WE,
		OE=>OE,
		IRQ=>sIRQin(1)
	);
	
end Behavioral;
