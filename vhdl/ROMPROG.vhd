----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/ROMPROG.vhd
--
-- Slightly altered to get rid of vendor-specific packages and adjust formatting
-- Now auto-filled by asrom script
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
    0=>x"FFF7",	-- 1111111111110111  liw	r7, IRQ_mask
    1=>x"2000",	-- 0010000000000000  
    2=>x"F8C0",	-- 1111100011000000  bai	-, os_init
    3=>x"0100",	-- 0000000100000000  
   16=>x"FFF0",	-- 1111111111110000  liw	r0, IRQ_ack
   17=>x"2002",	-- 0010000000000010  
   18=>x"D001",	-- 1101000000000001  lw	r1, r0
   19=>x"F54A",	-- 1111010101001010  bspl	r2, r1, 5
   20=>x"FB16",	-- 1111101100010110  bailne	r2, r6, int_error
   21=>x"0050",	-- 0000000001010000  
   22=>x"F4CA",	-- 1111010011001010  bspl	r2, r1, 3
   23=>x"FB16",	-- 1111101100010110  bailne	r2, r6, int_kbd
   24=>x"0060",	-- 0000000001100000  
   25=>x"F40A",	-- 1111010000001010  bspl	r2, r1, 0
   26=>x"FB16",	-- 1111101100010110  bailne	r2, r6, int_tmr
   27=>x"0040",	-- 0000000001000000  
   28=>x"CFF9",	-- 1100111111111001  li	r1, -1
   29=>x"D201",	-- 1101001000000001  sw	r1, r0
   30=>x"FFFE",	-- 1111111111111110  reti
   64=>x"263F",	-- 0010011000111111  not r7, r7
   65=>x"D7C0",	-- 1101011111000000  out	r7
   66=>x"E383",	-- 1110001110000011  ba	-, r6
   80=>x"25FF",	-- 0010010111111111  xor	r7, r7, r7
   81=>x"D7C0",	-- 1101011111000000  out	r7
   82=>x"E383",	-- 1110001110000011  ba	-, r6
   96=>x"FFF2",	-- 1111111111110010  liw	r2, PS2_rx
   97=>x"2004",	-- 0010000000000100  
   98=>x"D012",	-- 1101000000010010  lw	r2, r2
   99=>x"C784",	-- 1100011110000100  li	r4, 0xF0
  100=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  101=>x"89E0",	-- 1000100111100000  brieq	r4, int_kbd.release
  102=>x"C704",	-- 1100011100000100  li	r4, 0xE0
  103=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  104=>x"8860",	-- 1000100001100000  brieq	r4, int_kbd.extended
  105=>x"FFF4",	-- 1111111111110100  liw	r4, scan_code_map
  106=>x"1700",	-- 0001011100000000  
  107=>x"601D",	-- 0110000000011101  shr	r5, r3, 0
  108=>x"4E2D",	-- 0100111000101101  shl	r5, r5, 7
  109=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  110=>x"6015",	-- 0110000000010101  shr	r5, r2, 0
  111=>x"0E92",	-- 0000111010010010  sbc	r2, r2, r2
  112=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  113=>x"D024",	-- 1101000000100100  lw	r4, r4
  114=>x"80D4",	-- 1000000011010100  brine	r2, int_kbd.process_low
  115=>x"1B12",	-- 0001101100010010  mixhl	r2, r2, r4
  116=>x"8083",	-- 1000000010000011  bri	-, int_kbd.processed
  117=>x"1912",	-- 0001100100010010  mixhh	r2, r2, r4
  118=>x"1017",	-- 0001000000010111  mova	r7, r2
  119=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map
  120=>x"1900",	-- 0001100100000000  
  121=>x"6615",	-- 0110011000010101  shr	r5, r2, 3
  122=>x"5612",	-- 0101011000010010  shl	r2, r2, 11
  123=>x"7612",	-- 0111011000010010  shr	r2, r2, 11
  124=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  125=>x"C00D",	-- 1100000000001101  li	r5, 1
  126=>x"38AD",	-- 0011100010101101  rrr	r5, r5, r2
  127=>x"D022",	-- 1101000000100010  lw	r2, r4
  128=>x"F41B",	-- 1111010000011011  bspl	r3, r3, 0
  129=>x"80DC",	-- 1000000011011100  brine	r3, int_kbd.notify_release
  130=>x"2352",	-- 0010001101010010  or	r2, r2, r5
  131=>x"80C3",	-- 1000000011000011  bri	-, int_kbd.notified
  132=>x"262D",	-- 0010011000101101  not	r5, r5
  133=>x"2152",	-- 0010000101010010  and	r2, r2, r5
  134=>x"D222",	-- 1101001000100010  sw	r2, r4
  135=>x"C003",	-- 1100000000000011  li	r3, 0
  136=>x"E383",	-- 1110001110000011  ba	-, r6
  137=>x"C014",	-- 1100000000010100  li	r4, 2
  138=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  139=>x"E383",	-- 1110001110000011  ba	-, r6
  140=>x"C00C",	-- 1100000000001100  li	r4, 1
  141=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  142=>x"E383",	-- 1110001110000011  ba	-, r6
  256=>x"FFF0",	-- 1111111111110000  liw	r0, IRQ_mask
  257=>x"2000",	-- 0010000000000000  
  258=>x"C0C9",	-- 1100000011001001  li	r1, 0x19
  259=>x"D201",	-- 1101001000000001  sw	r1, r0
  260=>x"0400",	-- 0000010000000000  inc	r0, r0
  261=>x"CFF9",	-- 1100111111111001  li	r1, -1
  262=>x"D201",	-- 1101001000000001  sw	r1, r0
  263=>x"C03A",	-- 1100000000111010  li	r2, 7
  264=>x"0880",	-- 0000100010000000  add	r0, r0, r2
  265=>x"C0EA",	-- 1100000011101010  li	r2, 0x1D
  266=>x"D202",	-- 1101001000000010  sw	r2, r0
  267=>x"0400",	-- 0000010000000000  inc	r0, r0
  268=>x"C07A",	-- 1100000001111010  li	r2, 15
  269=>x"D202",	-- 1101001000000010  sw	r2, r0
  270=>x"FFF0",	-- 1111111111110000  liw	r0, key_press_map
  271=>x"1900",	-- 0001100100000000  
  272=>x"C001",	-- 1100000000000001  li	r1, 0
  273=>x"D201",	-- 1101001000000001  sw	r1, r0
  274=>x"0400",	-- 0000010000000000  inc	r0, r0
  275=>x"D201",	-- 1101001000000001  sw	r1, r0
  276=>x"0400",	-- 0000010000000000  inc	r0, r0
  277=>x"D201",	-- 1101001000000001  sw	r1, r0
  278=>x"0400",	-- 0000010000000000  inc	r0, r0
  279=>x"D201",	-- 1101001000000001  sw	r1, r0
  280=>x"0400",	-- 0000010000000000  inc	r0, r0
  281=>x"D201",	-- 1101001000000001  sw	r1, r0
  282=>x"0400",	-- 0000010000000000  inc	r0, r0
  283=>x"D201",	-- 1101001000000001  sw	r1, r0
  284=>x"0400",	-- 0000010000000000  inc	r0, r0
  285=>x"D201",	-- 1101001000000001  sw	r1, r0
  286=>x"0400",	-- 0000010000000000  inc	r0, r0
  287=>x"D201",	-- 1101001000000001  sw	r1, r0
  288=>x"0400",	-- 0000010000000000  inc	r0, r0
  289=>x"D201",	-- 1101001000000001  sw	r1, r0
  290=>x"FFF0",	-- 1111111111110000  liw	r0, 0x8421
  291=>x"8421",	-- 1000010000100001  
  292=>x"FFF1",	-- 1111111111110001  liw	r1, 0x1234
  293=>x"1234",	-- 0001001000110100  
  294=>x"D640",	-- 1101011001000000  out	r1
  295=>x"E408",	-- 1110010000001000  exw	r0, r1
  296=>x"E408",	-- 1110010000001000  exw	r0, r1
  297=>x"1842",	-- 0001100001000010  mixhh	r2, r0, r1
  298=>x"1A43",	-- 0001101001000011  mixhl	r3, r0, r1
  299=>x"1C44",	-- 0001110001000100  mixlh	r4, r0, r1
  300=>x"1E45",	-- 0001111001000101  mixll	r5, r0, r1
  301=>x"C01E",	-- 1100000000011110  li	r6, 3
  302=>x"3985",	-- 0011100110000101  rrr	r5, r0, r6
  303=>x"3B8D",	-- 0011101110001101  rrl	r5, r1, r6
  304=>x"3D95",	-- 0011110110010101  rsr	r5, r2, r6
  305=>x"3F9D",	-- 0011111110011101  rsl	r5, r3, r6
  306=>x"FC0E",	-- 1111110000001110  mul	r6, r1, r0
  307=>x"C138",	-- 1100000100111000  li	r0, 39
  308=>x"C001",	-- 1100000000000001  li	r1, 0
  309=>x"FFF2",	-- 1111111111110010  liw	r2, font_map + 4 * 0x23
  310=>x"134C",	-- 0001001101001100  
  311=>x"C043",	-- 1100000001000011  li	r3, 8
  312=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  313=>x"01DC",	-- 0000000111011100  
  314=>x"C020",	-- 1100000000100000  li	r0, 4
  315=>x"C001",	-- 1100000000000001  li	r1, 0
  316=>x"FFF2",	-- 1111111111110010  liw	r2, hello_str
  317=>x"16C0",	-- 0001011011000000  
  318=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  319=>x"01A2",	-- 0000000110100010  
  320=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  321=>x"C0A1",	-- 1100000010100001  li	r1, 20
  322=>x"FFF2",	-- 1111111111110010  liw	r2, 0x2020
  323=>x"2020",	-- 0010000000100000  
  324=>x"D202",	-- 1101001000000010  sw	r2, r0
  325=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  326=>x"FFF2",	-- 1111111111110010  liw	r2, 0x7070
  327=>x"7070",	-- 0111000001110000  
  328=>x"D202",	-- 1101001000000010  sw	r2, r0
  329=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  330=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF8F8
  331=>x"F8F8",	-- 1111100011111000  
  332=>x"D202",	-- 1101001000000010  sw	r2, r0
  333=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  334=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF8F8
  335=>x"F8F8",	-- 1111100011111000  
  336=>x"D202",	-- 1101001000000010  sw	r2, r0
  337=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  338=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF870
  339=>x"F870",	-- 1111100001110000  
  340=>x"D202",	-- 1101001000000010  sw	r2, r0
  341=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  342=>x"FFF2",	-- 1111111111110010  liw	r2, 0x7020
  343=>x"7020",	-- 0111000000100000  
  344=>x"D202",	-- 1101001000000010  sw	r2, r0
  345=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  346=>x"FFF2",	-- 1111111111110010  liw	r2, 0x2070
  347=>x"2070",	-- 0010000001110000  
  348=>x"D202",	-- 1101001000000010  sw	r2, r0
  349=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  350=>x"FFF2",	-- 1111111111110010  liw	r2, 0x0000
  352=>x"D202",	-- 1101001000000010  sw	r2, r0
  353=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  354=>x"C008",	-- 1100000000001000  li	r0, 1
  355=>x"C041",	-- 1100000001000001  li	r1, 8
  356=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  357=>x"12C0",	-- 0001001011000000  
  358=>x"C11B",	-- 1100000100011011  li	r3, 0x23
  359=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  360=>x"01BC",	-- 0000000110111100  
  361=>x"0600",	-- 0000011000000000  dec	r0, r0
  362=>x"FFF2",	-- 1111111111110010  liw	r2, key_press_map
  363=>x"1900",	-- 0001100100000000  
  364=>x"D012",	-- 1101000000010010  lw	r2, r2
  365=>x"8150",	-- 1000000101010000  brieq	r2, event_not_kbd
  366=>x"C003",	-- 1100000000000011  li	r3, 0
  367=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  368=>x"01BC",	-- 0000000110111100  
  369=>x"0600",	-- 0000011000000000  dec	r0, r0
  370=>x"BD03",	-- 1011110100000011  bri	-, event_loop
  371=>x"C750",	-- 1100011101010000  li	r0, 234
  372=>x"C1C2",	-- 1100000111000010  li	r2, 56
  373=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  374=>x"018B",	-- 0000000110001011  
  375=>x"C448",	-- 1100010001001000  li	r0, 137
  376=>x"C472",	-- 1100010001110010  li	r2, 142
  377=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  378=>x"017F",	-- 0000000101111111  
  379=>x"C03A",	-- 1100000000111010  li r2, 7
  380=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  381=>x"0196",	-- 0000000110010110  
  382=>x"FFFF",	-- 1111111111111111  reset
  383=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  384=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  385=>x"C085",	-- 1100000010000101  li	r5, 16
  386=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  387=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  388=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  389=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  390=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  391=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  392=>x"062D",	-- 0000011000101101  dec	r5, r5
  393=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  394=>x"E383",	-- 1110001110000011  ba	-, r6
  395=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  396=>x"C084",	-- 1100000010000100  li	r4, 16
  397=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  398=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  399=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  400=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  401=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  402=>x"0400",	-- 0000010000000000  inc	r0, r0
  403=>x"0624",	-- 0000011000100100  dec	r4, r4
  404=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  405=>x"E383",	-- 1110001110000011  ba	-, r6
  406=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  407=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  408=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  409=>x"0409",	-- 0000010000001001  inc	r1, r1
  410=>x"1008",	-- 0001000000001000  mova	r0, r1
  411=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  412=>x"017F",	-- 0000000101111111  
  413=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  414=>x"017F",	-- 0000000101111111  
  415=>x"0612",	-- 0000011000010010  dec	r2, r2
  416=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  417=>x"E383",	-- 1110001110000011  ba	-, r6
  418=>x"063F",	-- 0000011000111111  dec	r7, r7
  419=>x"D23E",	-- 1101001000111110  sw	r6, r7
  420=>x"D013",	-- 1101000000010011  lw	r3, r2
  421=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  422=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  423=>x"063F",	-- 0000011000111111  dec	r7, r7
  424=>x"D23A",	-- 1101001000111010  sw	r2, r7
  425=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  426=>x"01BC",	-- 0000000110111100  
  427=>x"D03A",	-- 1101000000111010  lw	r2, r7
  428=>x"043F",	-- 0000010000111111  inc	r7, r7
  429=>x"D013",	-- 1101000000010011  lw	r3, r2
  430=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  431=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  432=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  433=>x"063F",	-- 0000011000111111  dec	r7, r7
  434=>x"D23A",	-- 1101001000111010  sw	r2, r7
  435=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  436=>x"01BC",	-- 0000000110111100  
  437=>x"D03A",	-- 1101000000111010  lw	r2, r7
  438=>x"043F",	-- 0000010000111111  inc	r7, r7
  439=>x"0412",	-- 0000010000010010  inc	r2, r2
  440=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  441=>x"D03E",	-- 1101000000111110  lw	r6, r7
  442=>x"043F",	-- 0000010000111111  inc	r7, r7
  443=>x"E383",	-- 1110001110000011  ba	-, r6
  444=>x"063F",	-- 0000011000111111  dec	r7, r7
  445=>x"D23E",	-- 1101001000111110  sw	r6, r7
  446=>x"063F",	-- 0000011000111111  dec	r7, r7
  447=>x"D238",	-- 1101001000111000  sw	r0, r7
  448=>x"063F",	-- 0000011000111111  dec	r7, r7
  449=>x"D239",	-- 1101001000111001  sw	r1, r7
  450=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  451=>x"12C0",	-- 0001001011000000  
  452=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  453=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  454=>x"C043",	-- 1100000001000011  li	r3, 8
  455=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  456=>x"01DC",	-- 0000000111011100  
  457=>x"D039",	-- 1101000000111001  lw	r1, r7
  458=>x"043F",	-- 0000010000111111  inc	r7, r7
  459=>x"D038",	-- 1101000000111000  lw	r0, r7
  460=>x"043F",	-- 0000010000111111  inc	r7, r7
  461=>x"0400",	-- 0000010000000000  inc	r0, r0
  462=>x"D03E",	-- 1101000000111110  lw	r6, r7
  463=>x"043F",	-- 0000010000111111  inc	r7, r7
  464=>x"E383",	-- 1110001110000011  ba	-, r6
  465=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  466=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  467=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  468=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  469=>x"D011",	-- 1101000000010001  lw	r1, r2
  470=>x"D221",	-- 1101001000100001  sw	r1, r4
  471=>x"0412",	-- 0000010000010010  inc	r2, r2
  472=>x"0424",	-- 0000010000100100  inc	r4, r4
  473=>x"061B",	-- 0000011000011011  dec	r3, r3
  474=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  475=>x"E383",	-- 1110001110000011  ba	-, r6
  476=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  477=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  478=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  479=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  480=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  481=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  482=>x"C0A5",	-- 1100000010100101  li	r5, 20
  483=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  484=>x"D010",	-- 1101000000010000  lw	r0, r2
  485=>x"D021",	-- 1101000000100001  lw	r1, r4
  486=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  487=>x"D221",	-- 1101001000100001  sw	r1, r4
  488=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  489=>x"061B",	-- 0000011000011011  dec	r3, r3
  490=>x"E398",	-- 1110001110011000  baeq	r3, r6
  491=>x"D021",	-- 1101000000100001  lw	r1, r4
  492=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  493=>x"D221",	-- 1101001000100001  sw	r1, r4
  494=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  495=>x"0412",	-- 0000010000010010  inc	r2, r2
  496=>x"061B",	-- 0000011000011011  dec	r3, r3
  497=>x"E398",	-- 1110001110011000  baeq	r3, r6
  498=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  499=>x"D010",	-- 1101000000010000  lw	r0, r2
  500=>x"D021",	-- 1101000000100001  lw	r1, r4
  501=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  502=>x"D221",	-- 1101001000100001  sw	r1, r4
  503=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  504=>x"061B",	-- 0000011000011011  dec	r3, r3
  505=>x"E398",	-- 1110001110011000  baeq	r3, r6
  506=>x"D021",	-- 1101000000100001  lw	r1, r4
  507=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  508=>x"D221",	-- 1101001000100001  sw	r1, r4
  509=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  510=>x"0412",	-- 0000010000010010  inc	r2, r2
  511=>x"061B",	-- 0000011000011011  dec	r3, r3
  512=>x"E398",	-- 1110001110011000  baeq	r3, r6
  513=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
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
