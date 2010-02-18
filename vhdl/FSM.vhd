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

entity FSM is
	Port(
		CLK : in std_logic;
		RESET : in std_logic;
		INT : std_logic;
		
		IR : in std_logic_vector(15 downto 0);
		COND : in std_logic;
		
		EIR : out std_logic;
		
		EPC, CLRPC, LDPC, SelPC, SelPCOff : out std_logic;
		
		op : out std_logic_vector(5 downto 0);
		SelCond : out std_logic_vector(2 downto 0);
		ImmOff : out std_logic_vector(15 downto 0);
		
		SelRIn, SelRa, SelRb, SelRd : out std_logic_vector(2 downto 0);
		
		ERd, ECarry, EOut : out std_logic;
		
		CE, WE, OE : out std_logic;
		
		SelReti : out std_logic;
		EINT : out std_logic;
		INTi : out std_logic;
		INTo : in std_logic
	);
end FSM;

architecture Behavioral of FSM is
	type StateType is (
		SReset,
		SStall,
		SFetch,
		SDecode,
		SLoad,
		SInterrupt
	);
	
	--signal sPostponedIRQ : std_logic;
	signal sCurState, sNextState : StateType;
begin
	-- generic state switching code
	process (CLK) 
	begin 
		if ( CLK'event and CLK='1' ) then 
			if ( RESET='1' ) then
				sCurState <= SReset;
				--sPostponedIRQ <= '0' ;
			elsif ( INT='1' and INTo='0' and (sNextState = SDecode) ) then
				sCurState <= SInterrupt;
				--sPostponedIRQ <= '0' ;
			else
				--sPostponedIRQ <= INT or sPostponedIRQ;
				sCurState <= sNextState;
			end if;
		end if;
	end process;
	
	-- state output
	process (sCurState, IR, COND, INTo)
	begin
		
		--determine outputs
		
		-- common code to avoid latch inference without bloating state-specific code
		-- (latch inference is apparently responsible for misinterpretation of some
		-- signals as clock nets which in turn causes a whole lot of trouble)
		
		-- default values to avoid latch inference
		SelRIn <= "000";
		SelPC <= '0' ;
		SelPCOff <= '0' ;
		ImmOff <= x"0000";
		
		EIR <= '0' ;
		EPC <= '1' ;
		LDPC <= '0' ;
		CLRPC <= '0' ;
		SelPC <= '0' ;
		
		WE <= '0' ;
		OE <= '0' ;
		
		-- no port output unless otherwise notified
		EOUT <= '0' ;
		
		-- no register change unless otherwise notified
		ERd <= '0' ;
		ECarry <= '0' ;
		
		EINT <= '0' ;
		INTi <= '0' ;
		SelReti <= '0' ;
		
		-- state-specific code
		
		case sCurState is
			when SReset =>
				-- init fsm (somehow impossible to merge with STALL)
				-- without artifacts in PC (reg16 do not like E and R at the same time)
				
				CLRPC <= '1' ;
				sNextState <= SStall;
				
			when SStall =>
				-- stall state upon PC change
				sNextState <= SFetch;
				
			when SFetch =>
				-- IR = PC
				-- PC = PC + 1
				
				EIR <= '1' ;
				
				sNextState <= SDecode;
				
			when SDecode =>
				ECarry <= not IR(15);
				
				if ( IR = x"FFFF" ) then
					-- RESET : PC = 0
					sNextState <= SReset;
				elsif ( IR = x"FFFE" ) then
					-- RETI :
					EINT <= '1' ;
					SelReti <= '1' ;
					
					sNextState <= SStall;
					
				elsif ( IR(15) = '0' ) then
					-- UAL : Rd = Ra op Rb
					
					-- enable if not nop...
					ERd <= IR(14) or IR(13) or IR(12) or IR(11) or IR(10) or IR(9); --'1' ;
					
					
					SelRIn(2) <= '1' ;
					
					-- prefetching
					EIR <= '1' ;
					sNextState <= SDecode;
					
				elsif ( IR(15 downto 11) = "11010" ) then
					-- IN : Rd = ports  "1101010"
					-- OUT : ports = Rb "1101011"
					-- LW : Rd = (Ra)  ["1101000"]
					-- SW : (Ra) = Rd  ["1101001"]
					
					ERd <= not IR(9) and IR(10);
					SelRIn(1) <= IR(10) ;
					
					EOUT <= IR(9) and IR(10);
					
					WE <= IR(9) and not IR(10);
					OE <= IR(9) nor IR(10);
					
					EIR <= '1' ;
					EPC <= IR(9) or IR(10);
					
					if ( IR(9)='0' and IR(10)='0' ) then
						--EPC <= '0' ;
						sNextState <= SLoad;
					else
						-- prefetching
						--EIR <= '1' ;
						sNextState <= SDecode;
					end if;
				elsif ( IR(15 downto 10) = "111000" ) then
					-- BRcc/BAcc
					
					EIR <= not COND;
					
					LDPC <= COND ;
					SelPC <= IR(9);
					SelPCOff <= '1' ;
					
					if ( COND='1' ) then
						sNextState <= SStall;
					else
						sNextState <= SDecode;
					end if;
				elsif ( IR(15 downto 10) = "111100" ) then
					-- BRL/BAL
					
					ERd <= '1' ;
					SelRIn <= "001" ;
					
					LDPC <= '1' ;
					SelPC <= IR(9);
					SelPCOff <= '1' ;
					
					sNextState <= SStall;
					
				elsif ( IR(15 downto 12) = "1100" ) then
					-- LI 
					
					ImmOff <= std_logic_vector(resize(signed(IR(11 downto 3)), 16));
					
					ERd <= '1' ;
					SelRIn <= "011";
					
					-- prefetching
					EIR <= '1' ;
					sNextState <= SDecode;
					
				elsif ( IR(15 downto 14) = "10" ) then
					-- BRIcc
					
					ImmOff <= std_logic_vector(resize(signed(IR(13 downto 6)), 16));
					
					EIR <= not COND;
					LDPC <= COND ;
					
					if ( COND='1' ) then
						sNextState <= SStall;
					else
						sNextState <= SDecode;
					end if;
				else
					-- prefetching
					EIR <= '1' ;
					sNextState <= SDecode;
				end if;
				
			when SLoad =>
				ERd <= '1' ;
				--OE <= '1' ;
				--EIR <= '1' ;
				
				sNextState <= SDecode;
				
			when SInterrupt =>
				
				if ( INTo='0' ) then
					EINT <= '1' ;
					INTi <= '1' ;
					
					-- set PC to interrupt handler...
					
					LDPC <= '1' ;
					SelPC <= '1' ;
					ImmOff <= x"0010";
					sNextState <= SStall;
				else
					EPC <= '0' ;
					sNextState <= SDecode;
				end if;
				
		end case;
	end process;
	
	-- wire for all cases :
	op <= IR(14 downto 9);
	SelRb <= IR(8 downto 6);
	SelRa <= IR(5 downto 3);
	SelRd <= IR(2 downto 0);
	SelCond <= IR(2 downto 0);
	
	CE <= '1' ;
	
end Behavioral;
