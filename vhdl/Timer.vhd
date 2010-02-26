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
-- 	0-2 : loop current count [RO]
-- 	3 : unused [RO]
-- 	4-6 : loop base count [RW]
-- 	7 : control (3 MSB unused, groups of 5 bits : enabled | loop | speed(3)) [RW]

architecture Behavioral of Timer is
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	type counter4 is array(integer range<>) of unsigned(4 downto 0);
	type reg16array is array (integer range <>) of std_logic_vector(15 downto 0);
	
	signal sRegisters : reg16array(7 downto 0);
	signal sRegEnable : std_logic_vector(7 downto 0);
	
	signal TMR_CLK : std_logic_vector(7 downto 0);
	signal cnt_base : counter4(7 downto 0);
	
	signal sIRQ, sCLK, ld : std_logic_vector(2 downto 0);
begin
	-- clock divider : produce 10MHz timer clock from 50MHz circuit clock
	base : process (CLK, RESET)
	begin
		--if ( CLK'event and CLK='1' ) then
			if ( RESET='1' ) then
				cnt_base(0) <= (others => '0' );
				TMR_CLK(0) <= '1' ;
			else
				cnt_base(0) <= cnt_base(0) + 1;
				
				if ( cnt_base(0) = 4 ) then
					cnt_base(0) <= (others => '0' );
					TMR_CLK(0) <= not TMR_CLK(0);
				end if;
			end if;
		--end if;
	end process;
	
	-- successive dividers by 10
	deriv : for idx in 1 to 7 generate
	process (TMR_CLK(idx - 1))
		begin
			if ( TMR_CLK(idx - 1)'event and TMR_CLK(idx - 1)='1' ) then
				if ( RESET='1' ) then
					cnt_base(idx) <= (others => '0' );
					TMR_CLK(idx) <= '1' ;
				else
					cnt_base(idx) <= cnt_base(idx) + 1;
					
					if ( cnt_base(idx) = 4 ) then
						cnt_base(idx) <= (others => '0' );
						TMR_CLK(idx) <= not TMR_CLK(idx);
					end if;
				end if;
			end if;
		end process;
	end generate;
	
	IRQ <= sIRQ;
	
	cGenRegs : for idx in 7 downto 3 generate
		cCounter : reg16
		port map(
			CLK=>CLK,
			D=>DIN,
			Q=>sRegisters(idx),
			E=>sRegEnable(idx),
			R=>RESET
		);
		
		sRegEnable(idx) <= (CE and WE) when idx = to_integer(unsigned(AD)) else '0' ;
	end generate;
	
	cCntRegs : for idx in 2 downto 0 generate
		sCLK(idx) <= TMR_CLK(to_integer(unsigned(sRegisters(7)(5 * idx + 2 downto 5 * idx))));
		
		process(sCLK(idx), ld(idx), DIN)
		begin
			if ( ld(idx)='1' ) then
				sIRQ(idx) <= '0' ;
				sRegisters(idx) <= DIN;
			elsif ( sCLK(idx)'event and sCLK(idx)='1' ) then
				sIRQ(idx) <= '0' ;
				if ( sRegisters(7)(5 * idx + 4)='1' ) then
					if ( sRegisters(idx) = x"0000" ) then
						sIRQ(idx) <= '1';
						
						if ( sRegisters(7)(5 * idx + 3)='1' ) then
							sRegisters(idx) <= std_logic_vector(unsigned(sRegisters(4 + idx)) - 1);
						end if;
					else
						sRegisters(idx) <= std_logic_vector(unsigned(sRegisters(idx)) - 1);
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
			
			ld(0) <= CE and WE and (AD(0) nor AD(1));
			ld(1) <= CE and WE and (AD(0) and not AD(1));
			ld(2) <= CE and WE and (not AD(0) and AD(1));
			
			DOUT <= sRegisters(to_integer(unsigned(AD))) and (15 downto 0 => CE and OE);
		end if;
	end process;
end Behavioral;
