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
		
		IRQ : out std_logic_vector(2 downto 0)
	);
end Timer;

--
-- Timer(s) driver : basically clock divider which generate interrupts
--

-- 
-- offer 3 "programmable" countdown timers with a base clock of 10MHz (assuming
-- a circuit clock of 50MHz) and 7 derived clocks, each one being an order of
-- magnitude slower than its "parent" clock (i.e 10 times slower) : 1MHz, 100KHz,
-- 10KHz, 1KHz, 100Hz, 10Hz and 1Hz
--
-- each timer is associated with a 16 bit counter which offers a practical range
-- of timing from 10MHz to 1/65536Hz
--

-- 	status, control and counter registers
-- 	0 : control (3 MSB unused, groups of 5 bits : enabled | loop | speed(3)) [RW]
-- 	1-3 : loop base count [RW]
-- 	4-6 : loop current count [RO]
-- 	7 : unused [RO]

architecture Behavioral of Timer is
	component reg1
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic;
			Q : out std_logic
		);
	end component;
	
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	type counter is array(integer range<>) of unsigned(31 downto 0);
	type reg16array is array (integer range <>) of std_logic_vector(15 downto 0);
	
	signal sRegisters : reg16array(7 downto 0);
	signal sRegEnable : std_logic_vector(3 downto 0);
	
	signal cnt_base : counter(2 downto 0);
	
	signal sIRQ, sIRQin, sResetIRQ, ld : std_logic_vector(2 downto 0);
	
	constant cnt_orig : counter(7 downto 0) := (
		0=>x"00000031", -- 50 * 10^0 - 1
		1=>x"000001F3", -- 50 * 10^1 - 1
		2=>x"00001387", -- 50 * 10^2 - 1
		3=>x"0000C34F", -- 50 * 10^3 - 1
		4=>x"0007A11F", -- 50 * 10^4 - 1
		5=>x"004C4B3F", -- 50 * 10^5 - 1
		6=>x"02FAF07F", -- 50 * 10^6 - 1
		7=>x"1DCD64FF"  -- 50 * 10^7 - 1
	);
begin
	gen_rw : for idx in 0 to 3 generate
		cReg : reg16
		port map(
			CLK=>CLK,
			D=>DIN,
			Q=>sRegisters(idx),
			E=>sRegEnable(idx),
			R=>RESET
		);
		
		sRegEnable(idx) <= (CE and WE) when idx = to_integer(unsigned(AD)) else '0' ;
	end generate;
	
	gen_ro : for idx in 0 to 2 generate
		ld(idx) <= (CE and WE) when (1 + idx) = to_integer(unsigned(AD)) else '0' ;
		
		cIRQ : reg1
		port map(
			CLK=>CLK,
			D=>sIRQin(idx),
			Q=>sIRQ(idx),
			E=>'1',
			R=>sResetIRQ(idx)
		);
		
		process(CLK, RESET)
		begin
			if ( RESET='1' ) then
				sIRQin(idx) <= '0' ;
			elsif ( ld(idx)='1' ) then
				cnt_base(idx) <= cnt_orig(to_integer(unsigned(sRegisters(0)(5 * idx + 2 downto 5 * idx))));
				sRegisters(4 + idx) <= std_logic_vector(unsigned(DIN) - 1);
			elsif ( CLK'event and CLK='1' and sRegisters(0)(5 * idx + 4)='1' ) then
				sIRQin(idx) <= '0' ;
				
				-- decrement frequency divider counter
				cnt_base(idx) <= cnt_base(idx) - 1;
				
				if ( cnt_base(idx) = x"00000000" ) then
					-- reset frequency divider counter
					cnt_base(idx) <= cnt_orig(to_integer(unsigned(sRegisters(0)(5 * idx + 2 downto 5 * idx))));
					
					if ( sRegisters(0)(5 * idx + 4)='1' ) then
						if ( sRegisters(4 + idx) = x"0000" ) then
							-- interrupt
							sIRQin(idx) <= '1';
							
							if ( sRegisters(0)(5 * idx + 3)='1' ) then
								-- loop : reset counter
								sRegisters(4 + idx) <= std_logic_vector(unsigned(sRegisters(1 + idx)) - 1);
							else
								-- disable timer to avoid multiple emissions... (?)
							end if;
						else
							-- decrement counter
							sRegisters(4 + idx) <= std_logic_vector(unsigned(sRegisters(4 + idx)) - 1);
						end if;
					end if;
				end if;
			end if;
		end process;
	end generate;
	
	process(CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			if ( (CE and WE)='1' ) then
				if ( ((AD(1) nor AD(2)) or (AD(0) nor AD(2))) ='1' ) then
					-- trying to write to counters or status : exception?
					
				end if;
			end if;
			
			-- emit IRQ
			IRQ <= sIRQ;
			
			-- avoid multiple emission
			sResetIRQ <= (2 downto 0 => RESET) or sIRQ;
			
			-- send data upon read request
			DOUT <= sRegisters(to_integer(unsigned(AD))) and (15 downto 0 => CE and OE);
		end if;
	end process;
end Behavioral;
