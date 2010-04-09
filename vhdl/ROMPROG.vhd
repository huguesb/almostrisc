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
   99=>x"1EBF",	-- 0001111010111111  mixll	r7, r7, r2
  100=>x"C784",	-- 1100011110000100  li	r4, 0xF0
  101=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  102=>x"9620",	-- 1001011000100000  brieq	r4, int_kbd.release
  103=>x"C704",	-- 1100011100000100  li	r4, 0xE0
  104=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  105=>x"94A0",	-- 1001010010100000  brieq	r4, int_kbd.extended
  106=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  107=>x"8AA4",	-- 1000101010100100  brine	r4, int_kbd_ext
  108=>x"C31C",	-- 1100001100011100  li	r4, 0x63
  109=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  110=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notup
  111=>x"C00D",	-- 1100000000001101  li	r5, 1
  112=>x"8E83",	-- 1000111010000011  bri	-, int_kbd_end
  113=>x"C30C",	-- 1100001100001100  li	r4, 0x61
  114=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  115=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notleft
  116=>x"C015",	-- 1100000000010101  li	r5, 2
  117=>x"8D43",	-- 1000110101000011  bri	-, int_kbd_end
  118=>x"C304",	-- 1100001100000100  li	r4, 0x60
  119=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  120=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notdown
  121=>x"C025",	-- 1100000000100101  li	r5, 4
  122=>x"8C03",	-- 1000110000000011  bri	-, int_kbd_end
  123=>x"C354",	-- 1100001101010100  li	r4, 0x6A
  124=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  125=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notright
  126=>x"C045",	-- 1100000001000101  li	r5, 8
  127=>x"8AC3",	-- 1000101011000011  bri	-, int_kbd_end
  128=>x"C0EC",	-- 1100000011101100  li	r4, 0x1D
  129=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  130=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notW
  131=>x"C00D",	-- 1100000000001101  li	r5, 1
  132=>x"8983",	-- 1000100110000011  bri	-, int_kbd_end
  133=>x"C0E4",	-- 1100000011100100  li	r4, 0x1C
  134=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  135=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notA
  136=>x"C015",	-- 1100000000010101  li	r5, 2
  137=>x"8843",	-- 1000100001000011  bri	-, int_kbd_end
  138=>x"C0DC",	-- 1100000011011100  li	r4, 0x1B
  139=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  140=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notS
  141=>x"C025",	-- 1100000000100101  li	r5, 4
  142=>x"8703",	-- 1000011100000011  bri	-, int_kbd_end
  143=>x"C11C",	-- 1100000100011100  li	r4, 0x23
  144=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  145=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notD
  146=>x"C045",	-- 1100000001000101  li	r5, 8
  147=>x"85C3",	-- 1000010111000011  bri	-, int_kbd_end
  148=>x"8943",	-- 1000100101000011  bri	-, int_kbd_done
  149=>x"C3AC",	-- 1100001110101100  li	r4, 0x75
  150=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  151=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notup
  152=>x"C00D",	-- 1100000000001101  li	r5, 1
  153=>x"8443",	-- 1000010001000011  bri	-, int_kbd_end
  154=>x"C35C",	-- 1100001101011100  li	r4, 0x6B
  155=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  156=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notleft
  157=>x"C015",	-- 1100000000010101  li	r5, 2
  158=>x"8303",	-- 1000001100000011  bri	-, int_kbd_end
  159=>x"C394",	-- 1100001110010100  li	r4, 0x72
  160=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  161=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notdown
  162=>x"C025",	-- 1100000000100101  li	r5, 4
  163=>x"81C3",	-- 1000000111000011  bri	-, int_kbd_end
  164=>x"C3A4",	-- 1100001110100100  li	r4, 0x74
  165=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  166=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notright
  167=>x"C045",	-- 1100000001000101  li	r5, 8
  168=>x"8083",	-- 1000000010000011  bri	-, int_kbd_end
  169=>x"8403",	-- 1000010000000011  bri	-, int_kbd_done
  170=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  171=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map
  172=>x"1800",	-- 0001100000000000  
  173=>x"D01A",	-- 1101000000011010  lw	r2, r3
  174=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_maskout
  175=>x"2352",	-- 0010001101010010  or	r2, r2, r5
  176=>x"80C3",	-- 1000000011000011  bri	-, int_kbd_write
  177=>x"262D",	-- 0010011000101101  not	r5, r5
  178=>x"2152",	-- 0010000101010010  and	r2, r2, r5
  179=>x"D21A",	-- 1101001000011010  sw	r2, r3
  180=>x"C053",	-- 1100000001010011  li	r3, 10
  181=>x"D21A",	-- 1101001000011010  sw	r2, r3
  182=>x"C0F3",	-- 1100000011110011  li	r3, 30
  183=>x"CFFA",	-- 1100111111111010  li	r2, -1
  184=>x"D21A",	-- 1101001000011010  sw	r2, r3
  185=>x"C003",	-- 1100000000000011  li	r3, 0
  186=>x"E383",	-- 1110001110000011  ba	-, r6
  187=>x"C014",	-- 1100000000010100  li	r4, 2
  188=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  189=>x"E383",	-- 1110001110000011  ba	-, r6
  190=>x"C00C",	-- 1100000000001100  li	r4, 1
  191=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  192=>x"E383",	-- 1110001110000011  ba	-, r6
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
  313=>x"01FA",	-- 0000000111111010  
  314=>x"C020",	-- 1100000000100000  li	r0, 4
  315=>x"C001",	-- 1100000000000001  li	r1, 0
  316=>x"FFF2",	-- 1111111111110010  liw	r2, hello_str
  317=>x"16C0",	-- 0001011011000000  
  318=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  319=>x"01C0",	-- 0000000111000000  
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
  356=>x"C11B",	-- 1100000100011011  li	r3, 0x23
  357=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  358=>x"01DA",	-- 0000000111011010  
  359=>x"0600",	-- 0000011000000000  dec	r0, r0
  360=>x"FFF2",	-- 1111111111110010  liw	r2, key_press_map
  361=>x"1800",	-- 0001100000000000  
  362=>x"D012",	-- 1101000000010010  lw	r2, r2
  363=>x"8950",	-- 1000100101010000  brieq	r2, event_not_kbd
  364=>x"063F",	-- 0000011000111111  dec	r7, r7
  365=>x"D23A",	-- 1101001000111010  sw	r2, r7
  366=>x"C003",	-- 1100000000000011  li	r3, 0
  367=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  368=>x"01DA",	-- 0000000111011010  
  369=>x"0600",	-- 0000011000000000  dec	r0, r0
  370=>x"D03A",	-- 1101000000111010  lw	r2, r7
  371=>x"043F",	-- 0000010000111111  inc	r7, r7
  372=>x"F413",	-- 1111010000010011  bspl	r3, r2, 0
  373=>x"8198",	-- 1000000110011000  brieq	r3, event_kbd_no_up
  374=>x"640B",	-- 0110010000001011  shr	r3, r1, 2
  375=>x"809C",	-- 1000000010011100  brine	r3, event_kbd_no_clip_up
  376=>x"C781",	-- 1100011110000001  li	r1, 240
  377=>x"C043",	-- 1100000001000011  li	r3, 8
  378=>x"0AC9",	-- 0000101011001001  sub	r1, r1, r3
  379=>x"F453",	-- 1111010001010011  bspl	r3, r2, 1
  380=>x"8118",	-- 1000000100011000  brieq	r3, event_kbd_no_left
  381=>x"8084",	-- 1000000010000100  brine	r0, event_kbd_no_clip_left
  382=>x"C140",	-- 1100000101000000  li	r0, 40
  383=>x"0600",	-- 0000011000000000  dec	r0, r0
  384=>x"F493",	-- 1111010010010011  bspl	r3, r2, 2
  385=>x"81D8",	-- 1000000111011000  brieq	r3, event_kbd_no_down
  386=>x"C743",	-- 1100011101000011  li	r3, 232
  387=>x"0ACB",	-- 0000101011001011  sub	r3, r1, r3
  388=>x"809D",	-- 1000000010011101  brilt	r3, event_kbd_no_clip_down
  389=>x"C001",	-- 1100000000000001  li	r1, 0
  390=>x"C043",	-- 1100000001000011  li	r3, 8
  391=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  392=>x"F4D3",	-- 1111010011010011  bspl	r3, r2, 3
  393=>x"8198",	-- 1000000110011000  brieq	r3, event_kbd_no_right
  394=>x"C13B",	-- 1100000100111011  li	r3, 39
  395=>x"0AC3",	-- 0000101011000011  sub	r3, r0, r3
  396=>x"809D",	-- 1000000010011101  brilt	r3, event_kbd_no_clip_right
  397=>x"CFF8",	-- 1100111111111000  li	r0, -1
  398=>x"0400",	-- 0000010000000000  inc	r0, r0
  399=>x"B543",	-- 1011010101000011  bri	-, redraw
  400=>x"B603",	-- 1011011000000011  bri	-, event_loop
  401=>x"C750",	-- 1100011101010000  li	r0, 234
  402=>x"C1C2",	-- 1100000111000010  li	r2, 56
  403=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  404=>x"01A9",	-- 0000000110101001  
  405=>x"C448",	-- 1100010001001000  li	r0, 137
  406=>x"C472",	-- 1100010001110010  li	r2, 142
  407=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  408=>x"019D",	-- 0000000110011101  
  409=>x"C03A",	-- 1100000000111010  li r2, 7
  410=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  411=>x"01B4",	-- 0000000110110100  
  412=>x"FFFF",	-- 1111111111111111  reset
  413=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  414=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  415=>x"C085",	-- 1100000010000101  li	r5, 16
  416=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  417=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  418=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  419=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  420=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  421=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  422=>x"062D",	-- 0000011000101101  dec	r5, r5
  423=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  424=>x"E383",	-- 1110001110000011  ba	-, r6
  425=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  426=>x"C084",	-- 1100000010000100  li	r4, 16
  427=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  428=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  429=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  430=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  431=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  432=>x"0400",	-- 0000010000000000  inc	r0, r0
  433=>x"0624",	-- 0000011000100100  dec	r4, r4
  434=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  435=>x"E383",	-- 1110001110000011  ba	-, r6
  436=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  437=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  438=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  439=>x"0409",	-- 0000010000001001  inc	r1, r1
  440=>x"1008",	-- 0001000000001000  mova	r0, r1
  441=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  442=>x"019D",	-- 0000000110011101  
  443=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  444=>x"019D",	-- 0000000110011101  
  445=>x"0612",	-- 0000011000010010  dec	r2, r2
  446=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  447=>x"E383",	-- 1110001110000011  ba	-, r6
  448=>x"063F",	-- 0000011000111111  dec	r7, r7
  449=>x"D23E",	-- 1101001000111110  sw	r6, r7
  450=>x"D013",	-- 1101000000010011  lw	r3, r2
  451=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  452=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  453=>x"063F",	-- 0000011000111111  dec	r7, r7
  454=>x"D23A",	-- 1101001000111010  sw	r2, r7
  455=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  456=>x"01DA",	-- 0000000111011010  
  457=>x"D03A",	-- 1101000000111010  lw	r2, r7
  458=>x"043F",	-- 0000010000111111  inc	r7, r7
  459=>x"D013",	-- 1101000000010011  lw	r3, r2
  460=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  461=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  462=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  463=>x"063F",	-- 0000011000111111  dec	r7, r7
  464=>x"D23A",	-- 1101001000111010  sw	r2, r7
  465=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  466=>x"01DA",	-- 0000000111011010  
  467=>x"D03A",	-- 1101000000111010  lw	r2, r7
  468=>x"043F",	-- 0000010000111111  inc	r7, r7
  469=>x"0412",	-- 0000010000010010  inc	r2, r2
  470=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  471=>x"D03E",	-- 1101000000111110  lw	r6, r7
  472=>x"043F",	-- 0000010000111111  inc	r7, r7
  473=>x"E383",	-- 1110001110000011  ba	-, r6
  474=>x"063F",	-- 0000011000111111  dec	r7, r7
  475=>x"D23E",	-- 1101001000111110  sw	r6, r7
  476=>x"063F",	-- 0000011000111111  dec	r7, r7
  477=>x"D238",	-- 1101001000111000  sw	r0, r7
  478=>x"063F",	-- 0000011000111111  dec	r7, r7
  479=>x"D239",	-- 1101001000111001  sw	r1, r7
  480=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  481=>x"12C0",	-- 0001001011000000  
  482=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  483=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  484=>x"C043",	-- 1100000001000011  li	r3, 8
  485=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  486=>x"01FA",	-- 0000000111111010  
  487=>x"D039",	-- 1101000000111001  lw	r1, r7
  488=>x"043F",	-- 0000010000111111  inc	r7, r7
  489=>x"D038",	-- 1101000000111000  lw	r0, r7
  490=>x"043F",	-- 0000010000111111  inc	r7, r7
  491=>x"0400",	-- 0000010000000000  inc	r0, r0
  492=>x"D03E",	-- 1101000000111110  lw	r6, r7
  493=>x"043F",	-- 0000010000111111  inc	r7, r7
  494=>x"E383",	-- 1110001110000011  ba	-, r6
  495=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  496=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  497=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  498=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  499=>x"D011",	-- 1101000000010001  lw	r1, r2
  500=>x"D221",	-- 1101001000100001  sw	r1, r4
  501=>x"0412",	-- 0000010000010010  inc	r2, r2
  502=>x"0424",	-- 0000010000100100  inc	r4, r4
  503=>x"061B",	-- 0000011000011011  dec	r3, r3
  504=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  505=>x"E383",	-- 1110001110000011  ba	-, r6
  506=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  507=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  508=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  509=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  510=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  511=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  512=>x"C0A5",	-- 1100000010100101  li	r5, 20
  513=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  514=>x"D010",	-- 1101000000010000  lw	r0, r2
  515=>x"D021",	-- 1101000000100001  lw	r1, r4
  516=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  517=>x"D221",	-- 1101001000100001  sw	r1, r4
  518=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  519=>x"061B",	-- 0000011000011011  dec	r3, r3
  520=>x"E398",	-- 1110001110011000  baeq	r3, r6
  521=>x"D021",	-- 1101000000100001  lw	r1, r4
  522=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  523=>x"D221",	-- 1101001000100001  sw	r1, r4
  524=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  525=>x"0412",	-- 0000010000010010  inc	r2, r2
  526=>x"061B",	-- 0000011000011011  dec	r3, r3
  527=>x"E398",	-- 1110001110011000  baeq	r3, r6
  528=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  529=>x"D010",	-- 1101000000010000  lw	r0, r2
  530=>x"D021",	-- 1101000000100001  lw	r1, r4
  531=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  532=>x"D221",	-- 1101001000100001  sw	r1, r4
  533=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  534=>x"061B",	-- 0000011000011011  dec	r3, r3
  535=>x"E398",	-- 1110001110011000  baeq	r3, r6
  536=>x"D021",	-- 1101000000100001  lw	r1, r4
  537=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  538=>x"D221",	-- 1101001000100001  sw	r1, r4
  539=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  540=>x"0412",	-- 0000010000010010  inc	r2, r2
  541=>x"061B",	-- 0000011000011011  dec	r3, r3
  542=>x"E398",	-- 1110001110011000  baeq	r3, r6
  543=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
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
