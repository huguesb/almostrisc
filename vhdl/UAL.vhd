----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/UAL.vhd
--
-- Slightly altered to get rid of vendor-specific packages
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UAL is
	Port (
		A : in std_logic_vector(15 downto 0);
		B : in std_logic_vector(15 downto 0);
		op : in std_logic_vector(5 downto 0);
		CIN : in std_logic;
		S : out std_logic_vector(15 downto 0);
		COUT : out std_logic
	);
end UAL;

architecture Behavioral of UAL is
	component fast_adder
		generic(
			size : natural := 16
		);
		
		Port(
			A : in unsigned(size -1 downto 0);
			B : in unsigned(size -1 downto 0);
			CIN : in std_logic;
			
			S : out unsigned(size -1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	component shifter
		generic(
			size : natural := 16;
			level : natural := 4
		);
		
		Port(
			A : in unsigned(size -1 downto 0);
			D : in unsigned(level -1 downto 0);
			Right : in std_logic;
			Rotate : in std_logic;
			
			S : out unsigned(size -1 downto 0);
			COUT : out std_logic
		);
	end component;
	
	signal sCin, sCarith, sCLogic, sCShift, sCLoad, sCnegA, sCnegB : std_logic;
	signal SnegA, SnegB, sMuxB : unsigned(15 downto 0);
	signal Ai, Bi, nAi, nBi, sSArith, sSLogic, sSShift, sSLoad : unsigned(15 downto 0);
begin
	cNegA : fast_adder
	port map(
		A=>nAi,
		B=>x"0000",
		Cin=>'1',
		S=>SNegA,
		Cout=>sCnegA
	);
	
	cNegB : fast_adder
	port map(
		A=>nBi,
		B=>x"0000",
		Cin=>'1',
		S=>SNegB,
		Cout=>sCnegB
	);
	
	cAdd : fast_adder
	port map(
		A=>Ai,
		B=>sMuxB,
		Cin=>sCin,
		S=>sSArith,
		Cout=>sCarith
	);
	
	Ai <= unsigned(A);
	Bi <= unsigned(B);
	
	nAi <= not Ai;
	nBi <= not Bi;
	
	-- A sub B = A + ((not B) + 1
	-- A sbc B = A + ((not B) + not cin)
	
	process(op, Bi, nBi, CIN)
	begin
		case op(2 downto 0) is
			when "010" => sMuxB <= x"0000"; sCin <= '1'    ; -- inc
			when "011" => sMuxB <= x"FFFF"; sCin <= '0'    ; -- dec
			when "100" => sMuxB <= Bi     ; sCin <= '0'    ; -- add
			when "101" => sMuxB <= nBi    ; sCin <= '1'    ; -- sub
			when "110" => sMuxB <= Bi     ; sCin <= CIN    ; -- adc
			when "111" => sMuxB <= nBi    ; sCin <= not CIN; -- sbc
			when others => sMuxB <= (others => 'Z' ); sCin <= 'Z' ;
		end case;
	end process;
	
	cShifter : shifter
	port map(
		A=>Ai,
		D=>unsigned(op(3 downto 0)),
		Right=>op(4),
		Rotate=>'0',
		S=>sSShift,
		Cout=>sCShift
	);
	
	process(op, Ai, Bi, SNegA, SNegB, sCNegA, sCNegB, Cin)
	begin
		sCLoad <= Cin;
		case op(1 downto 0) is
			when "00" => sSLoad <= Ai;
			when "01" => sSLoad <= Bi;
			when "10" => sSLoad <= SNegA; sCLoad <= sCNegA;
			when others => sSLoad <= SNegB; sCLoad <= sCNegB;
		end case;
	end process;
-- 	
	process(op, Ai, Bi)
	begin
		case op(1 downto 0) is
			when "00" => sSLogic <= Ai and Bi;
			when "01" => sSLogic <= Ai or  Bi;
			when "10" => sSLogic <= Ai xor Bi;
			when others => sSLogic <= not Ai;
		end case;
	end process;
	
	process (sSLogic, sCLogic, sSArith, sCArith, sSShift, sCShift, sSLoad, sCLoad, op, Cin)
	begin
		Cout <= Cin;
		
		if ( op(5)='1' ) then
			S <= std_logic_vector(sSShift);
			Cout <= sCShift;
		else
			case op(4 downto 3) is
				when "00" => S <= std_logic_vector(sSArith); Cout <= sCArith;
				when "01" => S <= std_logic_vector(sSLoad);  Cout <= sCLoad;
				when "10" => S <= std_logic_vector(sSLogic); Cout <= sCLogic;
				when others => S <= (others => 'Z' ); 
			end case;
		end if;
	end process;
end Behavioral;
