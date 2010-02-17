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
-- offer 3 "programmable" countdown timers with a base clock of 1MHz (assuming
-- a circuit clock of 50MHz)
--

architecture Behavioral of Timer is
	component reg16
		Port(
			CLK, E, R : in std_logic;
			D : in std_logic_vector(15 downto 0);
			Q : out std_logic_vector(15 downto 0)
		);
	end component;
	
	type reg16array is array (integer range <>) of std_logic_vector(15 downto 0);
	
	signal sRegisters : reg16array(7 downto 0);
	signal sRegInput : reg16array(2 downto 0);
	signal sRegNull, sRegRes : std_logic_vector(2 downto 0);
	signal sRegEnable : std_logic_vector(7 downto 0);
	
	signal ctrl_chg : std_logic;
	signal TMR_CLK : std_logic;
	signal cnt_base : unsigned(5 downto 0) := "000000";
begin
	-- clock divider : produce 1MHz timer clock from 50MHz circuit clock
	process (CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			if ( RESET='1' ) then
				cnt_base <= (others => '0' );
				TMR_CLK <= '1' ;
			else
				cnt_base <= cnt_base + 1;
				
				if ( cnt_base = 24 ) then
					cnt_base <= (others => '0' );
					TMR_CLK <= not TMR_CLK;
				end if;
			end if;
		end if;
	end process;
	
	-- status, control and counter registers
	-- 0-2 : loop current count [R0]
	-- 3 : status [RO]
	-- 4-6 : loop base count [RW]
	-- 7 : control 0xghij : g=general, h,i,j=per-timer setup : b0=enable, b1=interrupt, b2=loop [RW]
	
	ctrl_chg <= WE and AD(2) and AD(1) and AD(0);
	
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
-- 		cCounter : reg16
-- 		port map(
-- 			CLK=>TMR_CLK,
-- 			D=>sRegInput(idx),
-- 			Q=>sRegisters(idx),
-- 			E=>sRegEnable(idx),
-- 			R=>RESET
-- 		);
		
		cCounter : process (TMR_CLK, sRegRes(idx)) is
		begin
			if ( RESET='1' ) then
				sRegisters(idx) <= x"0000";
			elsif ( sRegRes(idx)='1' ) then
				sRegisters(idx) <= sRegInput(idx);
			elsif ( TMR_CLK'event and TMR_CLK='1' ) then
				if ( sRegEnable(idx)='1' ) then
					sRegisters(idx) <= sRegInput(idx);
				end if;
			end if;
		end process;
		
		-- reset upon change in enable status
		sRegRes(idx) <= ctrl_chg and (DIN(4 * idx) xor sRegisters(7)(4 * idx));
		
		sRegNull(idx) <= (sRegisters(idx)(0) nor sRegisters(idx)(1))
						and (sRegisters(idx)(2) nor sRegisters(idx)(3))
						and (sRegisters(idx)(4) nor sRegisters(idx)(5))
						and (sRegisters(idx)(6) nor sRegisters(idx)(7))
						;
		
		IRQ(idx) <= sRegisters(7)(4 * idx)
					and sRegisters(7)(4 * idx + 1)
					and sRegNull(idx)
					and not sRegRes(idx);
		
		sRegEnable(idx) <= sRegisters(7)(4 * idx) and (not sRegNull(idx) or sRegisters(7)(4 * idx + 2));
		
		sRegInput(idx) <=	sRegisters(4 + idx) when (sRegRes(idx) or sRegNull(idx))='1' else
							std_logic_vector(unsigned(sRegisters(idx)) - 1);
	end generate;
	
	process(CLK)
	begin
		if ( CLK'event and CLK='1' ) then
			if ( WE='1' ) then
				if ( ((AD(1) nor AD(2)) or (AD(0) nor AD(2))) ='1' ) then
					-- trying to write to counters or status : exception?
					
				end if;
			end if;
			
			DOUT <= sRegisters(to_integer(unsigned(AD))) and (15 downto 0 => CE and OE);
		end if;
	end process;
end Behavioral;
