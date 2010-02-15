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
	signal Ai, Bi : unsigned(15 downto 0);
	signal Sinterne: unsigned(16 downto 0);
begin
	Ai <= unsigned(A);
	Bi <= unsigned(B);
	S(15 downto 0)<=std_logic_vector(Sinterne(15 downto 0));
	COUT<=Sinterne(16);
	
	process (Ai,Bi,CIN,op)
	begin
		CASE op IS
		when "000000" => Sinterne <= ('0' & Ai) + ('0' & Bi );
		when "000001" => Sinterne <= ('0' & Ai) - ('0' & Bi );
		when "000010" => Sinterne <= ('0' & Ai) +1;
		when "000011" => Sinterne <= ('0' & Ai) -1;
		when "000100" => Sinterne <= ('0' & Ai) + ('0' & Bi ) + (x"0000" & CIN);
		when "000101" => Sinterne <= ('0' & Ai) - ('0' & Bi ) - (x"0000" & CIN);

		when "000110" => Sinterne <= ('0' & Ai);
		when "000111" => Sinterne <= ('0' & Bi);
		when "001000" => Sinterne <= 0-(Ai(15) & Ai);
		when "001001" => Sinterne <= 0-(Bi(15) & Bi);

		when "010000" => Sinterne <= ('0' & Ai) AND ('0' & Bi );
		when "010001" => Sinterne <= ('0' & Ai) OR ('0' & Bi );
		when "010010" => Sinterne <= ('0' & Ai) XOR ('0' & Bi );
		when "010011" => Sinterne <= NOT ('0' & Ai);
		
		when others =>
		  if (op(5 downto 4)="10") then 
			case op(3 downto 0) IS
			when "0000" => Sinterne<=Ai(15 downto 0) & "0";
			when "0001" => Sinterne<=Ai(14 downto 0) & "00";
			when "0010" => Sinterne<=Ai(13 downto 0) & "000";
			when "0011" => Sinterne<=Ai(12 downto 0) & "0000";
			when "0100" => Sinterne<=Ai(11 downto 0) & "00000";
			when "0101" => Sinterne<=Ai(10 downto 0) & "000000";
			when "0110" => Sinterne<=Ai(9 downto 0)  & "0000000";
			
			when "0111" => Sinterne<=Ai(8 downto 0)  & "00000000";
			
			when "1000" => Sinterne<=Ai(7 downto 0)  & "000000000";
			when "1001" => Sinterne<=Ai(6 downto 0)  & "0000000000";
			when "1010" => Sinterne<=Ai(5 downto 0)  & "00000000000";
			when "1011" => Sinterne<=Ai(4 downto 0)  & "000000000000";
			when "1100" => Sinterne<=Ai(3 downto 0)  & "0000000000000";
			when "1101" => Sinterne<=Ai(2 downto 0)  & "00000000000000";
			when "1110" => Sinterne<=Ai(1 downto 0)  & "000000000000000";
			
			when others => Sinterne<=Ai(0)           & "0000000000000000";
			end case;
		  else
			case op(3 downto 0) IS
			when "0000" => Sinterne<= "00" & Ai(15 downto 1);
			when "0001" => Sinterne<= "000" & Ai(15 downto 2);
			when "0010" => Sinterne<= "0000" & Ai(15 downto 3);
			when "0011" => Sinterne<= "00000" & Ai(15 downto 4);
			when "0100" => Sinterne<= "000000" & Ai(15 downto 5);
			when "0101" => Sinterne<= "0000000" & Ai(15 downto 6);
			when "0110" => Sinterne<= "00000000" & Ai(15 downto 7);
			
			when "0111" => Sinterne<= "000000000" & Ai(15 downto 8);
			when "1000" => Sinterne<= "0000000000" & Ai(15 downto 9);
			when "1001" => Sinterne<= "00000000000" & Ai(15 downto 10);
			when "1010" => Sinterne<= "000000000000" & Ai(15 downto 11);
			when "1011" => Sinterne<= "0000000000000" & Ai(15 downto 12);
			when "1100" => Sinterne<= "00000000000000" & Ai(15 downto 13);
			when "1101" => Sinterne<= "000000000000000" & Ai(15 downto 14);
			when "1110" => Sinterne<= "0000000000000000" & Ai(15);
			when others => Sinterne<= "00000000000000000";
			end case;
		 end if;
		end case;
	end process;
end Behavioral;
