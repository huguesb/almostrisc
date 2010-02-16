----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/RAMDoublePort.vhd
--
-- Slightly altered to get rid of vendor-specific packages and adjust formatting
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
			DOUT2 <= memoire(to_integer(unsigned(AD2)));
		end if;
	end process;

	process(CLK)
	begin 
		if (CLK'event AND CLK='1') then
			if ((CE1='1') AND (OE1='1')) then 
				DOUT1<=memoire(to_integer(unsigned(AD1)));
			else 
				DOUT1<=(others =>'0');
			end if;		
		end if;
	end process;
	
	process (CLK)
	begin
	  IF (CLK'event AND CLK='1') then
			if ((CE1='1') AND (WE1='1')) then 
				memoire(to_integer(unsigned(AD1)))<=DIN1;
			end if;
		  end if;
	end process;
	
end Behavioral;

