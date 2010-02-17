----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/ROMPROG.vhd
--
-- Slightly altered to get rid of vendor-specific packages and adjust formatting
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROMPROG is
  Port ( AD : in  STD_LOGIC_VECTOR (12 downto 0);
         D : out  STD_LOGIC_VECTOR (15 downto 0);
         CLK : in STD_LOGIC);
end ROMPROG;

architecture Behavioral of ROMPROG is
  constant low_address: natural := 0;
  constant high_address: natural := 8192;
  subtype octet is std_logic_vector( 15 downto 0 );
  type zone_memoire is
    array (natural range low_address to high_address-1) of octet;
  constant m: zone_memoire:= (
0=>x"C750",                                                             
1=>x"C1C2",                                                             
2=>x"C02B",                                                             
3=>x"F2C6",                                                             
4=>x"FFFF",                                                             
5=>x"2449",                                                             
6=>x"C084",                                                             
7=>x"0800",                                                             
8=>x"0C49",                                                             
9=>x"0A8B",                                                             
10=>x"80DD",                                                            
11=>x"0A89",                                                            
12=>x"0400",                                                            
13=>x"0624",                                                            
14=>x"BE64",                                                            
15=>x"E383",                                                            
16=>x"C448",                                                            
17=>x"C472",                                                            
18=>x"C0AB",                                                            
19=>x"F2C6",                                                            
20=>x"FFFF",                                                            
21=>x"2449",                                                            
22=>x"2524",
23=>x"C085",
24=>x"0849",
25=>x"0C00",
26=>x"0EDB",
27=>x"209B",
28=>x"08C9",
29=>x"0D00",
30=>x"062D",
31=>x"BE6C",
32=>x"E383",
33=>x"FFFF",

--     0=>X"D400", -- IN R0
--     1=>X"D600", -- OUT R0
--     2=>X"8043", -- bri r0, 1
--     3=>X"D400", -- IN R0
--     4=>X"D600", -- OUT R0
--     5=>X"FFFF", -- RESET
    others => x"0000"
    );
begin
  process(CLK)
  begin
    if (CLK'event AND CLK='1') then
      D <= m(to_integer(unsigned(AD)));
    end if;
  end process;
end Behavioral;
