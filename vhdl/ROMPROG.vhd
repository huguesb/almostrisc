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
   28=>x"D201",	-- 1101001000000001  sw	r1, r0
   29=>x"FFFE",	-- 1111111111111110  reti
   64=>x"263F",	-- 0010011000111111  not r7, r7
   65=>x"D7C0",	-- 1101011111000000  out	r7
   66=>x"E383",	-- 1110001110000011  ba	-, r6
   80=>x"25FF",	-- 0010010111111111  xor	r7, r7, r7
   81=>x"D7C0",	-- 1101011111000000  out	r7
   82=>x"E383",	-- 1110001110000011  ba	-, r6
   96=>x"FFF2",	-- 1111111111110010  liw	r2, PS2_rx
   97=>x"2004",	-- 0010000000000100  
   98=>x"D012",	-- 1101000000010010  lw	r2, r2
   99=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map + 8
  100=>x"1808",	-- 0001100000001000  
  101=>x"D01B",	-- 1101000000011011  lw	r3, r3
  102=>x"1EBF",	-- 0001111010111111  mixll	r7, r7, r2
  103=>x"C784",	-- 1100011110000100  li	r4, 0xF0
  104=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  105=>x"8B20",	-- 1000101100100000  brieq	r4, int_kbd.release
  106=>x"C704",	-- 1100011100000100  li	r4, 0xE0
  107=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  108=>x"88E0",	-- 1000100011100000  brieq	r4, int_kbd.extended
  109=>x"FFF5",	-- 1111111111110101  liw	r5, paper_keys - 1
  110=>x"16BF",	-- 0001011010111111  
  111=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  112=>x"80E0",	-- 1000000011100000  brieq	r4, $+3
  113=>x"FFF5",	-- 1111111111110101  liw	r5, paper_keys + 11 - 1
  114=>x"16CA",	-- 0001011011001010  
  115=>x"042D",	-- 0000010000101101  inc	r5, r5
  116=>x"D02C",	-- 1101000000101100  lw	r4, r5
  117=>x"8560",	-- 1000010101100000  brieq	r4, scan_code_mismatch
  118=>x"6E24",	-- 0110111000100100  shr	r4, r4, 7
  119=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  120=>x"BEE4",	-- 1011111011100100  brine	r4, scan_code_loop
  121=>x"D02A",	-- 1101000000101010  lw	r2, r5
  122=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  123=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  124=>x"741B",	-- 0111010000011011  shr	r3, r3, 10
  125=>x"C00D",	-- 1100000000001101  li	r5, 1
  126=>x"0612",	-- 0000011000010010  dec	r2, r2
  127=>x"3AAA",	-- 0011101010101010  rrl	r2, r5, r2
  128=>x"FFF5",	-- 1111111111110101  liw	r5, key_press_map
  129=>x"1800",	-- 0001100000000000  
  130=>x"08ED",	-- 0000100011101101  add	r5, r5, r3
  131=>x"D02B",	-- 1101000000101011  lw	r3, r5
  132=>x"80E4",	-- 1000000011100100  brine	r4, scan_code_release
  133=>x"229B",	-- 0010001010011011  or	r3, r3, r2
  134=>x"80C3",	-- 1000000011000011  bri	-, scan_code_notify
  135=>x"2612",	-- 0010011000010010  not	r2, r2
  136=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  137=>x"D22B",	-- 1101001000101011  sw	r3, r5
  138=>x"C003",	-- 1100000000000011  li	r3, 0
  139=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  140=>x"1808",	-- 0001100000001000  
  141=>x"D223",	-- 1101001000100011  sw	r3, r4
  142=>x"E383",	-- 1110001110000011  ba	-, r6
  143=>x"C014",	-- 1100000000010100  li	r4, 2
  144=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  145=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  146=>x"1808",	-- 0001100000001000  
  147=>x"D223",	-- 1101001000100011  sw	r3, r4
  148=>x"E383",	-- 1110001110000011  ba	-, r6
  149=>x"C00C",	-- 1100000000001100  li	r4, 1
  150=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  151=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  152=>x"1808",	-- 0001100000001000  
  153=>x"D223",	-- 1101001000100011  sw	r3, r4
  154=>x"E383",	-- 1110001110000011  ba	-, r6
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
  270=>x"0400",	-- 0000010000000000  inc	r0, r0
  271=>x"C0DA",	-- 1100000011011010  li	r2, 0x1B
  272=>x"D202",	-- 1101001000000010  sw	r2, r0
  273=>x"0400",	-- 0000010000000000  inc	r0, r0
  274=>x"FFF2",	-- 1111111111110010  liw	r2, 817
  275=>x"0331",	-- 0000001100110001  
  276=>x"D202",	-- 1101001000000010  sw	r2, r0
  277=>x"FFF0",	-- 1111111111110000  liw	r0, key_press_map
  278=>x"1800",	-- 0001100000000000  
  279=>x"C001",	-- 1100000000000001  li	r1, 0
  280=>x"C042",	-- 1100000001000010  li	r2, 8
  281=>x"D201",	-- 1101001000000001  sw	r1, r0
  282=>x"0400",	-- 0000010000000000  inc	r0, r0
  283=>x"0612",	-- 0000011000010010  dec	r2, r2
  284=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  285=>x"C0F3",	-- 1100000011110011  li	r3, 30
  286=>x"CFFA",	-- 1100111111111010  li	r2, -1
  287=>x"D21A",	-- 1101001000011010  sw	r2, r3
  288=>x"8083",	-- 1000000010000011  bri	-, PaperGameStart
  289=>x"8003",	-- 1000000000000011  bri	-, PaperMenuLoop
  290=>x"FFF0",	-- 1111111111110000  liw	r0, paper_dir
  291=>x"173C",	-- 0001011100111100  
  292=>x"C001",	-- 1100000000000001  li	r1, 0
  293=>x"D201",	-- 1101001000000001  sw	r1, r0
  294=>x"0400",	-- 0000010000000000  inc	r0, r0
  295=>x"FFF1",	-- 1111111111110001  liw	r1, 152 * 8
  296=>x"04C0",	-- 0000010011000000  
  297=>x"D201",	-- 1101001000000001  sw	r1, r0
  298=>x"0400",	-- 0000010000000000  inc	r0, r0
  299=>x"C001",	-- 1100000000000001  li	r1, 0
  300=>x"D201",	-- 1101001000000001  sw	r1, r0
  301=>x"0400",	-- 0000010000000000  inc	r0, r0
  302=>x"FFF1",	-- 1111111111110001  liw	r1, 128 * 8
  303=>x"0400",	-- 0000010000000000  
  304=>x"D201",	-- 1101001000000001  sw	r1, r0
  305=>x"0400",	-- 0000010000000000  inc	r0, r0
  306=>x"C001",	-- 1100000000000001  li	r1, 0
  307=>x"D201",	-- 1101001000000001  sw	r1, r0
  308=>x"0400",	-- 0000010000000000  inc	r0, r0
  309=>x"C029",	-- 1100000000101001  li	r1, 5
  310=>x"D201",	-- 1101001000000001  sw	r1, r0
  311=>x"0400",	-- 0000010000000000  inc	r0, r0
  312=>x"C011",	-- 1100000000010001  li	r1, 2
  313=>x"D201",	-- 1101001000000001  sw	r1, r0
  314=>x"0400",	-- 0000010000000000  inc	r0, r0
  315=>x"FFF0",	-- 1111111111110000  liw	r0, TMR_cur1
  316=>x"200D",	-- 0010000000001101  
  317=>x"D000",	-- 1101000000000000  lw	r0, r0
  318=>x"FAC6",	-- 1111101011000110  bail	-, r6, rand16_init
  319=>x"020C",	-- 0000001000001100  
  320=>x"C000",	-- 1100000000000000  li	r0, 0
  321=>x"CFF9",	-- 1100111111111001  li	r1, -1
  322=>x"C0A2",	-- 1100000010100010  li	r2, 20
  323=>x"D201",	-- 1101001000000001  sw	r1, r0
  324=>x"0400",	-- 0000010000000000  inc	r0, r0
  325=>x"0612",	-- 0000011000010010  dec	r2, r2
  326=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  327=>x"C001",	-- 1100000000000001  li	r1, 0
  328=>x"FFF2",	-- 1111111111110010  liw	r2, 18*20
  329=>x"0168",	-- 0000000101101000  
  330=>x"D201",	-- 1101001000000001  sw	r1, r0
  331=>x"0400",	-- 0000010000000000  inc	r0, r0
  332=>x"0612",	-- 0000011000010010  dec	r2, r2
  333=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  334=>x"CFF9",	-- 1100111111111001  li	r1, -1
  335=>x"C0A2",	-- 1100000010100010  li	r2, 20
  336=>x"D201",	-- 1101001000000001  sw	r1, r0
  337=>x"0400",	-- 0000010000000000  inc	r0, r0
  338=>x"0612",	-- 0000011000010010  dec	r2, r2
  339=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  340=>x"C020",	-- 1100000000100000  li	r0, 4
  341=>x"C029",	-- 1100000000101001  li	r1, 5
  342=>x"FFF2",	-- 1111111111110010  liw	r2, paper_title
  343=>x"1744",	-- 0001011101000100  
  344=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  345=>x"0276",	-- 0000001001110110  
  346=>x"C778",	-- 1100011101111000  li	r0, 239
  347=>x"C009",	-- 1100000000001001  li	r1, 1
  348=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud
  349=>x"1720",	-- 0001011100100000  
  350=>x"C043",	-- 1100000001000011  li	r3, 8
  351=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  352=>x"0320",	-- 0000001100100000  
  353=>x"C0F8",	-- 1100000011111000  li	r0, 31
  354=>x"C009",	-- 1100000000001001  li	r1, 1
  355=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed + 1
  356=>x"1741",	-- 0001011101000001  
  357=>x"D012",	-- 1101000000010010  lw	r2, r2
  358=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  359=>x"02A5",	-- 0000001010100101  
  360=>x"C120",	-- 1100000100100000  li	r0, 36
  361=>x"C009",	-- 1100000000001001  li	r1, 1
  362=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  363=>x"174A",	-- 0001011101001010  
  364=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  365=>x"0276",	-- 0000001001110110  
  366=>x"C778",	-- 1100011101111000  li	r0, 239
  367=>x"C051",	-- 1100000001010001  li	r1, 10
  368=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud + 4
  369=>x"1724",	-- 0001011100100100  
  370=>x"C043",	-- 1100000001000011  li	r3, 8
  371=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  372=>x"0320",	-- 0000001100100000  
  373=>x"C0F8",	-- 1100000011111000  li	r0, 31
  374=>x"C051",	-- 1100000001010001  li	r1, 10
  375=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed + 2
  376=>x"1742",	-- 0001011101000010  
  377=>x"D012",	-- 1101000000010010  lw	r2, r2
  378=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  379=>x"02A5",	-- 0000001010100101  
  380=>x"C120",	-- 1100000100100000  li	r0, 36
  381=>x"C051",	-- 1100000001010001  li	r1, 10
  382=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  383=>x"174A",	-- 0001011101001010  
  384=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  385=>x"0276",	-- 0000001001110110  
  386=>x"FFF0",	-- 1111111111110000  liw	r0, 20*20
  387=>x"0190",	-- 0000000110010000  
  388=>x"C001",	-- 1100000000000001  li	r1, 0
  389=>x"FFF2",	-- 1111111111110010  liw	r2, 220*20
  390=>x"1130",	-- 0001000100110000  
  391=>x"D201",	-- 1101001000000001  sw	r1, r0
  392=>x"0400",	-- 0000010000000000  inc	r0, r0
  393=>x"0612",	-- 0000011000010010  dec	r2, r2
  394=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  395=>x"FFF5",	-- 1111111111110101  liw	r5, paper_tilemap
  396=>x"1780",	-- 0001011110000000  
  397=>x"D02C",	-- 1101000000101100  lw	r4, r5
  398=>x"042D",	-- 0000010000101101  inc	r5, r5
  399=>x"88E0",	-- 1000100011100000  brieq	r4, PaperGameTileSkip
  400=>x"063F",	-- 0000011000111111  dec	r7, r7
  401=>x"D23D",	-- 1101001000111101  sw	r5, r7
  402=>x"FFF3",	-- 1111111111110011  liw	r3, paper_tilemap
  403=>x"1780",	-- 0001011110000000  
  404=>x"0AEB",	-- 0000101011101011  sub	r3, r5, r3
  405=>x"6E20",	-- 0110111000100000  shr	r0, r4, 7
  406=>x"6219",	-- 0110001000011001  shr	r1, r3, 1
  407=>x"4409",	-- 0100010000001001  shl	r1, r1, 2
  408=>x"C0DA",	-- 1100000011011010  li	r2, 27
  409=>x"0889",	-- 0000100010001001  add	r1, r1, r2
  410=>x"FFF2",	-- 1111111111110010  liw	r2, paper_pos + 1
  411=>x"173E",	-- 0001011100111110  
  412=>x"D012",	-- 1101000000010010  lw	r2, r2
  413=>x"6412",	-- 0110010000010010  shr	r2, r2, 2
  414=>x"C03B",	-- 1100000000111011  li	r3, 7
  415=>x"20D2",	-- 0010000011010010  and	r2, r2, r3
  416=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  417=>x"4E24",	-- 0100111000100100  shl	r4, r4, 7
  418=>x"6E24",	-- 0110111000100100  shr	r4, r4, 7
  419=>x"C00B",	-- 1100000000001011  li	r3, 1
  420=>x"FB06",	-- 1111101100000110  bailne	r0, r6, put_tile
  421=>x"0222",	-- 0000001000100010  
  422=>x"C013",	-- 1100000000010011  li	r3, 2
  423=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_tile
  424=>x"0222",	-- 0000001000100010  
  425=>x"0624",	-- 0000011000100100  dec	r4, r4
  426=>x"BF64",	-- 1011111101100100  brine	r4, PaperGameSegmentLoop
  427=>x"C003",	-- 1100000000000011  li	r3, 0
  428=>x"C144",	-- 1100000101000100  li	r4, 40
  429=>x"0B04",	-- 0000101100000100  sub	r4, r0, r4
  430=>x"FB66",	-- 1111101101100110  baillt	r4, r6, put_tile
  431=>x"0222",	-- 0000001000100010  
  432=>x"D03D",	-- 1101000000111101  lw	r5, r7
  433=>x"043F",	-- 0000010000111111  inc	r7, r7
  434=>x"FFF4",	-- 1111111111110100  liw r4, paper_tilemap + 125
  435=>x"17FD",	-- 0001011111111101  
  436=>x"0B2C",	-- 0000101100101100  sub	r4, r5, r4
  437=>x"B625",	-- 1011011000100101  brilt	r4, PaperGameTileLoop
  438=>x"FFF3",	-- 1111111111110011  liw	r3, paper_speed
  439=>x"1740",	-- 0001011101000000  
  440=>x"D01B",	-- 1101000000011011  lw	r3, r3
  441=>x"CFC4",	-- 1100111111000100  li	r4, 0x1F8
  442=>x"211C",	-- 0010000100011100  and	r4, r3, r4
  443=>x"0924",	-- 0000100100100100  add	r4, r4, r4
  444=>x"FFF3",	-- 1111111111110011  liw	r3, paper_pos
  445=>x"173D",	-- 0001011100111101  
  446=>x"D018",	-- 1101000000011000  lw	r0, r3
  447=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  448=>x"FFF2",	-- 1111111111110010  liw	r2, paper_sprites
  449=>x"16F0",	-- 0001011011110000  
  450=>x"0912",	-- 0000100100010010  add	r2, r2, r4
  451=>x"C161",	-- 1100000101100001  li	r1, 44
  452=>x"C083",	-- 1100000010000011  li	r3, 16
  453=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_16
  454=>x"02D4",	-- 0000001011010100  
  455=>x"C028",	-- 1100000000101000  li	r0, 5
  456=>x"C001",	-- 1100000000000001  li	r1, 0
  457=>x"8043",	-- 1000000001000011  bri	-, $+1
  458=>x"8043",	-- 1000000001000011  bri	-, $+1
  459=>x"0609",	-- 0000011000001001  dec	r1, r1
  460=>x"BF4C",	-- 1011111101001100  brine	r1, $-3
  461=>x"0600",	-- 0000011000000000  dec	r0, r0
  462=>x"BE84",	-- 1011111010000100  brine	r0, $-6
  463=>x"FFF2",	-- 1111111111110010  liw	r2, paper_pos
  464=>x"173D",	-- 0001011100111101  
  465=>x"FFF3",	-- 1111111111110011  liw	r3, paper_speed
  466=>x"1740",	-- 0001011101000000  
  467=>x"D010",	-- 1101000000010000  lw	r0, r2
  468=>x"D019",	-- 1101000000011001  lw	r1, r3
  469=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  470=>x"D210",	-- 1101001000010000  sw	r0, r2
  471=>x"0412",	-- 0000010000010010  inc	r2, r2
  472=>x"041B",	-- 0000010000011011  inc	r3, r3
  473=>x"D010",	-- 1101000000010000  lw	r0, r2
  474=>x"D019",	-- 1101000000011001  lw	r1, r3
  475=>x"C1FC",	-- 1100000111111100  li	r4, 0x3F
  476=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  477=>x"2101",	-- 0010000100000001  and	r1, r0, r4
  478=>x"2624",	-- 0010011000100100  not	r4, r4
  479=>x"2100",	-- 0010000100000000  and	r0, r0, r4
  480=>x"D211",	-- 1101001000010001  sw	r1, r2
  481=>x"83C0",	-- 1000001111000000  brieq	r0, PaperGameSkipScroll
  482=>x"FFF0",	-- 1111111111110000  liw	r0, paper_tilemap
  483=>x"1780",	-- 0001011110000000  
  484=>x"C021",	-- 1100000000100001  li	r1, 4
  485=>x"0841",	-- 0000100001000001  add	r1, r0, r1
  486=>x"C302",	-- 1100001100000010  li	r2, 24*4
  487=>x"D00B",	-- 1101000000001011  lw	r3, r1
  488=>x"D203",	-- 1101001000000011  sw	r3, r0
  489=>x"0400",	-- 0000010000000000  inc	r0, r0
  490=>x"0409",	-- 0000010000001001  inc	r1, r1
  491=>x"0612",	-- 0000011000010010  dec	r2, r2
  492=>x"BED4",	-- 1011111011010100  brine	r2, PaperGameScrollLoop
  493=>x"C111",	-- 1100000100010001  li	r1, 34
  494=>x"D201",	-- 1101001000000001  sw	r1, r0
  495=>x"0400",	-- 0000010000000000  inc	r0, r0
  496=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map
  497=>x"1800",	-- 0001100000000000  
  498=>x"D01B",	-- 1101000000011011  lw	r3, r3
  499=>x"F818",	-- 1111100000011000  baieq	r3, PaperGameRedrawContent
  500=>x"0182",	-- 0000000110000010  
  501=>x"F7DC",	-- 1111011111011100  bspl	r4, r3, 15
  502=>x"8564",	-- 1000010101100100  brine	r4, PaperGameQuit
  503=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  504=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveUp
  505=>x"F49C",	-- 1111010010011100  bspl	r4, r3, 2
  506=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveDOWN
  507=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  508=>x"81A0",	-- 1000000110100000  brieq	r4, PaperNoMoveLEFT
  509=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed
  510=>x"1740",	-- 0001011101000000  
  511=>x"D010",	-- 1101000000010000  lw	r0, r2
  512=>x"0600",	-- 0000011000000000  dec	r0, r0
  513=>x"D210",	-- 1101001000010000  sw	r0, r2
  514=>x"F4DC",	-- 1111010011011100  bspl	r4, r3, 3
  515=>x"81A0",	-- 1000000110100000  brieq	r4, PaperNoMoveRIGHT
  516=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed
  517=>x"1740",	-- 0001011101000000  
  518=>x"D010",	-- 1101000000010000  lw	r0, r2
  519=>x"0400",	-- 0000010000000000  inc	r0, r0
  520=>x"D210",	-- 1101001000010000  sw	r0, r2
  521=>x"F8C0",	-- 1111100011000000  bai	-, PaperGameRedrawContent
  522=>x"0182",	-- 0000000110000010  
  523=>x"FFFF",	-- 1111111111111111  reset
  524=>x"FFF2",	-- 1111111111110010  liw	r2, rand_seed
  525=>x"1808",	-- 0001100000001000  
  526=>x"D210",	-- 1101001000010000  sw	r0, r2
  527=>x"E383",	-- 1110001110000011  ba	-, r6
  528=>x"FFF2",	-- 1111111111110010  liw	r2, rand_seed
  529=>x"1808",	-- 0001100000001000  
  530=>x"D013",	-- 1101000000010011  lw	r3, r2
  531=>x"C7EC",	-- 1100011111101100  li	r4, 253
  532=>x"1F19",	-- 0001111100011001  mixll	r1, r3, r4
  533=>x"18E4",	-- 0001100011100100  mixhh	r4, r4, r3
  534=>x"C002",	-- 1100000000000010  li	r2, 0
  535=>x"0AC9",	-- 0000101011001001  sub	r1, r1, r3
  536=>x"0EA4",	-- 0000111010100100  sbc	r4, r4, r2
  537=>x"0EC9",	-- 0000111011001001  sbc	r1, r1, r3
  538=>x"0EA4",	-- 0000111010100100  sbc	r4, r4, r2
  539=>x"1B13",	-- 0001101100010011  mixhl	r3, r2, r4
  540=>x"0EC9",	-- 0000111011001001  sbc	r1, r1, r3
  541=>x"0C89",	-- 0000110010001001  adc	r1, r1, r2
  542=>x"FFF2",	-- 1111111111110010  liw	r2, rand_seed
  543=>x"1808",	-- 0001100000001000  
  544=>x"D211",	-- 1101001000010001  sw	r1, r2
  545=>x"E383",	-- 1110001110000011  ba	-, r6
  546=>x"063F",	-- 0000011000111111  dec	r7, r7
  547=>x"D238",	-- 1101001000111000  sw	r0, r7
  548=>x"063F",	-- 0000011000111111  dec	r7, r7
  549=>x"D239",	-- 1101001000111001  sw	r1, r7
  550=>x"063F",	-- 0000011000111111  dec	r7, r7
  551=>x"D23A",	-- 1101001000111010  sw	r2, r7
  552=>x"063F",	-- 0000011000111111  dec	r7, r7
  553=>x"D23B",	-- 1101001000111011  sw	r3, r7
  554=>x"063F",	-- 0000011000111111  dec	r7, r7
  555=>x"D23C",	-- 1101001000111100  sw	r4, r7
  556=>x"063F",	-- 0000011000111111  dec	r7, r7
  557=>x"D23D",	-- 1101001000111101  sw	r5, r7
  558=>x"063F",	-- 0000011000111111  dec	r7, r7
  559=>x"D23E",	-- 1101001000111110  sw	r6, r7
  560=>x"FFF2",	-- 1111111111110010  liw	r2, paper_tiles
  561=>x"1730",	-- 0001011100110000  
  562=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  563=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  564=>x"C043",	-- 1100000001000011  li	r3, 8
  565=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  566=>x"02FA",	-- 0000001011111010  
  567=>x"D03E",	-- 1101000000111110  lw	r6, r7
  568=>x"043F",	-- 0000010000111111  inc	r7, r7
  569=>x"D03D",	-- 1101000000111101  lw	r5, r7
  570=>x"043F",	-- 0000010000111111  inc	r7, r7
  571=>x"D03C",	-- 1101000000111100  lw	r4, r7
  572=>x"043F",	-- 0000010000111111  inc	r7, r7
  573=>x"D03B",	-- 1101000000111011  lw	r3, r7
  574=>x"043F",	-- 0000010000111111  inc	r7, r7
  575=>x"D03A",	-- 1101000000111010  lw	r2, r7
  576=>x"043F",	-- 0000010000111111  inc	r7, r7
  577=>x"D039",	-- 1101000000111001  lw	r1, r7
  578=>x"043F",	-- 0000010000111111  inc	r7, r7
  579=>x"D038",	-- 1101000000111000  lw	r0, r7
  580=>x"043F",	-- 0000010000111111  inc	r7, r7
  581=>x"0400",	-- 0000010000000000  inc	r0, r0
  582=>x"E383",	-- 1110001110000011  ba	-, r6
  583=>x"C750",	-- 1100011101010000  li	r0, 234
  584=>x"C1C2",	-- 1100000111000010  li	r2, 56
  585=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  586=>x"025F",	-- 0000001001011111  
  587=>x"C448",	-- 1100010001001000  li	r0, 137
  588=>x"C472",	-- 1100010001110010  li	r2, 142
  589=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  590=>x"0253",	-- 0000001001010011  
  591=>x"C03A",	-- 1100000000111010  li r2, 7
  592=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  593=>x"026A",	-- 0000001001101010  
  594=>x"FFFF",	-- 1111111111111111  reset
  595=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  596=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  597=>x"C085",	-- 1100000010000101  li	r5, 16
  598=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  599=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  600=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  601=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  602=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  603=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  604=>x"062D",	-- 0000011000101101  dec	r5, r5
  605=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  606=>x"E383",	-- 1110001110000011  ba	-, r6
  607=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  608=>x"C084",	-- 1100000010000100  li	r4, 16
  609=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  610=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  611=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  612=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  613=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  614=>x"0400",	-- 0000010000000000  inc	r0, r0
  615=>x"0624",	-- 0000011000100100  dec	r4, r4
  616=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  617=>x"E383",	-- 1110001110000011  ba	-, r6
  618=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  619=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  620=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  621=>x"0409",	-- 0000010000001001  inc	r1, r1
  622=>x"1008",	-- 0001000000001000  mova	r0, r1
  623=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  624=>x"0253",	-- 0000001001010011  
  625=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  626=>x"0253",	-- 0000001001010011  
  627=>x"0612",	-- 0000011000010010  dec	r2, r2
  628=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  629=>x"E383",	-- 1110001110000011  ba	-, r6
  630=>x"063F",	-- 0000011000111111  dec	r7, r7
  631=>x"D23E",	-- 1101001000111110  sw	r6, r7
  632=>x"D013",	-- 1101000000010011  lw	r3, r2
  633=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  634=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  635=>x"063F",	-- 0000011000111111  dec	r7, r7
  636=>x"D23A",	-- 1101001000111010  sw	r2, r7
  637=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  638=>x"0290",	-- 0000001010010000  
  639=>x"D03A",	-- 1101000000111010  lw	r2, r7
  640=>x"043F",	-- 0000010000111111  inc	r7, r7
  641=>x"D013",	-- 1101000000010011  lw	r3, r2
  642=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  643=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  644=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  645=>x"063F",	-- 0000011000111111  dec	r7, r7
  646=>x"D23A",	-- 1101001000111010  sw	r2, r7
  647=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  648=>x"0290",	-- 0000001010010000  
  649=>x"D03A",	-- 1101000000111010  lw	r2, r7
  650=>x"043F",	-- 0000010000111111  inc	r7, r7
  651=>x"0412",	-- 0000010000010010  inc	r2, r2
  652=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  653=>x"D03E",	-- 1101000000111110  lw	r6, r7
  654=>x"043F",	-- 0000010000111111  inc	r7, r7
  655=>x"E383",	-- 1110001110000011  ba	-, r6
  656=>x"063F",	-- 0000011000111111  dec	r7, r7
  657=>x"D23E",	-- 1101001000111110  sw	r6, r7
  658=>x"063F",	-- 0000011000111111  dec	r7, r7
  659=>x"D238",	-- 1101001000111000  sw	r0, r7
  660=>x"063F",	-- 0000011000111111  dec	r7, r7
  661=>x"D239",	-- 1101001000111001  sw	r1, r7
  662=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  663=>x"12C0",	-- 0001001011000000  
  664=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  665=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  666=>x"C043",	-- 1100000001000011  li	r3, 8
  667=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  668=>x"02FA",	-- 0000001011111010  
  669=>x"D039",	-- 1101000000111001  lw	r1, r7
  670=>x"043F",	-- 0000010000111111  inc	r7, r7
  671=>x"D038",	-- 1101000000111000  lw	r0, r7
  672=>x"043F",	-- 0000010000111111  inc	r7, r7
  673=>x"0400",	-- 0000010000000000  inc	r0, r0
  674=>x"D03E",	-- 1101000000111110  lw	r6, r7
  675=>x"043F",	-- 0000010000111111  inc	r7, r7
  676=>x"E383",	-- 1110001110000011  ba	-, r6
  677=>x"063F",	-- 0000011000111111  dec	r7, r7
  678=>x"D23E",	-- 1101001000111110  sw	r6, r7
  679=>x"FFF4",	-- 1111111111110100  liw	r4, 10000
  680=>x"2710",	-- 0010011100010000  
  681=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  682=>x"02B8",	-- 0000001010111000  
  683=>x"FFF4",	-- 1111111111110100  liw	r4, 1000
  684=>x"03E8",	-- 0000001111101000  
  685=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  686=>x"02B8",	-- 0000001010111000  
  687=>x"C324",	-- 1100001100100100  li	r4, 100
  688=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  689=>x"02B8",	-- 0000001010111000  
  690=>x"C054",	-- 1100000001010100  li	r4, 10
  691=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  692=>x"02B8",	-- 0000001010111000  
  693=>x"D03E",	-- 1101000000111110  lw	r6, r7
  694=>x"043F",	-- 0000010000111111  inc	r7, r7
  695=>x"C00C",	-- 1100000000001100  li	r4, 1
  696=>x"C17B",	-- 1100000101111011  li	r3, 0x2F
  697=>x"041B",	-- 0000010000011011  inc	r3, r3
  698=>x"0B12",	-- 0000101100010010  sub	r2, r2, r4
  699=>x"BF91",	-- 1011111110010001  brige	r2, printnum.loop
  700=>x"0912",	-- 0000100100010010  add	r2, r2, r4
  701=>x"063F",	-- 0000011000111111  dec	r7, r7
  702=>x"D23E",	-- 1101001000111110  sw	r6, r7
  703=>x"063F",	-- 0000011000111111  dec	r7, r7
  704=>x"D23A",	-- 1101001000111010  sw	r2, r7
  705=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  706=>x"0290",	-- 0000001010010000  
  707=>x"D03A",	-- 1101000000111010  lw	r2, r7
  708=>x"043F",	-- 0000010000111111  inc	r7, r7
  709=>x"D03E",	-- 1101000000111110  lw	r6, r7
  710=>x"043F",	-- 0000010000111111  inc	r7, r7
  711=>x"E383",	-- 1110001110000011  ba	-, r6
  712=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  713=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  714=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  715=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  716=>x"C0A0",	-- 1100000010100000  li	r0, 20
  717=>x"D011",	-- 1101000000010001  lw	r1, r2
  718=>x"D221",	-- 1101001000100001  sw	r1, r4
  719=>x"0412",	-- 0000010000010010  inc	r2, r2
  720=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  721=>x"061B",	-- 0000011000011011  dec	r3, r3
  722=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  723=>x"E383",	-- 1110001110000011  ba	-, r6
  724=>x"C07D",	-- 1100000001111101  li	r5, 15
  725=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  726=>x"6600",	-- 0110011000000000  shr	r0, r0, 3
  727=>x"BC68",	-- 1011110001101000  brieq	r5, put_sprite_16_aligned
  728=>x"062D",	-- 0000011000101101  dec	r5, r5
  729=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  730=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  731=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  732=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  733=>x"063F",	-- 0000011000111111  dec	r7, r7
  734=>x"D23B",	-- 1101001000111011  sw	r3, r7
  735=>x"D011",	-- 1101000000010001  lw	r1, r2
  736=>x"CFF8",	-- 1100111111111000  li	r0, -1
  737=>x"3D40",	-- 0011110101000000  rsr	r0, r0, r5
  738=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  739=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  740=>x"D023",	-- 1101000000100011  lw	r3, r4
  741=>x"2600",	-- 0010011000000000  not	r0, r0
  742=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  743=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  744=>x"D221",	-- 1101001000100001  sw	r1, r4
  745=>x"0424",	-- 0000010000100100  inc	r4, r4
  746=>x"D011",	-- 1101000000010001  lw	r1, r2
  747=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  748=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  749=>x"D023",	-- 1101000000100011  lw	r3, r4
  750=>x"2600",	-- 0010011000000000  not	r0, r0
  751=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  752=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  753=>x"D221",	-- 1101001000100001  sw	r1, r4
  754=>x"0412",	-- 0000010000010010  inc	r2, r2
  755=>x"C098",	-- 1100000010011000  li	r0, 19
  756=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  757=>x"D03B",	-- 1101000000111011  lw	r3, r7
  758=>x"043F",	-- 0000010000111111  inc	r7, r7
  759=>x"061B",	-- 0000011000011011  dec	r3, r3
  760=>x"B95C",	-- 1011100101011100  brine	r3, put_sprite_16.loop
  761=>x"E383",	-- 1110001110000011  ba	-, r6
  762=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  763=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  764=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  765=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  766=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  767=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  768=>x"C0A5",	-- 1100000010100101  li	r5, 20
  769=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  770=>x"D010",	-- 1101000000010000  lw	r0, r2
  771=>x"D021",	-- 1101000000100001  lw	r1, r4
  772=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  773=>x"D221",	-- 1101001000100001  sw	r1, r4
  774=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  775=>x"061B",	-- 0000011000011011  dec	r3, r3
  776=>x"E398",	-- 1110001110011000  baeq	r3, r6
  777=>x"D021",	-- 1101000000100001  lw	r1, r4
  778=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  779=>x"D221",	-- 1101001000100001  sw	r1, r4
  780=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  781=>x"0412",	-- 0000010000010010  inc	r2, r2
  782=>x"061B",	-- 0000011000011011  dec	r3, r3
  783=>x"E398",	-- 1110001110011000  baeq	r3, r6
  784=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  785=>x"D010",	-- 1101000000010000  lw	r0, r2
  786=>x"D021",	-- 1101000000100001  lw	r1, r4
  787=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  788=>x"D221",	-- 1101001000100001  sw	r1, r4
  789=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  790=>x"061B",	-- 0000011000011011  dec	r3, r3
  791=>x"E398",	-- 1110001110011000  baeq	r3, r6
  792=>x"D021",	-- 1101000000100001  lw	r1, r4
  793=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  794=>x"D221",	-- 1101001000100001  sw	r1, r4
  795=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  796=>x"0412",	-- 0000010000010010  inc	r2, r2
  797=>x"061B",	-- 0000011000011011  dec	r3, r3
  798=>x"E398",	-- 1110001110011000  baeq	r3, r6
  799=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
  800=>x"C03D",	-- 1100000000111101  li	r5, 7
  801=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  802=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  803=>x"B5E8",	-- 1011010111101000  brieq	r5, put_sprite_8_aligned
  804=>x"062D",	-- 0000011000101101  dec	r5, r5
  805=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  806=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  807=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  808=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  809=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  810=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  811=>x"8A04",	-- 1000101000000100  brine	r0, put_sprite_8.loop1
  812=>x"D010",	-- 1101000000010000  lw	r0, r2
  813=>x"063F",	-- 0000011000111111  dec	r7, r7
  814=>x"D23A",	-- 1101001000111010  sw	r2, r7
  815=>x"C802",	-- 1100100000000010  li	r2, 0x100
  816=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  817=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  818=>x"D021",	-- 1101000000100001  lw	r1, r4
  819=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  820=>x"2612",	-- 0010011000010010  not	r2, r2
  821=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  822=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  823=>x"D221",	-- 1101001000100001  sw	r1, r4
  824=>x"C0A1",	-- 1100000010100001  li	r1, 20
  825=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  826=>x"D03A",	-- 1101000000111010  lw	r2, r7
  827=>x"043F",	-- 0000010000111111  inc	r7, r7
  828=>x"061B",	-- 0000011000011011  dec	r3, r3
  829=>x"E398",	-- 1110001110011000  baeq	r3, r6
  830=>x"D010",	-- 1101000000010000  lw	r0, r2
  831=>x"063F",	-- 0000011000111111  dec	r7, r7
  832=>x"D23A",	-- 1101001000111010  sw	r2, r7
  833=>x"1E00",	-- 0001111000000000  mixll	r0, r0, r0
  834=>x"C802",	-- 1100100000000010  li	r2, 0x100
  835=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  836=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  837=>x"D021",	-- 1101000000100001  lw	r1, r4
  838=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  839=>x"2612",	-- 0010011000010010  not	r2, r2
  840=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  841=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  842=>x"D221",	-- 1101001000100001  sw	r1, r4
  843=>x"C0A1",	-- 1100000010100001  li	r1, 20
  844=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  845=>x"D03A",	-- 1101000000111010  lw	r2, r7
  846=>x"043F",	-- 0000010000111111  inc	r7, r7
  847=>x"0412",	-- 0000010000010010  inc	r2, r2
  848=>x"061B",	-- 0000011000011011  dec	r3, r3
  849=>x"E398",	-- 1110001110011000  baeq	r3, r6
  850=>x"B683",	-- 1011011010000011  bri	-, put_sprite_8.loop0
  851=>x"D010",	-- 1101000000010000  lw	r0, r2
  852=>x"063F",	-- 0000011000111111  dec	r7, r7
  853=>x"D23A",	-- 1101001000111010  sw	r2, r7
  854=>x"063F",	-- 0000011000111111  dec	r7, r7
  855=>x"D23B",	-- 1101001000111011  sw	r3, r7
  856=>x"C802",	-- 1100100000000010  li	r2, 0x100
  857=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  858=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  859=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  860=>x"D021",	-- 1101000000100001  lw	r1, r4
  861=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  862=>x"261B",	-- 0010011000011011  not	r3, r3
  863=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  864=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  865=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  866=>x"D221",	-- 1101001000100001  sw	r1, r4
  867=>x"0424",	-- 0000010000100100  inc	r4, r4
  868=>x"D021",	-- 1101000000100001  lw	r1, r4
  869=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  870=>x"261B",	-- 0010011000011011  not	r3, r3
  871=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  872=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  873=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  874=>x"D221",	-- 1101001000100001  sw	r1, r4
  875=>x"C099",	-- 1100000010011001  li	r1, 19
  876=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  877=>x"D03B",	-- 1101000000111011  lw	r3, r7
  878=>x"043F",	-- 0000010000111111  inc	r7, r7
  879=>x"D03A",	-- 1101000000111010  lw	r2, r7
  880=>x"043F",	-- 0000010000111111  inc	r7, r7
  881=>x"061B",	-- 0000011000011011  dec	r3, r3
  882=>x"E398",	-- 1110001110011000  baeq	r3, r6
  883=>x"D010",	-- 1101000000010000  lw	r0, r2
  884=>x"4E00",	-- 0100111000000000  shl	r0, r0, 7
  885=>x"063F",	-- 0000011000111111  dec	r7, r7
  886=>x"D23A",	-- 1101001000111010  sw	r2, r7
  887=>x"063F",	-- 0000011000111111  dec	r7, r7
  888=>x"D23B",	-- 1101001000111011  sw	r3, r7
  889=>x"C802",	-- 1100100000000010  li	r2, 0x100
  890=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  891=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  892=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  893=>x"D021",	-- 1101000000100001  lw	r1, r4
  894=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  895=>x"261B",	-- 0010011000011011  not	r3, r3
  896=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  897=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  898=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  899=>x"D221",	-- 1101001000100001  sw	r1, r4
  900=>x"0424",	-- 0000010000100100  inc	r4, r4
  901=>x"D021",	-- 1101000000100001  lw	r1, r4
  902=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  903=>x"261B",	-- 0010011000011011  not	r3, r3
  904=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  905=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  906=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  907=>x"D221",	-- 1101001000100001  sw	r1, r4
  908=>x"C099",	-- 1100000010011001  li	r1, 19
  909=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  910=>x"D03B",	-- 1101000000111011  lw	r3, r7
  911=>x"043F",	-- 0000010000111111  inc	r7, r7
  912=>x"D03A",	-- 1101000000111010  lw	r2, r7
  913=>x"043F",	-- 0000010000111111  inc	r7, r7
  914=>x"0412",	-- 0000010000010010  inc	r2, r2
  915=>x"061B",	-- 0000011000011011  dec	r3, r3
  916=>x"E398",	-- 1110001110011000  baeq	r3, r6
  917=>x"AF83",	-- 1010111110000011  bri	-, put_sprite_8.loop1
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
