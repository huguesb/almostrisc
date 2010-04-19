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
  284=>x"1730",	-- 0001011100110000  
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
  300=>x"C0A1",	-- 1100000010100001  li	r1, 20
  301=>x"D201",	-- 1101001000000001  sw	r1, r0
  302=>x"0400",	-- 0000010000000000  inc	r0, r0
  303=>x"C029",	-- 1100000000101001  li	r1, 5
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
  329=>x"1738",	-- 0001011100111000  
  330=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  331=>x"01DC",	-- 0000000111011100  
  332=>x"C788",	-- 1100011110001000  li	r0, 241
  333=>x"C009",	-- 1100000000001001  li	r1, 1
  334=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud
  335=>x"1720",	-- 0001011100100000  
  336=>x"C043",	-- 1100000001000011  li	r3, 8
  337=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  338=>x"0286",	-- 0000001010000110  
  339=>x"C0F8",	-- 1100000011111000  li	r0, 31
  340=>x"C009",	-- 1100000000001001  li	r1, 1
  341=>x"C3DA",	-- 1100001111011010  li	r2, 123
  342=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  343=>x"020B",	-- 0000001000001011  
  344=>x"C120",	-- 1100000100100000  li	r0, 36
  345=>x"C009",	-- 1100000000001001  li	r1, 1
  346=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  347=>x"173E",	-- 0001011100111110  
  348=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  349=>x"01DC",	-- 0000000111011100  
  350=>x"C788",	-- 1100011110001000  li	r0, 241
  351=>x"C051",	-- 1100000001010001  li	r1, 10
  352=>x"FFF2",	-- 1111111111110010  liw	r2, paper_hud + 4
  353=>x"1724",	-- 0001011100100100  
  354=>x"C043",	-- 1100000001000011  li	r3, 8
  355=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  356=>x"0286",	-- 0000001010000110  
  357=>x"C0F8",	-- 1100000011111000  li	r0, 31
  358=>x"C051",	-- 1100000001010001  li	r1, 10
  359=>x"C16A",	-- 1100000101101010  li	r2, 45
  360=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum
  361=>x"020B",	-- 0000001000001011  
  362=>x"C120",	-- 1100000100100000  li	r0, 36
  363=>x"C051",	-- 1100000001010001  li	r1, 10
  364=>x"FFF2",	-- 1111111111110010  liw	r2, paper_unit
  365=>x"173E",	-- 0001011100111110  
  366=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  367=>x"01DC",	-- 0000000111011100  
  368=>x"FFF0",	-- 1111111111110000  liw	r0, 20*20
  369=>x"0190",	-- 0000000110010000  
  370=>x"C001",	-- 1100000000000001  li	r1, 0
  371=>x"FFF2",	-- 1111111111110010  liw	r2, 220*20
  372=>x"1130",	-- 0001000100110000  
  373=>x"D201",	-- 1101001000000001  sw	r1, r0
  374=>x"0400",	-- 0000010000000000  inc	r0, r0
  375=>x"0612",	-- 0000011000010010  dec	r2, r2
  376=>x"BF54",	-- 1011111101010100  brine	r2, $-3
  377=>x"FFF3",	-- 1111111111110011  liw	r3, paper_dir
  378=>x"1730",	-- 0001011100110000  
  379=>x"D01C",	-- 1101000000011100  lw	r4, r3
  380=>x"041B",	-- 0000010000011011  inc	r3, r3
  381=>x"D018",	-- 1101000000011000  lw	r0, r3
  382=>x"FFF2",	-- 1111111111110010  liw	r2, paper_sprites
  383=>x"16D0",	-- 0001011011010000  
  384=>x"4624",	-- 0100011000100100  shl	r4, r4, 3
  385=>x"0912",	-- 0000100100010010  add	r2, r2, r4
  386=>x"C161",	-- 1100000101100001  li	r1, 44
  387=>x"C083",	-- 1100000010000011  li	r3, 16
  388=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_16
  389=>x"023A",	-- 0000001000111010  
  390=>x"C02A",	-- 1100000000101010  li	r2, 5
  391=>x"C003",	-- 1100000000000011  li	r3, 0
  392=>x"061B",	-- 0000011000011011  dec	r3, r3
  393=>x"BFDC",	-- 1011111111011100  brine	r3, $-1
  394=>x"0612",	-- 0000011000010010  dec	r2, r2
  395=>x"BF14",	-- 1011111100010100  brine	r2, $-4
  396=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map
  397=>x"1800",	-- 0001100000000000  
  398=>x"D01B",	-- 1101000000011011  lw	r3, r3
  399=>x"BF58",	-- 1011111101011000  brieq	r3, PaperGameLoop
  400=>x"F7DC",	-- 1111011111011100  bspl	r4, r3, 15
  401=>x"86E4",	-- 1000011011100100  brine	r4, PaperGameQuit
  402=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  403=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveUp
  404=>x"F49C",	-- 1111010010011100  bspl	r4, r3, 2
  405=>x"8060",	-- 1000000001100000  brieq	r4, PaperNoMoveDOWN
  406=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  407=>x"82A0",	-- 1000001010100000  brieq	r4, PaperNoMoveLEFT
  408=>x"FFF2",	-- 1111111111110010  liw	r2, paper_dir
  409=>x"1730",	-- 0001011100110000  
  410=>x"C010",	-- 1100000000010000  li	r0, 2
  411=>x"D210",	-- 1101001000010000  sw	r0, r2
  412=>x"0412",	-- 0000010000010010  inc	r2, r2
  413=>x"D010",	-- 1101000000010000  lw	r0, r2
  414=>x"80C0",	-- 1000000011000000  brieq	r0, $+3
  415=>x"0600",	-- 0000011000000000  dec	r0, r0
  416=>x"D210",	-- 1101001000010000  sw	r0, r2
  417=>x"F4DC",	-- 1111010011011100  bspl	r4, r3, 3
  418=>x"8260",	-- 1000001001100000  brieq	r4, PaperNoMoveRIGHT
  419=>x"FFF2",	-- 1111111111110010  liw	r2, paper_dir
  420=>x"1730",	-- 0001011100110000  
  421=>x"C008",	-- 1100000000001000  li	r0, 1
  422=>x"D210",	-- 1101001000010000  sw	r0, r2
  423=>x"0412",	-- 0000010000010010  inc	r2, r2
  424=>x"D010",	-- 1101000000010000  lw	r0, r2
  425=>x"0400",	-- 0000010000000000  inc	r0, r0
  426=>x"D210",	-- 1101001000010000  sw	r0, r2
  427=>x"B143",	-- 1011000101000011  bri	-, PaperGameRedrawContent
  428=>x"FFFF",	-- 1111111111111111  reset
  429=>x"C750",	-- 1100011101010000  li	r0, 234
  430=>x"C1C2",	-- 1100000111000010  li	r2, 56
  431=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  432=>x"01C5",	-- 0000000111000101  
  433=>x"C448",	-- 1100010001001000  li	r0, 137
  434=>x"C472",	-- 1100010001110010  li	r2, 142
  435=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  436=>x"01B9",	-- 0000000110111001  
  437=>x"C03A",	-- 1100000000111010  li r2, 7
  438=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  439=>x"01D0",	-- 0000000111010000  
  440=>x"FFFF",	-- 1111111111111111  reset
  441=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  442=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  443=>x"C085",	-- 1100000010000101  li	r5, 16
  444=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  445=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  446=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  447=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  448=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  449=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  450=>x"062D",	-- 0000011000101101  dec	r5, r5
  451=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  452=>x"E383",	-- 1110001110000011  ba	-, r6
  453=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  454=>x"C084",	-- 1100000010000100  li	r4, 16
  455=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  456=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  457=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  458=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  459=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  460=>x"0400",	-- 0000010000000000  inc	r0, r0
  461=>x"0624",	-- 0000011000100100  dec	r4, r4
  462=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  463=>x"E383",	-- 1110001110000011  ba	-, r6
  464=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  465=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  466=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  467=>x"0409",	-- 0000010000001001  inc	r1, r1
  468=>x"1008",	-- 0001000000001000  mova	r0, r1
  469=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  470=>x"01B9",	-- 0000000110111001  
  471=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  472=>x"01B9",	-- 0000000110111001  
  473=>x"0612",	-- 0000011000010010  dec	r2, r2
  474=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  475=>x"E383",	-- 1110001110000011  ba	-, r6
  476=>x"063F",	-- 0000011000111111  dec	r7, r7
  477=>x"D23E",	-- 1101001000111110  sw	r6, r7
  478=>x"D013",	-- 1101000000010011  lw	r3, r2
  479=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  480=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  481=>x"063F",	-- 0000011000111111  dec	r7, r7
  482=>x"D23A",	-- 1101001000111010  sw	r2, r7
  483=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  484=>x"01F6",	-- 0000000111110110  
  485=>x"D03A",	-- 1101000000111010  lw	r2, r7
  486=>x"043F",	-- 0000010000111111  inc	r7, r7
  487=>x"D013",	-- 1101000000010011  lw	r3, r2
  488=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  489=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  490=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  491=>x"063F",	-- 0000011000111111  dec	r7, r7
  492=>x"D23A",	-- 1101001000111010  sw	r2, r7
  493=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  494=>x"01F6",	-- 0000000111110110  
  495=>x"D03A",	-- 1101000000111010  lw	r2, r7
  496=>x"043F",	-- 0000010000111111  inc	r7, r7
  497=>x"0412",	-- 0000010000010010  inc	r2, r2
  498=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  499=>x"D03E",	-- 1101000000111110  lw	r6, r7
  500=>x"043F",	-- 0000010000111111  inc	r7, r7
  501=>x"E383",	-- 1110001110000011  ba	-, r6
  502=>x"063F",	-- 0000011000111111  dec	r7, r7
  503=>x"D23E",	-- 1101001000111110  sw	r6, r7
  504=>x"063F",	-- 0000011000111111  dec	r7, r7
  505=>x"D238",	-- 1101001000111000  sw	r0, r7
  506=>x"063F",	-- 0000011000111111  dec	r7, r7
  507=>x"D239",	-- 1101001000111001  sw	r1, r7
  508=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  509=>x"12C0",	-- 0001001011000000  
  510=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  511=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  512=>x"C043",	-- 1100000001000011  li	r3, 8
  513=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  514=>x"0260",	-- 0000001001100000  
  515=>x"D039",	-- 1101000000111001  lw	r1, r7
  516=>x"043F",	-- 0000010000111111  inc	r7, r7
  517=>x"D038",	-- 1101000000111000  lw	r0, r7
  518=>x"043F",	-- 0000010000111111  inc	r7, r7
  519=>x"0400",	-- 0000010000000000  inc	r0, r0
  520=>x"D03E",	-- 1101000000111110  lw	r6, r7
  521=>x"043F",	-- 0000010000111111  inc	r7, r7
  522=>x"E383",	-- 1110001110000011  ba	-, r6
  523=>x"063F",	-- 0000011000111111  dec	r7, r7
  524=>x"D23E",	-- 1101001000111110  sw	r6, r7
  525=>x"FFF4",	-- 1111111111110100  liw	r4, 10000
  526=>x"2710",	-- 0010011100010000  
  527=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  528=>x"021E",	-- 0000001000011110  
  529=>x"FFF4",	-- 1111111111110100  liw	r4, 1000
  530=>x"03E8",	-- 0000001111101000  
  531=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  532=>x"021E",	-- 0000001000011110  
  533=>x"C324",	-- 1100001100100100  li	r4, 100
  534=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  535=>x"021E",	-- 0000001000011110  
  536=>x"C054",	-- 1100000001010100  li	r4, 10
  537=>x"FAC6",	-- 1111101011000110  bail	-, r6, printnum.sub
  538=>x"021E",	-- 0000001000011110  
  539=>x"D03E",	-- 1101000000111110  lw	r6, r7
  540=>x"043F",	-- 0000010000111111  inc	r7, r7
  541=>x"C00C",	-- 1100000000001100  li	r4, 1
  542=>x"CFFB",	-- 1100111111111011  li	r3, '0' - 1
  543=>x"041B",	-- 0000010000011011  inc	r3, r3
  544=>x"0B12",	-- 0000101100010010  sub	r2, r2, r4
  545=>x"BF91",	-- 1011111110010001  brige	r2, printnum.loop
  546=>x"0912",	-- 0000100100010010  add	r2, r2, r4
  547=>x"063F",	-- 0000011000111111  dec	r7, r7
  548=>x"D23E",	-- 1101001000111110  sw	r6, r7
  549=>x"063F",	-- 0000011000111111  dec	r7, r7
  550=>x"D23A",	-- 1101001000111010  sw	r2, r7
  551=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  552=>x"01F6",	-- 0000000111110110  
  553=>x"D03A",	-- 1101000000111010  lw	r2, r7
  554=>x"043F",	-- 0000010000111111  inc	r7, r7
  555=>x"D03E",	-- 1101000000111110  lw	r6, r7
  556=>x"043F",	-- 0000010000111111  inc	r7, r7
  557=>x"E383",	-- 1110001110000011  ba	-, r6
  558=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  559=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  560=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  561=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  562=>x"C0A0",	-- 1100000010100000  li	r0, 20
  563=>x"D011",	-- 1101000000010001  lw	r1, r2
  564=>x"D221",	-- 1101001000100001  sw	r1, r4
  565=>x"0412",	-- 0000010000010010  inc	r2, r2
  566=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  567=>x"061B",	-- 0000011000011011  dec	r3, r3
  568=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  569=>x"E383",	-- 1110001110000011  ba	-, r6
  570=>x"C07D",	-- 1100000001111101  li	r5, 15
  571=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  572=>x"6600",	-- 0110011000000000  shr	r0, r0, 3
  573=>x"BC68",	-- 1011110001101000  brieq	r5, put_sprite_16_aligned
  574=>x"062D",	-- 0000011000101101  dec	r5, r5
  575=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  576=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  577=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  578=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  579=>x"063F",	-- 0000011000111111  dec	r7, r7
  580=>x"D23B",	-- 1101001000111011  sw	r3, r7
  581=>x"D011",	-- 1101000000010001  lw	r1, r2
  582=>x"CFF8",	-- 1100111111111000  li	r0, -1
  583=>x"3D40",	-- 0011110101000000  rsr	r0, r0, r5
  584=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  585=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  586=>x"D023",	-- 1101000000100011  lw	r3, r4
  587=>x"2600",	-- 0010011000000000  not	r0, r0
  588=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  589=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  590=>x"D221",	-- 1101001000100001  sw	r1, r4
  591=>x"0424",	-- 0000010000100100  inc	r4, r4
  592=>x"D011",	-- 1101000000010001  lw	r1, r2
  593=>x"3949",	-- 0011100101001001  rrr	r1, r1, r5
  594=>x"2009",	-- 0010000000001001  and	r1, r1, r0
  595=>x"D023",	-- 1101000000100011  lw	r3, r4
  596=>x"2600",	-- 0010011000000000  not	r0, r0
  597=>x"201B",	-- 0010000000011011  and	r3, r3, r0
  598=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  599=>x"D221",	-- 1101001000100001  sw	r1, r4
  600=>x"0412",	-- 0000010000010010  inc	r2, r2
  601=>x"C098",	-- 1100000010011000  li	r0, 19
  602=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  603=>x"D03B",	-- 1101000000111011  lw	r3, r7
  604=>x"043F",	-- 0000010000111111  inc	r7, r7
  605=>x"061B",	-- 0000011000011011  dec	r3, r3
  606=>x"B95C",	-- 1011100101011100  brine	r3, put_sprite_16.loop
  607=>x"E383",	-- 1110001110000011  ba	-, r6
  608=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  609=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  610=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  611=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  612=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  613=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  614=>x"C0A5",	-- 1100000010100101  li	r5, 20
  615=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  616=>x"D010",	-- 1101000000010000  lw	r0, r2
  617=>x"D021",	-- 1101000000100001  lw	r1, r4
  618=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  619=>x"D221",	-- 1101001000100001  sw	r1, r4
  620=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  621=>x"061B",	-- 0000011000011011  dec	r3, r3
  622=>x"E398",	-- 1110001110011000  baeq	r3, r6
  623=>x"D021",	-- 1101000000100001  lw	r1, r4
  624=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  625=>x"D221",	-- 1101001000100001  sw	r1, r4
  626=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  627=>x"0412",	-- 0000010000010010  inc	r2, r2
  628=>x"061B",	-- 0000011000011011  dec	r3, r3
  629=>x"E398",	-- 1110001110011000  baeq	r3, r6
  630=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  631=>x"D010",	-- 1101000000010000  lw	r0, r2
  632=>x"D021",	-- 1101000000100001  lw	r1, r4
  633=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  634=>x"D221",	-- 1101001000100001  sw	r1, r4
  635=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  636=>x"061B",	-- 0000011000011011  dec	r3, r3
  637=>x"E398",	-- 1110001110011000  baeq	r3, r6
  638=>x"D021",	-- 1101000000100001  lw	r1, r4
  639=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  640=>x"D221",	-- 1101001000100001  sw	r1, r4
  641=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  642=>x"0412",	-- 0000010000010010  inc	r2, r2
  643=>x"061B",	-- 0000011000011011  dec	r3, r3
  644=>x"E398",	-- 1110001110011000  baeq	r3, r6
  645=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
  646=>x"C03D",	-- 1100000000111101  li	r5, 7
  647=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  648=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  649=>x"B5E8",	-- 1011010111101000  brieq	r5, put_sprite_8_aligned
  650=>x"062D",	-- 0000011000101101  dec	r5, r5
  651=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  652=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  653=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  654=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  655=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  656=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  657=>x"8A04",	-- 1000101000000100  brine	r0, put_sprite_8.loop1
  658=>x"D010",	-- 1101000000010000  lw	r0, r2
  659=>x"063F",	-- 0000011000111111  dec	r7, r7
  660=>x"D23A",	-- 1101001000111010  sw	r2, r7
  661=>x"C802",	-- 1100100000000010  li	r2, 0x100
  662=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  663=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  664=>x"D021",	-- 1101000000100001  lw	r1, r4
  665=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  666=>x"2612",	-- 0010011000010010  not	r2, r2
  667=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  668=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  669=>x"D221",	-- 1101001000100001  sw	r1, r4
  670=>x"C0A1",	-- 1100000010100001  li	r1, 20
  671=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  672=>x"D03A",	-- 1101000000111010  lw	r2, r7
  673=>x"043F",	-- 0000010000111111  inc	r7, r7
  674=>x"061B",	-- 0000011000011011  dec	r3, r3
  675=>x"E398",	-- 1110001110011000  baeq	r3, r6
  676=>x"D010",	-- 1101000000010000  lw	r0, r2
  677=>x"063F",	-- 0000011000111111  dec	r7, r7
  678=>x"D23A",	-- 1101001000111010  sw	r2, r7
  679=>x"1E00",	-- 0001111000000000  mixll	r0, r0, r0
  680=>x"C802",	-- 1100100000000010  li	r2, 0x100
  681=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  682=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  683=>x"D021",	-- 1101000000100001  lw	r1, r4
  684=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  685=>x"2612",	-- 0010011000010010  not	r2, r2
  686=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  687=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  688=>x"D221",	-- 1101001000100001  sw	r1, r4
  689=>x"C0A1",	-- 1100000010100001  li	r1, 20
  690=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  691=>x"D03A",	-- 1101000000111010  lw	r2, r7
  692=>x"043F",	-- 0000010000111111  inc	r7, r7
  693=>x"0412",	-- 0000010000010010  inc	r2, r2
  694=>x"061B",	-- 0000011000011011  dec	r3, r3
  695=>x"E398",	-- 1110001110011000  baeq	r3, r6
  696=>x"B683",	-- 1011011010000011  bri	-, put_sprite_8.loop0
  697=>x"D010",	-- 1101000000010000  lw	r0, r2
  698=>x"063F",	-- 0000011000111111  dec	r7, r7
  699=>x"D23A",	-- 1101001000111010  sw	r2, r7
  700=>x"063F",	-- 0000011000111111  dec	r7, r7
  701=>x"D23B",	-- 1101001000111011  sw	r3, r7
  702=>x"C802",	-- 1100100000000010  li	r2, 0x100
  703=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  704=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  705=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  706=>x"D021",	-- 1101000000100001  lw	r1, r4
  707=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  708=>x"261B",	-- 0010011000011011  not	r3, r3
  709=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  710=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  711=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  712=>x"D221",	-- 1101001000100001  sw	r1, r4
  713=>x"0424",	-- 0000010000100100  inc	r4, r4
  714=>x"D021",	-- 1101000000100001  lw	r1, r4
  715=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  716=>x"261B",	-- 0010011000011011  not	r3, r3
  717=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  718=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  719=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  720=>x"D221",	-- 1101001000100001  sw	r1, r4
  721=>x"C099",	-- 1100000010011001  li	r1, 19
  722=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  723=>x"D03B",	-- 1101000000111011  lw	r3, r7
  724=>x"043F",	-- 0000010000111111  inc	r7, r7
  725=>x"D03A",	-- 1101000000111010  lw	r2, r7
  726=>x"043F",	-- 0000010000111111  inc	r7, r7
  727=>x"061B",	-- 0000011000011011  dec	r3, r3
  728=>x"E398",	-- 1110001110011000  baeq	r3, r6
  729=>x"D010",	-- 1101000000010000  lw	r0, r2
  730=>x"4E00",	-- 0100111000000000  shl	r0, r0, 7
  731=>x"063F",	-- 0000011000111111  dec	r7, r7
  732=>x"D23A",	-- 1101001000111010  sw	r2, r7
  733=>x"063F",	-- 0000011000111111  dec	r7, r7
  734=>x"D23B",	-- 1101001000111011  sw	r3, r7
  735=>x"C802",	-- 1100100000000010  li	r2, 0x100
  736=>x"3952",	-- 0011100101010010  rrr	r2, r2, r5
  737=>x"3940",	-- 0011100101000000  rrr	r0, r0, r5
  738=>x"2080",	-- 0010000010000000  and	r0, r0, r2
  739=>x"D021",	-- 1101000000100001  lw	r1, r4
  740=>x"6E13",	-- 0110111000010011  shr	r3, r2, 7
  741=>x"261B",	-- 0010011000011011  not	r3, r3
  742=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  743=>x"6E03",	-- 0110111000000011  shr	r3, r0, 7
  744=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  745=>x"D221",	-- 1101001000100001  sw	r1, r4
  746=>x"0424",	-- 0000010000100100  inc	r4, r4
  747=>x"D021",	-- 1101000000100001  lw	r1, r4
  748=>x"4E13",	-- 0100111000010011  shl	r3, r2, 7
  749=>x"261B",	-- 0010011000011011  not	r3, r3
  750=>x"20C9",	-- 0010000011001001  and	r1, r1, r3
  751=>x"4E03",	-- 0100111000000011  shl	r3, r0, 7
  752=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  753=>x"D221",	-- 1101001000100001  sw	r1, r4
  754=>x"C099",	-- 1100000010011001  li	r1, 19
  755=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  756=>x"D03B",	-- 1101000000111011  lw	r3, r7
  757=>x"043F",	-- 0000010000111111  inc	r7, r7
  758=>x"D03A",	-- 1101000000111010  lw	r2, r7
  759=>x"043F",	-- 0000010000111111  inc	r7, r7
  760=>x"0412",	-- 0000010000010010  inc	r2, r2
  761=>x"061B",	-- 0000011000011011  dec	r3, r3
  762=>x"E398",	-- 1110001110011000  baeq	r3, r6
  763=>x"AF83",	-- 1010111110000011  bri	-, put_sprite_8.loop1
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
