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
  270=>x"FFF0",	-- 1111111111110000  liw	r0, key_press_map
  271=>x"1800",	-- 0001100000000000  
  272=>x"C001",	-- 1100000000000001  li	r1, 0
  273=>x"C042",	-- 1100000001000010  li	r2, 8
  274=>x"D201",	-- 1101001000000001  sw	r1, r0
  275=>x"0400",	-- 0000010000000000  inc	r0, r0
  276=>x"0612",	-- 0000011000010010  dec	r2, r2
  277=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  278=>x"C0F3",	-- 1100000011110011  li	r3, 30
  279=>x"CFFA",	-- 1100111111111010  li	r2, -1
  280=>x"D21A",	-- 1101001000011010  sw	r2, r3
  281=>x"8083",	-- 1000000010000011  bri	-, PaperGameStart
  282=>x"8003",	-- 1000000000000011  bri	-, PaperMenuLoop
  283=>x"FFF0",	-- 1111111111110000  liw	r0, paper_dir
  284=>x"173C",	-- 0001011100111100  
  285=>x"C001",	-- 1100000000000001  li	r1, 0
  286=>x"D201",	-- 1101001000000001  sw	r1, r0
  287=>x"0400",	-- 0000010000000000  inc	r0, r0
  288=>x"C4C1",	-- 1100010011000001  li	r1, 152
  289=>x"D201",	-- 1101001000000001  sw	r1, r0
  290=>x"0400",	-- 0000010000000000  inc	r0, r0
  291=>x"C001",	-- 1100000000000001  li	r1, 0
  292=>x"D201",	-- 1101001000000001  sw	r1, r0
  293=>x"0400",	-- 0000010000000000  inc	r0, r0
  294=>x"C401",	-- 1100010000000001  li	r1, 128
  295=>x"D201",	-- 1101001000000001  sw	r1, r0
  296=>x"0400",	-- 0000010000000000  inc	r0, r0
  297=>x"C001",	-- 1100000000000001  li	r1, 0
  298=>x"D201",	-- 1101001000000001  sw	r1, r0
  299=>x"0400",	-- 0000010000000000  inc	r0, r0
  300=>x"C011",	-- 1100000000010001  li	r1, 2
  301=>x"D201",	-- 1101001000000001  sw	r1, r0
  302=>x"0400",	-- 0000010000000000  inc	r0, r0
  303=>x"C011",	-- 1100000000010001  li	r1, 2
  304=>x"D201",	-- 1101001000000001  sw	r1, r0
  305=>x"0400",	-- 0000010000000000  inc	r0, r0
  306=>x"C000",	-- 1100000000000000  li	r0, 0
  307=>x"CFF9",	-- 1100111111111001  li	r1, -1
  308=>x"C0A2",	-- 1100000010100010  li	r2, 20
  309=>x"D201",	-- 1101001000000001  sw	r1, r0
  310=>x"0400",	-- 0000010000000000  inc	r0, r0
  311=>x"0612",	-- 0000011000010010  dec	r2, r2
  312=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  313=>x"C001",	-- 1100000000000001  li	r1, 0
  314=>x"FFF2",	-- 1111111111110010  liw	r2, 18*20
  315=>x"0168",	-- 0000000101101000  
  316=>x"D201",	-- 1101001000000001  sw	r1, r0
  317=>x"0400",	-- 0000010000000000  inc	r0, r0
  318=>x"0612",	-- 0000011000010010  dec	r2, r2
  319=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  320=>x"CFF9",	-- 1100111111111001  li	r1, -1
  321=>x"C0A2",	-- 1100000010100010  li	r2, 20
  322=>x"D201",	-- 1101001000000001  sw	r1, r0
  323=>x"0400",	-- 0000010000000000  inc	r0, r0
  324=>x"0612",	-- 0000011000010010  dec	r2, r2
  325=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  326=>x"C020",	-- 1100000000100000  li	r0, 4
  327=>x"C029",	-- 1100000000101001  li	r1, 5
  328=>x"FFF2",	-- 1111111111110010  liw	r2, paper_title
  329=>x"1744",	-- 0001011101000100  
  330=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  331=>x"022F",	-- 0000001000101111  
  332=>x"C778",	-- 1100011101111000  li	r0, 239
  333=>x"C009",	-- 1100000000001001  li	r1, 1
  334=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud
  335=>x"1720",	-- 0001011100100000  
  336=>x"C043",	-- 1100000001000011  li	r3, 8
  337=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  338=>x"02D9",	-- 0000001011011001  
  339=>x"C0F8",	-- 1100000011111000  li	r0, 31
  340=>x"C009",	-- 1100000000001001  li	r1, 1
  341=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed + 1
  342=>x"173E",	-- 0001011100111110  
  343=>x"D012",	-- 1101000000010010  lw	r2, r2
  344=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  345=>x"025E",	-- 0000001001011110  
  346=>x"C120",	-- 1100000100100000  li	r0, 36
  347=>x"C009",	-- 1100000000001001  li	r1, 1
  348=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  349=>x"174A",	-- 0001011101001010  
  350=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  351=>x"022F",	-- 0000001000101111  
  352=>x"C778",	-- 1100011101111000  li	r0, 239
  353=>x"C051",	-- 1100000001010001  li	r1, 10
  354=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud + 4
  355=>x"1724",	-- 0001011100100100  
  356=>x"C043",	-- 1100000001000011  li	r3, 8
  357=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  358=>x"02D9",	-- 0000001011011001  
  359=>x"C0F8",	-- 1100000011111000  li	r0, 31
  360=>x"C051",	-- 1100000001010001  li	r1, 10
  361=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed + 2
  362=>x"173F",	-- 0001011100111111  
  363=>x"D012",	-- 1101000000010010  lw	r2, r2
  364=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  365=>x"025E",	-- 0000001001011110  
  366=>x"C120",	-- 1100000100100000  li	r0, 36
  367=>x"C051",	-- 1100000001010001  li	r1, 10
  368=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  369=>x"174A",	-- 0001011101001010  
  370=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  371=>x"022F",	-- 0000001000101111  
  372=>x"FFF0",	-- 1111111111110000  liw	r0, 20*20
  373=>x"0190",	-- 0000000110010000  
  374=>x"C001",	-- 1100000000000001  li	r1, 0
  375=>x"FFF2",	-- 1111111111110010  liw	r2, 220*20
  376=>x"1130",	-- 0001000100110000  
  377=>x"D201",	-- 1101001000000001  sw	r1, r0
  378=>x"0400",	-- 0000010000000000  inc	r0, r0
  379=>x"0612",	-- 0000011000010010  dec	r2, r2
  380=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  381=>x"FFF5",	-- 1111111111110101  liw	r5, paper_tilemap
  382=>x"1780",	-- 0001011110000000  
  383=>x"D02C",	-- 1101000000101100  lw	r4, r5
  384=>x"042D",	-- 0000010000101101  inc	r5, r5
  385=>x"8720",	-- 1000011100100000  brieq	r4, PaperGameTileSkip
  386=>x"063F",	-- 0000011000111111  dec	r7, r7
  387=>x"D23D",	-- 1101001000111101  sw	r5, r7
  388=>x"FFF3",	-- 1111111111110011  liw	r3, paper_tilemap
  389=>x"1780",	-- 0001011110000000  
  390=>x"0AEB",	-- 0000101011101011  sub	r3, r5, r3
  391=>x"6E20",	-- 0110111000100000  shr	r0, r4, 7
  392=>x"6219",	-- 0110001000011001  shr	r1, r3, 1
  393=>x"4409",	-- 0100010000001001  shl	r1, r1, 2
  394=>x"FFF2",	-- 1111111111110010  liw	r2, paper_pos + 1
  395=>x"1741",	-- 0001011101000001  
  396=>x"D012",	-- 1101000000010010  lw	r2, r2
  397=>x"6412",	-- 0110010000010010  shr	r2, r2, 2
  398=>x"C03B",	-- 1100000000111011  li	r3, 7
  399=>x"20D2",	-- 0010000011010010  and	r2, r2, r3
  400=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  401=>x"4E24",	-- 0100111000100100  shl	r4, r4, 7
  402=>x"6E24",	-- 0110111000100100  shr	r4, r4, 7
  403=>x"C00B",	-- 1100000000001011  li	r3, 1
  404=>x"FB06",	-- 1111101100000110  bailne	r0, r6, put_tile
  405=>x"01DB",	-- 0000000111011011  
  406=>x"C013",	-- 1100000000010011  li	r3, 2
  407=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_tile
  408=>x"01DB",	-- 0000000111011011  
  409=>x"0624",	-- 0000011000100100  dec	r4, r4
  410=>x"BF64",	-- 1011111101100100  brine	r4, PaperGameSegmentLoop
  411=>x"D03D",	-- 1101000000111101  lw	r5, r7
  412=>x"043F",	-- 0000010000111111  inc	r7, r7
  413=>x"FFF4",	-- 1111111111110100  liw r4, paper_tilemap + 125
  414=>x"17FD",	-- 0001011111111101  
  415=>x"0B2C",	-- 0000101100101100  sub	r4, r5, r4
  416=>x"B7E5",	-- 1011011111100101  brilt	r4, PaperGameTileLoop
  417=>x"FFF3",	-- 1111111111110011  liw	r3, paper_speed
  418=>x"173D",	-- 0001011100111101  
  419=>x"D01C",	-- 1101000000011100  lw	r4, r3
  420=>x"6424",	-- 0110010000100100  shr	r4, r4, 2
  421=>x"FFF3",	-- 1111111111110011  liw	r3, paper_pos
  422=>x"1740",	-- 0001011101000000  
  423=>x"D018",	-- 1101000000011000  lw	r0, r3
  424=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  425=>x"FFF2",	-- 1111111111110010  liw	r2, paper_sprites
  426=>x"16F0",	-- 0001011011110000  
  427=>x"C161",	-- 1100000101100001  li	r1, 44
  428=>x"C083",	-- 1100000010000011  li	r3, 16
  429=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_16
  430=>x"028D",	-- 0000001010001101  
  431=>x"C030",	-- 1100000000110000  li	r0, 6
  432=>x"C001",	-- 1100000000000001  li	r1, 0
  433=>x"8043",	-- 1000000001000011  bri	-, $+1
  434=>x"8043",	-- 1000000001000011  bri	-, $+1
  435=>x"0609",	-- 0000011000001001  dec	r1, r1
  436=>x"BF4C",	-- 1011111101001100  brine	r1, $-3
  437=>x"0600",	-- 0000011000000000  dec	r0, r0
  438=>x"BE84",	-- 1011111010000100  brine	r0, $-6
  439=>x"FFF2",	-- 1111111111110010  liw	r2, paper_pos
  440=>x"1740",	-- 0001011101000000  
  441=>x"FFF3",	-- 1111111111110011  liw	r3, paper_speed
  442=>x"173D",	-- 0001011100111101  
  443=>x"0412",	-- 0000010000010010  inc	r2, r2
  444=>x"041B",	-- 0000010000011011  inc	r3, r3
  445=>x"D010",	-- 1101000000010000  lw	r0, r2
  446=>x"D019",	-- 1101000000011001  lw	r1, r3
  447=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  448=>x"D210",	-- 1101001000010000  sw	r0, r2
  449=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map
  450=>x"1800",	-- 0001100000000000  
  451=>x"D01B",	-- 1101000000011011  lw	r3, r3
  452=>x"AC18",	-- 1010110000011000  brieq	r3, PaperGameRedrawContent
  453=>x"F7DC",	-- 1111011111011100  bspl	r4, r3, 15
  454=>x"8524",	-- 1000010100100100  brine	r4, PaperGameQuit
  455=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  456=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveUp
  457=>x"F49C",	-- 1111010010011100  bspl	r4, r3, 2
  458=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveDOWN
  459=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  460=>x"81A0",	-- 1000000110100000  brieq	r4, PaperNoMoveLEFT
  461=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed
  462=>x"173D",	-- 0001011100111101  
  463=>x"D010",	-- 1101000000010000  lw	r0, r2
  464=>x"0600",	-- 0000011000000000  dec	r0, r0
  465=>x"D210",	-- 1101001000010000  sw	r0, r2
  466=>x"F4DC",	-- 1111010011011100  bspl	r4, r3, 3
  467=>x"81A0",	-- 1000000110100000  brieq	r4, PaperNoMoveRIGHT
  468=>x"FFF2",	-- 1111111111110010  liw	r2, paper_speed
  469=>x"173D",	-- 0001011100111101  
  470=>x"D010",	-- 1101000000010000  lw	r0, r2
  471=>x"0400",	-- 0000010000000000  inc	r0, r0
  472=>x"D210",	-- 1101001000010000  sw	r0, r2
  473=>x"A6C3",	-- 1010011011000011  bri	-, PaperGameRedrawContent
  474=>x"FFFF",	-- 1111111111111111  reset
  475=>x"063F",	-- 0000011000111111  dec	r7, r7
  476=>x"D238",	-- 1101001000111000  sw	r0, r7
  477=>x"063F",	-- 0000011000111111  dec	r7, r7
  478=>x"D239",	-- 1101001000111001  sw	r1, r7
  479=>x"063F",	-- 0000011000111111  dec	r7, r7
  480=>x"D23A",	-- 1101001000111010  sw	r2, r7
  481=>x"063F",	-- 0000011000111111  dec	r7, r7
  482=>x"D23B",	-- 1101001000111011  sw	r3, r7
  483=>x"063F",	-- 0000011000111111  dec	r7, r7
  484=>x"D23C",	-- 1101001000111100  sw	r4, r7
  485=>x"063F",	-- 0000011000111111  dec	r7, r7
  486=>x"D23D",	-- 1101001000111101  sw	r5, r7
  487=>x"063F",	-- 0000011000111111  dec	r7, r7
  488=>x"D23E",	-- 1101001000111110  sw	r6, r7
  489=>x"FFF2",	-- 1111111111110010  liw	r2, paper_tiles
  490=>x"1730",	-- 0001011100110000  
  491=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  492=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  493=>x"C043",	-- 1100000001000011  li	r3, 8
  494=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  495=>x"02B3",	-- 0000001010110011  
  496=>x"D03E",	-- 1101000000111110  lw	r6, r7
  497=>x"043F",	-- 0000010000111111  inc	r7, r7
  498=>x"D03D",	-- 1101000000111101  lw	r5, r7
  499=>x"043F",	-- 0000010000111111  inc	r7, r7
  500=>x"D03C",	-- 1101000000111100  lw	r4, r7
  501=>x"043F",	-- 0000010000111111  inc	r7, r7
  502=>x"D03B",	-- 1101000000111011  lw	r3, r7
  503=>x"043F",	-- 0000010000111111  inc	r7, r7
  504=>x"D03A",	-- 1101000000111010  lw	r2, r7
  505=>x"043F",	-- 0000010000111111  inc	r7, r7
  506=>x"D039",	-- 1101000000111001  lw	r1, r7
  507=>x"043F",	-- 0000010000111111  inc	r7, r7
  508=>x"D038",	-- 1101000000111000  lw	r0, r7
  509=>x"043F",	-- 0000010000111111  inc	r7, r7
  510=>x"0400",	-- 0000010000000000  inc	r0, r0
  511=>x"E383",	-- 1110001110000011  ba	-, r6
  512=>x"C750",	-- 1100011101010000  li	r0, 234
  513=>x"C1C2",	-- 1100000111000010  li	r2, 56
  514=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  515=>x"0218",	-- 0000001000011000  
  516=>x"C448",	-- 1100010001001000  li	r0, 137
  517=>x"C472",	-- 1100010001110010  li	r2, 142
  518=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  519=>x"020C",	-- 0000001000001100  
  520=>x"C03A",	-- 1100000000111010  li r2, 7
  521=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  522=>x"0223",	-- 0000001000100011  
  523=>x"FFFF",	-- 1111111111111111  reset
  524=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  525=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  526=>x"C085",	-- 1100000010000101  li	r5, 16
  527=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  528=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  529=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  530=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  531=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  532=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  533=>x"062D",	-- 0000011000101101  dec	r5, r5
  534=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  535=>x"E383",	-- 1110001110000011  ba	-, r6
  536=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  537=>x"C084",	-- 1100000010000100  li	r4, 16
  538=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  539=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  540=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  541=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  542=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  543=>x"0400",	-- 0000010000000000  inc	r0, r0
  544=>x"0624",	-- 0000011000100100  dec	r4, r4
  545=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  546=>x"E383",	-- 1110001110000011  ba	-, r6
  547=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  548=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  549=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  550=>x"0409",	-- 0000010000001001  inc	r1, r1
  551=>x"1008",	-- 0001000000001000  mova	r0, r1
  552=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  553=>x"020C",	-- 0000001000001100  
  554=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  555=>x"020C",	-- 0000001000001100  
  556=>x"0612",	-- 0000011000010010  dec	r2, r2
  557=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  558=>x"E383",	-- 1110001110000011  ba	-, r6
  559=>x"063F",	-- 0000011000111111  dec	r7, r7
  560=>x"D23E",	-- 1101001000111110  sw	r6, r7
  561=>x"D013",	-- 1101000000010011  lw	r3, r2
  562=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  563=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  564=>x"063F",	-- 0000011000111111  dec	r7, r7
  565=>x"D23A",	-- 1101001000111010  sw	r2, r7
  566=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  567=>x"0249",	-- 0000001001001001  
  568=>x"D03A",	-- 1101000000111010  lw	r2, r7
  569=>x"043F",	-- 0000010000111111  inc	r7, r7
  570=>x"D013",	-- 1101000000010011  lw	r3, r2
  571=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  572=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  573=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  574=>x"063F",	-- 0000011000111111  dec	r7, r7
  575=>x"D23A",	-- 1101001000111010  sw	r2, r7
  576=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  577=>x"0249",	-- 0000001001001001  
  578=>x"D03A",	-- 1101000000111010  lw	r2, r7
  579=>x"043F",	-- 0000010000111111  inc	r7, r7
  580=>x"0412",	-- 0000010000010010  inc	r2, r2
  581=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  582=>x"D03E",	-- 1101000000111110  lw	r6, r7
  583=>x"043F",	-- 0000010000111111  inc	r7, r7
  584=>x"E383",	-- 1110001110000011  ba	-, r6
  585=>x"063F",	-- 0000011000111111  dec	r7, r7
  586=>x"D23E",	-- 1101001000111110  sw	r6, r7
  587=>x"063F",	-- 0000011000111111  dec	r7, r7
  588=>x"D238",	-- 1101001000111000  sw	r0, r7
  589=>x"063F",	-- 0000011000111111  dec	r7, r7
  590=>x"D239",	-- 1101001000111001  sw	r1, r7
  591=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  592=>x"12C0",	-- 0001001011000000  
  593=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  594=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  595=>x"C043",	-- 1100000001000011  li	r3, 8
  596=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  597=>x"02B3",	-- 0000001010110011  
  598=>x"D039",	-- 1101000000111001  lw	r1, r7
  599=>x"043F",	-- 0000010000111111  inc	r7, r7
  600=>x"D038",	-- 1101000000111000  lw	r0, r7
  601=>x"043F",	-- 0000010000111111  inc	r7, r7
  602=>x"0400",	-- 0000010000000000  inc	r0, r0
  603=>x"D03E",	-- 1101000000111110  lw	r6, r7
  604=>x"043F",	-- 0000010000111111  inc	r7, r7
  605=>x"E383",	-- 1110001110000011  ba	-, r6
  606=>x"063F",	-- 0000011000111111  dec	r7, r7
  607=>x"D23E",	-- 1101001000111110  sw	r6, r7
  608=>x"FFF4",	-- 1111111111110100  liw	r4, 10000
  609=>x"2710",	-- 0010011100010000  
  610=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  611=>x"0271",	-- 0000001001110001  
  612=>x"FFF4",	-- 1111111111110100  liw	r4, 1000
  613=>x"03E8",	-- 0000001111101000  
  614=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  615=>x"0271",	-- 0000001001110001  
  616=>x"C324",	-- 1100001100100100  li	r4, 100
  617=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  618=>x"0271",	-- 0000001001110001  
  619=>x"C054",	-- 1100000001010100  li	r4, 10
  620=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  621=>x"0271",	-- 0000001001110001  
  622=>x"D03E",	-- 1101000000111110  lw	r6, r7
  623=>x"043F",	-- 0000010000111111  inc	r7, r7
  624=>x"C00C",	-- 1100000000001100  li	r4, 1
  625=>x"C17B",	-- 1100000101111011  li	r3, 0x2F
  626=>x"041B",	-- 0000010000011011  inc	r3, r3
  627=>x"0B12",	-- 0000101100010010  sub	r2, r2, r4
  628=>x"BF91",	-- 1011111110010001  brige	r2, printnum.loop
  629=>x"0912",	-- 0000100100010010  add	r2, r2, r4
  630=>x"063F",	-- 0000011000111111  dec	r7, r7
  631=>x"D23E",	-- 1101001000111110  sw	r6, r7
  632=>x"063F",	-- 0000011000111111  dec	r7, r7
  633=>x"D23A",	-- 1101001000111010  sw	r2, r7
  634=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  635=>x"0249",	-- 0000001001001001  
  636=>x"D03A",	-- 1101000000111010  lw	r2, r7
  637=>x"043F",	-- 0000010000111111  inc	r7, r7
  638=>x"D03E",	-- 1101000000111110  lw	r6, r7
  639=>x"043F",	-- 0000010000111111  inc	r7, r7
  640=>x"E383",	-- 1110001110000011  ba	-, r6
  641=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  642=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  643=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  644=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  645=>x"C0A0",	-- 1100000010100000  li	r0, 20
  646=>x"D011",	-- 1101000000010001  lw	r1, r2
  647=>x"D221",	-- 1101001000100001  sw	r1, r4
  648=>x"0412",	-- 0000010000010010  inc	r2, r2
  649=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  650=>x"061B",	-- 0000011000011011  dec	r3, r3
  651=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  652=>x"E383",	-- 1110001110000011  ba	-, r6
  653=>x"C07D",	-- 1100000001111101  li	r5, 15
  654=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  655=>x"6600",	-- 0110011000000000  shr	r0, r0, 3
  656=>x"BC68",	-- 1011110001101000  brieq	r5, put_sprite_16_aligned
  657=>x"062D",	-- 0000011000101101  dec	r5, r5
  658=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  659=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  660=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  661=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  662=>x"063F",	-- 0000011000111111  dec	r7, r7
  663=>x"D23B",	-- 1101001000111011  sw	r3, r7
  664=>x"D011",	-- 1101000000010001  lw	r1, r2
  665=>x"CFF8",	-- 1100111111111000  li	r0, -1
  666=>x"3D40",	-- 0011110101000000  rsr	r0, r0, r5
  667=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  668=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  669=>x"D023",	-- 1101000000100011  lw	r3, r4
  670=>x"2600",	-- 0010011000000000  not	r0, r0
  671=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  672=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  673=>x"D221",	-- 1101001000100001  sw	r1, r4
  674=>x"0424",	-- 0000010000100100  inc	r4, r4
  675=>x"D011",	-- 1101000000010001  lw	r1, r2
  676=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  677=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  678=>x"D023",	-- 1101000000100011  lw	r3, r4
  679=>x"2600",	-- 0010011000000000  not	r0, r0
  680=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  681=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  682=>x"D221",	-- 1101001000100001  sw	r1, r4
  683=>x"0412",	-- 0000010000010010  inc	r2, r2
  684=>x"C098",	-- 1100000010011000  li	r0, 19
  685=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  686=>x"D03B",	-- 1101000000111011  lw	r3, r7
  687=>x"043F",	-- 0000010000111111  inc	r7, r7
  688=>x"061B",	-- 0000011000011011  dec	r3, r3
  689=>x"B95C",	-- 1011100101011100  brine	r3, put_sprite_16.loop
  690=>x"E383",	-- 1110001110000011  ba	-, r6
  691=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  692=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  693=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  694=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  695=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  696=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  697=>x"C0A5",	-- 1100000010100101  li	r5, 20
  698=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  699=>x"D010",	-- 1101000000010000  lw	r0, r2
  700=>x"D021",	-- 1101000000100001  lw	r1, r4
  701=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  702=>x"D221",	-- 1101001000100001  sw	r1, r4
  703=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  704=>x"061B",	-- 0000011000011011  dec	r3, r3
  705=>x"E398",	-- 1110001110011000  baeq	r3, r6
  706=>x"D021",	-- 1101000000100001  lw	r1, r4
  707=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  708=>x"D221",	-- 1101001000100001  sw	r1, r4
  709=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  710=>x"0412",	-- 0000010000010010  inc	r2, r2
  711=>x"061B",	-- 0000011000011011  dec	r3, r3
  712=>x"E398",	-- 1110001110011000  baeq	r3, r6
  713=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  714=>x"D010",	-- 1101000000010000  lw	r0, r2
  715=>x"D021",	-- 1101000000100001  lw	r1, r4
  716=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  717=>x"D221",	-- 1101001000100001  sw	r1, r4
  718=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  719=>x"061B",	-- 0000011000011011  dec	r3, r3
  720=>x"E398",	-- 1110001110011000  baeq	r3, r6
  721=>x"D021",	-- 1101000000100001  lw	r1, r4
  722=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  723=>x"D221",	-- 1101001000100001  sw	r1, r4
  724=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  725=>x"0412",	-- 0000010000010010  inc	r2, r2
  726=>x"061B",	-- 0000011000011011  dec	r3, r3
  727=>x"E398",	-- 1110001110011000  baeq	r3, r6
  728=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
  729=>x"C03D",	-- 1100000000111101  li	r5, 7
  730=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  731=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  732=>x"B5E8",	-- 1011010111101000  brieq	r5, put_sprite_8_aligned
  733=>x"062D",	-- 0000011000101101  dec	r5, r5
  734=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  735=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  736=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  737=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  738=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  739=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  740=>x"8A04",	-- 1000101000000100  brine	r0, put_sprite_8.loop1
  741=>x"D010",	-- 1101000000010000  lw	r0, r2
  742=>x"063F",	-- 0000011000111111  dec	r7, r7
  743=>x"D23A",	-- 1101001000111010  sw	r2, r7
  744=>x"C802",	-- 1100100000000010  li	r2, 0x100
  745=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  746=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  747=>x"D021",	-- 1101000000100001  lw	r1, r4
  748=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  749=>x"2612",	-- 0010011000010010  not	r2, r2
  750=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  751=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  752=>x"D221",	-- 1101001000100001  sw	r1, r4
  753=>x"C0A1",	-- 1100000010100001  li	r1, 20
  754=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  755=>x"D03A",	-- 1101000000111010  lw	r2, r7
  756=>x"043F",	-- 0000010000111111  inc	r7, r7
  757=>x"061B",	-- 0000011000011011  dec	r3, r3
  758=>x"E398",	-- 1110001110011000  baeq	r3, r6
  759=>x"D010",	-- 1101000000010000  lw	r0, r2
  760=>x"063F",	-- 0000011000111111  dec	r7, r7
  761=>x"D23A",	-- 1101001000111010  sw	r2, r7
  762=>x"1E00",	-- 0001111000000000  mixll	r0, r0, r0
  763=>x"C802",	-- 1100100000000010  li	r2, 0x100
  764=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  765=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  766=>x"D021",	-- 1101000000100001  lw	r1, r4
  767=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  768=>x"2612",	-- 0010011000010010  not	r2, r2
  769=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  770=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  771=>x"D221",	-- 1101001000100001  sw	r1, r4
  772=>x"C0A1",	-- 1100000010100001  li	r1, 20
  773=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  774=>x"D03A",	-- 1101000000111010  lw	r2, r7
  775=>x"043F",	-- 0000010000111111  inc	r7, r7
  776=>x"0412",	-- 0000010000010010  inc	r2, r2
  777=>x"061B",	-- 0000011000011011  dec	r3, r3
  778=>x"E398",	-- 1110001110011000  baeq	r3, r6
  779=>x"B683",	-- 1011011010000011  bri	-, put_sprite_8.loop0
  780=>x"D010",	-- 1101000000010000  lw	r0, r2
  781=>x"063F",	-- 0000011000111111  dec	r7, r7
  782=>x"D23A",	-- 1101001000111010  sw	r2, r7
  783=>x"063F",	-- 0000011000111111  dec	r7, r7
  784=>x"D23B",	-- 1101001000111011  sw	r3, r7
  785=>x"C802",	-- 1100100000000010  li	r2, 0x100
  786=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  787=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  788=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  789=>x"D021",	-- 1101000000100001  lw	r1, r4
  790=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  791=>x"261B",	-- 0010011000011011  not	r3, r3
  792=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  793=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  794=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  795=>x"D221",	-- 1101001000100001  sw	r1, r4
  796=>x"0424",	-- 0000010000100100  inc	r4, r4
  797=>x"D021",	-- 1101000000100001  lw	r1, r4
  798=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  799=>x"261B",	-- 0010011000011011  not	r3, r3
  800=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  801=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  802=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  803=>x"D221",	-- 1101001000100001  sw	r1, r4
  804=>x"C099",	-- 1100000010011001  li	r1, 19
  805=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  806=>x"D03B",	-- 1101000000111011  lw	r3, r7
  807=>x"043F",	-- 0000010000111111  inc	r7, r7
  808=>x"D03A",	-- 1101000000111010  lw	r2, r7
  809=>x"043F",	-- 0000010000111111  inc	r7, r7
  810=>x"061B",	-- 0000011000011011  dec	r3, r3
  811=>x"E398",	-- 1110001110011000  baeq	r3, r6
  812=>x"D010",	-- 1101000000010000  lw	r0, r2
  813=>x"4E00",	-- 0100111000000000  shl	r0, r0, 7
  814=>x"063F",	-- 0000011000111111  dec	r7, r7
  815=>x"D23A",	-- 1101001000111010  sw	r2, r7
  816=>x"063F",	-- 0000011000111111  dec	r7, r7
  817=>x"D23B",	-- 1101001000111011  sw	r3, r7
  818=>x"C802",	-- 1100100000000010  li	r2, 0x100
  819=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  820=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  821=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  822=>x"D021",	-- 1101000000100001  lw	r1, r4
  823=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  824=>x"261B",	-- 0010011000011011  not	r3, r3
  825=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  826=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  827=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  828=>x"D221",	-- 1101001000100001  sw	r1, r4
  829=>x"0424",	-- 0000010000100100  inc	r4, r4
  830=>x"D021",	-- 1101000000100001  lw	r1, r4
  831=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  832=>x"261B",	-- 0010011000011011  not	r3, r3
  833=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  834=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  835=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  836=>x"D221",	-- 1101001000100001  sw	r1, r4
  837=>x"C099",	-- 1100000010011001  li	r1, 19
  838=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  839=>x"D03B",	-- 1101000000111011  lw	r3, r7
  840=>x"043F",	-- 0000010000111111  inc	r7, r7
  841=>x"D03A",	-- 1101000000111010  lw	r2, r7
  842=>x"043F",	-- 0000010000111111  inc	r7, r7
  843=>x"0412",	-- 0000010000010010  inc	r2, r2
  844=>x"061B",	-- 0000011000011011  dec	r3, r3
  845=>x"E398",	-- 1110001110011000  baeq	r3, r6
  846=>x"AF83",	-- 1010111110000011  bri	-, put_sprite_8.loop1
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
