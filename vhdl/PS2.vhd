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
		
		AD : in std_logic_vector(1 downto 0);
		DIN : in std_logic_vector(15 downto 0);
		DOUT : out std_logic_vector(15 downto 0);
		
		CE, OE, WE : in std_logic;
		
		IRQ : out std_logic_vector(2 downto 0)
	);
end PS2;

--
-- low-level PS/2 driver
--

--
-- memory mapping :
--
-- * 16 bits : Input Register (RO)
-- * 16 bits : Output Register (WO) [placeholder, not used yet]
-- * 16 bits : Status register (RO)
-- * 16 bits : Control register (WO)
--

architecture Behavioral of PS2 is
	component FIFO is
		generic (
			bits  : integer := 8;
			words : integer := 4 -- 2^4 = 16 elements in FIFO
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
	
	signal PS2Csmooth, PS2Clast : std_logic;
	
	signal ACK : std_logic;
	signal sRead, sWrite : std_logic;
	signal sIdle : std_logic;
	signal sAvail, sError : std_logic;
	signal sFull, sEmpty : std_logic;
	signal sParity : std_logic;
	signal sBitCount : unsigned(3 downto 0);
	signal sInput : std_logic_vector(8 downto 0);
	signal sOutput : std_logic_vector(7 downto 0);
	signal smooth_counter : unsigned(8 downto 0);
begin
	-- smooth PS2C
	process(CLK, RESET)
	begin
		if ( RESET='1' ) then
			PS2Clast <= '1' ;
			PS2Csmooth <= '1' ;
			smooth_counter <= '1' & x"FF";
		elsif ( CLK'event and CLK='1' ) then
			if ( PS2C /= PS2Clast ) then
				smooth_counter <= '1' & x"FF";
			else
				smooth_counter <= smooth_counter - 1;
				
				if ( smooth_counter = '0' & x"00" ) then
					PS2Csmooth <= PS2C;
				end if;
			end if;
			
			PS2Clast <= PS2C;
		end if;
	end process;
	
	-- receive
	process(PS2Csmooth, RESET, ACK)
	begin
		if ( RESET='1' ) then
			sIdle <= '1';
			sAvail <= '0' ;
			sError <= '0' ;
			sParity <= '0' ;
			sBitCount <= x"0";
			sInput <= (others => '0' );
		elsif ( ACK='1' ) then
			sAvail <= '0' ;
			sError <= '0' ;
		elsif ( PS2Csmooth'event and PS2Csmooth='0' ) then
			sAvail <= '0';
			sError <= '0';
			sParity <= '0' ;
			
			if ( sIdle='1' ) then
				sIdle <= PS2D ;
				sBitCount <= x"0";
			elsif ( sBitCount = x"9" ) then
				if ( PS2D='1' and sParity='1' ) then
					-- received a byte, proper parity
					
					sAvail <= '1' ;
				else
					-- transmission error...
					sError <= '1';
				end if;
				
				sBitCount <= x"0";
				sIdle <= '1' ;
			else
				sIdle <= '0';
				sBitCount <= sBitCount + 1;
				sInput(to_integer(sBitCount)) <= PS2D;
				sParity <= sParity xor PS2D;
			end if;
		end if;
	end process;
	
	cFIFO : FIFO
	port map(
		CLK=>CLK,
		RESET=>RESET,
		OE=>sRead,
		WE=>sAvail,
		DIN=>sInput(7 downto 0),
		DOUT=>sOutput,
		full=>sFull,
		empty=>sEmpty
	);
	
	IRQ <= sError & '0' & sAvail;
	sRead <= CE and OE and (AD(0) nor AD(1));
	
	process (CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			DOUT <= x"0000";
			
			ACK <= sAvail or sError;
			
			if ( (CE and OE)='1' ) then
				case AD is
					when "00" => DOUT <= x"00" & sOutput;
					when "10" => DOUT <= x"00" & "00" & sIdle & sParity & sError & sAvail & sFull & sEmpty;
					when others => DOUT <= (others => 'Z');
				end case;
			end if;
		end if;
	end process;
end Behavioral;
