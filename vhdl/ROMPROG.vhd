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
0=>x"C100",     -- 1100000100000000  li r0, 0x20                                
1=>x"4E00",     -- 0100111000000000  shl        r0, r0, 7                       
2=>x"C009",     -- 1100000000001001  li r1, 1                                   
3=>x"D201",     -- 1101001000000001  sw r1, r0                                  
4=>x"0400",     -- 0000010000000000  inc        r0, r0                          
5=>x"CFF9",     -- 1100111111111001  li r1, -1                                  
6=>x"D201",     -- 1101001000000001  sw r1, r0                                  
7=>x"C03A",     -- 1100000000111010  li r2, 7                                   
8=>x"0880",     -- 0000100010000000  add        r0, r0, r2                      
9=>x"C0C2",     -- 1100000011000010  li r2, 0x18                                
10=>x"D202",    -- 1101001000000010  sw r2, r0                                  
11=>x"0400",    -- 0000010000000000  inc        r0, r0                          
12=>x"C012",    -- 1100000000010010  li r2, 2                                   
13=>x"D202",    -- 1101001000000010  sw r2, r0                                  
14=>x"C788",    -- 1100011110001000  li r0, start - ($+1)                       
15=>x"E003",    -- 1110000000000011  br -, r0                                   
16=>x"C100",    -- 1100000100000000  li r0, 0x20                                
17=>x"4E00",    -- 0100111000000000  shl        r0, r0, 7                       
18=>x"C012",    -- 1100000000010010  li r2, 2                                   
19=>x"0880",    -- 0000100010000000  add        r0, r0, r2                      
20=>x"CFF9",    -- 1100111111111001  li r1, -1                                  
21=>x"D201",    -- 1101001000000001  sw r1, r0                                  
22=>x"261B",    -- 0010011000011011  not r3, r3                                 
23=>x"D6C0",    -- 1101011011000000  out        r3                              
24=>x"FFFE",    -- 1111111111111110  reti                                       
256=>x"C750",   -- 1100011101010000  li r0, 234                                 
257=>x"C1C2",   -- 1100000111000010  li r2, 56                                  
258=>x"C013",   -- 1100000000010011  li r3, div_16_16 - ($+1)                   
259=>x"F0C6",   -- 1111000011000110  brl        r6, r3                  
260=>x"BF03",   -- 1011111100000011  bri        -, test.div                             
261=>x"2449",   -- 0010010001001001  xor        r1, r1, r1                      
262=>x"C084",   -- 1100000010000100  li r4, 16                                  
263=>x"0800",   -- 0000100000000000  add        r0, r0, r0                      
264=>x"0C49",   -- 0000110001001001  adc        r1, r1, r1                      
265=>x"0A8B",   -- 0000101010001011  sub        r3, r1, r2                      
266=>x"80DD",   -- 1000000011011101  brilt      r3, div_16_16.skip              
267=>x"0A89",   -- 0000101010001001  sub        r1, r1, r2                      
268=>x"0400",   -- 0000010000000000  inc        r0, r0                          
269=>x"0624",   -- 0000011000100100  dec        r4, r4                          
270=>x"BE64",   -- 1011111001100100  brine      r4, div_16_16.loop              
271=>x"E383",   -- 1110001110000011  ba -, r6                                   
272=>x"C448",   -- 1100010001001000  li r0, 137                                 
273=>x"C472",   -- 1100010001110010  li r2, 142                                 
274=>x"C013",   -- 1100000000010011  li r3, mult_16_16 - ($+1)                  
275=>x"F0C6",   -- 1111000011000110  brl        r6, r3                          
276=>x"FFFF",   -- 1111111111111111  reset                                      
277=>x"2449",   -- 0010010001001001  xor        r1, r1, r1                      
278=>x"2524",   -- 0010010100100100  xor        r4, r4, r4                      
279=>x"C085",   -- 1100000010000101  li r5, 16                                  
280=>x"0849",   -- 0000100001001001  add        r1, r1, r1                      
281=>x"0C00",   -- 0000110000000000  adc        r0, r0, r0                      
282=>x"0EDB",   -- 0000111011011011  sbc        r3, r3, r3                      
283=>x"209B",   -- 0010000010011011  and        r3, r3, r2                      
284=>x"08C9",   -- 0000100011001001  add        r1, r1, r3                      
285=>x"0D00",   -- 0000110100000000  adc        r0, r0, r4                      
286=>x"062D",   -- 0000011000101101  dec        r5, r5
287=>x"BE6C",   -- 1011111001101100  brine      r5, mult_16_16.loop
288=>x"E383",   -- 1110001110000011  ba -, r6
289=>x"460B",   -- 0100011000001011  shl r3, r1, 3
290=>x"4209",   -- 0100001000001001  shl        r1, r1, 1
291=>x"085B",   -- 0000100001011011  add        r3, r3, r1
292=>x"6601",   -- 0110011000000001  shr        r1, r0, 3
293=>x"0E00",   -- 0000111000000000  sbc        r0, r0, r0
294=>x"085B",   -- 0000100001011011  add        r3, r3, r1
295=>x"C024",   -- 1100000000100100  li r4, 4
296=>x"D011",   -- 1101000000010001  lw r1, r2
297=>x"0624",   -- 0000011000100100  dec        r4, r4
298=>x"BFA4",   -- 1011111110100100  brine      r4, sprite_aligned_8.loop
299=>x"E383",   -- 1110001110000011  ba -, r6
300=>x"FFFF",   -- 1111111111111111  reset

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
