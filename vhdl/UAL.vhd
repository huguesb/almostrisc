library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UAL is
    Port ( A : in std_logic_vector(15 downto 0);
           B : in std_logic_vector(15 downto 0);
	   op : in std_logic_vector(5 downto 0);
	   CIN : in std_logic;
           S : out std_logic_vector(15 downto 0);
           COUT : out std_logic);
end UAL;

architecture Behavioral of UAL is
	signal Sinterne: std_logic_vector(16 downto 0);
begin
	S(15 downto 0)<=Sinterne(15 downto 0);
	COUT<=Sinterne(16);
	
	process (A,B,CIN,op)
	begin
		CASE op IS
		when "000000" => Sinterne <= ('0' & A) + ('0' & B );
		when "000001" => Sinterne <= ('0' & A) - ('0' & B );
		when "000010" => Sinterne <= ('0' & A) +1;
		when "000011" => Sinterne <= ('0' & A) -1;
		when "000100" => Sinterne <= ('0' & A) + ('0' & B ) + (x"0000" & CIN);
		when "000101" => Sinterne <= ('0' & A) - ('0' & B ) - (x"0000" & CIN);

		when "000110" => Sinterne <= ('0' & A);
		when "000111" => Sinterne <= ('0' & B);
		when "001000" => Sinterne <= 0-(A(15) & A);
		when "001001" => Sinterne <= 0-(B(15) & B);

		when "010000" => Sinterne <= ('0' & A) AND ('0' & B );
		when "010001" => Sinterne <= ('0' & A) OR ('0' & B );
		when "010010" => Sinterne <= ('0' & A) XOR ('0' & B );
		when "010011" => Sinterne <= NOT ('0' & A);
		
		when others =>
		  if (op(5 downto 4)="10") then 
			case op(3 downto 0) IS
			when "0000" => Sinterne<=A(15 downto 0) & "0";
			when "0001" => Sinterne<=A(14 downto 0) & "00";
			when "0010" => Sinterne<=A(13 downto 0) & "000";
			when "0011" => Sinterne<=A(12 downto 0) & "0000";
			when "0100" => Sinterne<=A(11 downto 0) & "00000";
			when "0101" => Sinterne<=A(10 downto 0) & "000000";
			when "0110" => Sinterne<=A(9 downto 0)  & "0000000";
			
			when "0111" => Sinterne<=A(8 downto 0)  & "00000000";
			
			when "1000" => Sinterne<=A(7 downto 0)  & "000000000";
			when "1001" => Sinterne<=A(6 downto 0)  & "0000000000";
			when "1010" => Sinterne<=A(5 downto 0)  & "00000000000";
			when "1011" => Sinterne<=A(4 downto 0)  & "000000000000";
			when "1100" => Sinterne<=A(3 downto 0)  & "0000000000000";
			when "1101" => Sinterne<=A(2 downto 0)  & "00000000000000";
			when "1110" => Sinterne<=A(1 downto 0)  & "000000000000000";
			
			when others => Sinterne<=A(0)           & "0000000000000000";
			end case;
		  else
			case op(3 downto 0) IS
			when "0000" => Sinterne<= "00" & A(15 downto 1);
			when "0001" => Sinterne<= "000" & A(15 downto 2);
			when "0010" => Sinterne<= "0000" & A(15 downto 3);
			when "0011" => Sinterne<= "00000" & A(15 downto 4);
			when "0100" => Sinterne<= "000000" & A(15 downto 5);
			when "0101" => Sinterne<= "0000000" & A(15 downto 6);
			when "0110" => Sinterne<= "00000000" & A(15 downto 7);
			
			when "0111" => Sinterne<= "000000000" & A(15 downto 8);
			when "1000" => Sinterne<= "0000000000" & A(15 downto 9);
			when "1001" => Sinterne<= "00000000000" & A(15 downto 10);
			when "1010" => Sinterne<= "000000000000" & A(15 downto 11);
			when "1011" => Sinterne<= "0000000000000" & A(15 downto 12);
			when "1100" => Sinterne<= "00000000000000" & A(15 downto 13);
			when "1101" => Sinterne<= "000000000000000" & A(15 downto 14);
			when "1110" => Sinterne<= "0000000000000000" & A(15);
			when others => Sinterne<= "00000000000000000";
			end case;
		 end if;
		end case;
	end process;
end Behavioral;
