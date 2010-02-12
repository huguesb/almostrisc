library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
    0=>X"D400", -- IN R0
    1=>X"D600", -- OUT R0
    2=>X"FFFF", -- RESET
    others => x"0000"
    );
begin
  process(CLK)
  begin
    if (CLK'event AND CLK='1') then
      D <= m(conv_integer(AD));
    end if;
  end process;
end Behavioral;
