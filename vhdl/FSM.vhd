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
		IR : in std_logic_vector(15 downto 0);
		COND : in std_logic;
		
		EIR : out std_logic;
		
		EPC, CLRPC, LDPC, SelPC, SelPCOff : out std_logic;
		
		op : out std_logic_vector(5 downto 0);
		SelCond : out std_logic_vector(2 downto 0);
		ImmOff : out std_logic_vector(15 downto 0);
		
		SelRIn, SelRa, SelRb, SelRd : out std_logic_vector(2 downto 0);
		
		ERd, ECarry, EOut : out std_logic;
		
		CE, WE, OE : out std_logic
	);
end FSM;

architecture Behavioral of FSM is
	type StateType is (
		SReset,
		SStall,
		SFetch,
		SDecode
	);
	
	signal sForceExec : std_logic;
	signal sCurState, sNextState : StateType;
begin

	-- generic state switching code
	process (CLK, RESET) 
	begin 
		if ( CLK'event and CLK='1' ) then 
			if ( RESET='1' ) then
				sCurState <= SReset;
			else
				sCurState <= sNextState;
			end if;
		end if;
	end process;
	
	
	-- wire for all cases :
	op <= IR(14 downto 9);
	SelRb <= IR(8 downto 6);
	SelRa <= IR(5 downto 3);
	SelRd <= IR(2 downto 0);
	SelCond <= IR(2 downto 0);
	
	EPC <= '1' ;
	CE <= '1' ;
	
	process (sCurState, IR, COND)
	begin
		-- determine next state
		case sCurState is
			when SReset =>
				sNextState <= SStall;
				
			when SStall =>
				-- stall state upon PC change
				sNextState <= SFetch;
				
			when SFetch =>
				-- IR = PC
				-- PC = PC + 1
				sNextState <= SDecode;
				
			when SDecode =>
			
				if ( IR = x"FFFF" ) then
					-- RESET : PC = 0
					sNextState <= SReset;
				elsif ( (COND='1' and (IR(15 downto 10) = "111000" or IR(15 downto 14) = "10")) or IR(15 downto 10) = "111100" ) then
					
					--IR(15) and (((IR(14) and IR(13) and not IR(11) and not IR(10)) and (IR(12) or COND)) or (COND and not IR(14)))
					
					-- BRcc/BAcc
					-- BRL/BAL
					-- BRIcc
					
					sNextState <= SStall;
				else
					sNextState <= SDecode;
				end if;
				
		end case;
		
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
		
		-- state-specific code
		
		case sCurState is
			when SReset =>
				-- init fsm (somehow impossible to merge with STALL)
				-- without artifacts in PC (reg16 do not like E and R at the same time)
				
				CLRPC <= '1' ;
				
			when SStall =>
				-- stall state upon PC change
				
			when SFetch =>
				-- IR = PC
				-- PC = PC + 1
				
				EIR <= '1' ;
				
			when SDecode =>
			
				if ( IR(15) = '0' ) then
					-- UAL : Rd = Ra op Rb
					
					ERd <= '1' ;
					ECarry <= '1' ;
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 9) = "1101010" ) then
					-- IN : Rd = ports
					
					ERd <= '1' ;
					SelRIn <= "011";
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 9) = "1101011" ) then
					-- OUT : ports = Rb
					
					EOUT <= '1' ;
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 9) = "1101000" ) then
					-- LW : Rd = (Ra)
					
					OE <= '1' ;
					
					ERd <= '1' ;
					SelRIn <= "001";
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 9) = "1101001" ) then
					-- SW : (Ra) = Rd
					
					WE <= '1' ;
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 10) = "111000" ) then
					-- BRcc/BAcc
					
					EIR <= not COND;
					
					LDPC <= COND ;
					SelPC <= IR(9);
					SelPCOff <= '1' ;
					
				elsif ( IR(15 downto 10) = "111100" ) then
					-- BRL/BAL
					
					ERd <= '1' ;
					SelRIn <= "010";
					
					LDPC <= '1' ;
					SelPC <= IR(9);
					SelPCOff <= '1' ;
					
				elsif ( IR(15 downto 12) = "1100" ) then
					-- LI 
					
					ImmOff <= std_logic_vector(resize(signed(IR(11 downto 3)), 16));
					
					ERd <= '1' ;
					SelRIn <= "100";
					
					-- prefetching
					EIR <= '1' ;
					
				elsif ( IR(15 downto 14) = "10" ) then
					-- BRIcc
					
					ImmOff <= std_logic_vector(resize(signed(IR(13 downto 6)), 16));
					
					EIR <= not COND;
					LDPC <= COND ;
					
				else
					-- prefetching
					EIR <= '1' ;
					
				end if;
				
		end case;
	end process;
	
end Behavioral;
