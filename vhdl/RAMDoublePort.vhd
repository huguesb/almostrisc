library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAMDoublePort is
    Port ( AD1 : in  STD_LOGIC_VECTOR (12 downto 0);
           AD2 : in  STD_LOGIC_VECTOR (12 downto 0);
           DIN1 : in  STD_LOGIC_VECTOR (15 downto 0);
           DOUT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           WE1 : in  STD_LOGIC;
           DOUT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           OE1 : in  STD_LOGIC;
           CE1 : in  STD_LOGIC;
			  CLK : in STD_LOGIC);
end RAMDoublePort;

architecture Behavioral of RAMDoublePort is
 constant low_address: natural := 0;
 constant high_address: natural := 8192;  
 subtype octet is std_logic_vector( 15 downto 0 );
 type zone_memoire is
         array (natural range low_address to high_address) of octet;
 signal memoire: zone_memoire;
begin
   process(CLK)
	begin 
		if (CLK'event AND CLK='1') then
			DOUT2 <= memoire(conv_integer(AD2));
		end if;
	end process;

	process(CLK)
	begin 
		if (CLK'event AND CLK='1') then
			if ((CE1='1') AND (OE1='1')) then 
				DOUT1<=memoire(conv_integer(AD1));
			else 
				DOUT1<=(others =>'0');
			end if;		
		end if;
	end process;
	
	process (CLK)
	begin
	  IF (CLK'event AND CLK='1') then
			if ((CE1='1') AND (WE1='1')) then 
				memoire(conv_integer(AD1))<=DIN1;
			end if;
		  end if;
	end process;
	
end Behavioral;

