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
  103=>x"C04C",	-- 1100000001001100  li	r4, 9
  104=>x"D227",	-- 1101001000100111  sw	r7, r4
  105=>x"C784",	-- 1100011110000100  li	r4, 0xF0
  106=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  107=>x"96E0",	-- 1001011011100000  brieq	r4, int_kbd.release
  108=>x"C704",	-- 1100011100000100  li	r4, 0xE0
  109=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  110=>x"94A0",	-- 1001010010100000  brieq	r4, int_kbd.extended
  111=>x"F45C",	-- 1111010001011100  bspl	r4, r3, 1
  112=>x"8AA4",	-- 1000101010100100  brine	r4, int_kbd_ext
  113=>x"C31C",	-- 1100001100011100  li	r4, 0x63
  114=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  115=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notup
  116=>x"C00D",	-- 1100000000001101  li	r5, 1
  117=>x"8E83",	-- 1000111010000011  bri	-, int_kbd_end
  118=>x"C30C",	-- 1100001100001100  li	r4, 0x61
  119=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  120=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notleft
  121=>x"C015",	-- 1100000000010101  li	r5, 2
  122=>x"8D43",	-- 1000110101000011  bri	-, int_kbd_end
  123=>x"C304",	-- 1100001100000100  li	r4, 0x60
  124=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  125=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notdown
  126=>x"C025",	-- 1100000000100101  li	r5, 4
  127=>x"8C03",	-- 1000110000000011  bri	-, int_kbd_end
  128=>x"C354",	-- 1100001101010100  li	r4, 0x6A
  129=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  130=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notright
  131=>x"C045",	-- 1100000001000101  li	r5, 8
  132=>x"8AC3",	-- 1000101011000011  bri	-, int_kbd_end
  133=>x"C0EC",	-- 1100000011101100  li	r4, 0x1D
  134=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  135=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notW
  136=>x"C00D",	-- 1100000000001101  li	r5, 1
  137=>x"8983",	-- 1000100110000011  bri	-, int_kbd_end
  138=>x"C0E4",	-- 1100000011100100  li	r4, 0x1C
  139=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  140=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notA
  141=>x"C015",	-- 1100000000010101  li	r5, 2
  142=>x"8843",	-- 1000100001000011  bri	-, int_kbd_end
  143=>x"C0DC",	-- 1100000011011100  li	r4, 0x1B
  144=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  145=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notS
  146=>x"C025",	-- 1100000000100101  li	r5, 4
  147=>x"8703",	-- 1000011100000011  bri	-, int_kbd_end
  148=>x"C11C",	-- 1100000100011100  li	r4, 0x23
  149=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  150=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_notD
  151=>x"C045",	-- 1100000001000101  li	r5, 8
  152=>x"85C3",	-- 1000010111000011  bri	-, int_kbd_end
  153=>x"8883",	-- 1000100010000011  bri	-, int_kbd_done
  154=>x"C3AC",	-- 1100001110101100  li	r4, 0x75
  155=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  156=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notup
  157=>x"C00D",	-- 1100000000001101  li	r5, 1
  158=>x"8443",	-- 1000010001000011  bri	-, int_kbd_end
  159=>x"C35C",	-- 1100001101011100  li	r4, 0x6B
  160=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  161=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notleft
  162=>x"C015",	-- 1100000000010101  li	r5, 2
  163=>x"8303",	-- 1000001100000011  bri	-, int_kbd_end
  164=>x"C394",	-- 1100001110010100  li	r4, 0x72
  165=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  166=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notdown
  167=>x"C025",	-- 1100000000100101  li	r5, 4
  168=>x"81C3",	-- 1000000111000011  bri	-, int_kbd_end
  169=>x"C3A4",	-- 1100001110100100  li	r4, 0x74
  170=>x"0B14",	-- 0000101100010100  sub	r4, r2, r4
  171=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_ext_notright
  172=>x"C045",	-- 1100000001000101  li	r5, 8
  173=>x"8083",	-- 1000000010000011  bri	-, int_kbd_end
  174=>x"8343",	-- 1000001101000011  bri	-, int_kbd_done
  175=>x"F41C",	-- 1111010000011100  bspl	r4, r3, 0
  176=>x"FFF3",	-- 1111111111110011  liw	r3, key_press_map
  177=>x"1800",	-- 0001100000000000  
  178=>x"D01A",	-- 1101000000011010  lw	r2, r3
  179=>x"80E4",	-- 1000000011100100  brine	r4, int_kbd_maskout
  180=>x"2352",	-- 0010001101010010  or	r2, r2, r5
  181=>x"80C3",	-- 1000000011000011  bri	-, int_kbd_write
  182=>x"262D",	-- 0010011000101101  not	r5, r5
  183=>x"2152",	-- 0010000101010010  and	r2, r2, r5
  184=>x"D21A",	-- 1101001000011010  sw	r2, r3
  185=>x"C053",	-- 1100000001010011  li	r3, 10
  186=>x"D21A",	-- 1101001000011010  sw	r2, r3
  187=>x"C003",	-- 1100000000000011  li	r3, 0
  188=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  189=>x"1808",	-- 0001100000001000  
  190=>x"D223",	-- 1101001000100011  sw	r3, r4
  191=>x"E383",	-- 1110001110000011  ba	-, r6
  192=>x"C014",	-- 1100000000010100  li	r4, 2
  193=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  194=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  195=>x"1808",	-- 0001100000001000  
  196=>x"D223",	-- 1101001000100011  sw	r3, r4
  197=>x"E383",	-- 1110001110000011  ba	-, r6
  198=>x"C00C",	-- 1100000000001100  li	r4, 1
  199=>x"231B",	-- 0010001100011011  or	r3, r3, r4
  200=>x"FFF4",	-- 1111111111110100  liw	r4, key_press_map + 8
  201=>x"1808",	-- 0001100000001000  
  202=>x"D223",	-- 1101001000100011  sw	r3, r4
  203=>x"E383",	-- 1110001110000011  ba	-, r6
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
  290=>x"C0F3",	-- 1100000011110011  li	r3, 30
  291=>x"CFFA",	-- 1100111111111010  li	r2, -1
  292=>x"D21A",	-- 1101001000011010  sw	r2, r3
  293=>x"FFF0",	-- 1111111111110000  liw	r0, 0x8421
  294=>x"8421",	-- 1000010000100001  
  295=>x"FFF1",	-- 1111111111110001  liw	r1, 0x1234
  296=>x"1234",	-- 0001001000110100  
  297=>x"D640",	-- 1101011001000000  out	r1
  298=>x"E408",	-- 1110010000001000  exw	r0, r1
  299=>x"E408",	-- 1110010000001000  exw	r0, r1
  300=>x"1842",	-- 0001100001000010  mixhh	r2, r0, r1
  301=>x"1A43",	-- 0001101001000011  mixhl	r3, r0, r1
  302=>x"1C44",	-- 0001110001000100  mixlh	r4, r0, r1
  303=>x"1E45",	-- 0001111001000101  mixll	r5, r0, r1
  304=>x"C01E",	-- 1100000000011110  li	r6, 3
  305=>x"3985",	-- 0011100110000101  rrr	r5, r0, r6
  306=>x"3B8D",	-- 0011101110001101  rrl	r5, r1, r6
  307=>x"3D95",	-- 0011110110010101  rsr	r5, r2, r6
  308=>x"3F9D",	-- 0011111110011101  rsl	r5, r3, r6
  309=>x"FC0E",	-- 1111110000001110  mul	r6, r1, r0
  310=>x"C138",	-- 1100000100111000  li	r0, 39
  311=>x"C001",	-- 1100000000000001  li	r1, 0
  312=>x"FFF2",	-- 1111111111110010  liw	r2, font_map + 4 * 0x23
  313=>x"134C",	-- 0001001101001100  
  314=>x"C043",	-- 1100000001000011  li	r3, 8
  315=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  316=>x"0214",	-- 0000001000010100  
  317=>x"C020",	-- 1100000000100000  li	r0, 4
  318=>x"C001",	-- 1100000000000001  li	r1, 0
  319=>x"FFF2",	-- 1111111111110010  liw	r2, hello_str
  320=>x"16C0",	-- 0001011011000000  
  321=>x"FAC6",	-- 1111101011000110  bail	-, r6, puts
  322=>x"01DA",	-- 0000000111011010  
  323=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  324=>x"C0A1",	-- 1100000010100001  li	r1, 20
  325=>x"FFF2",	-- 1111111111110010  liw	r2, 0x2020
  326=>x"2020",	-- 0010000000100000  
  327=>x"D202",	-- 1101001000000010  sw	r2, r0
  328=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  329=>x"FFF2",	-- 1111111111110010  liw	r2, 0x7070
  330=>x"7070",	-- 0111000001110000  
  331=>x"D202",	-- 1101001000000010  sw	r2, r0
  332=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  333=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF8F8
  334=>x"F8F8",	-- 1111100011111000  
  335=>x"D202",	-- 1101001000000010  sw	r2, r0
  336=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  337=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF8F8
  338=>x"F8F8",	-- 1111100011111000  
  339=>x"D202",	-- 1101001000000010  sw	r2, r0
  340=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  341=>x"FFF2",	-- 1111111111110010  liw	r2, 0xF870
  342=>x"F870",	-- 1111100001110000  
  343=>x"D202",	-- 1101001000000010  sw	r2, r0
  344=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  345=>x"FFF2",	-- 1111111111110010  liw	r2, 0x7020
  346=>x"7020",	-- 0111000000100000  
  347=>x"D202",	-- 1101001000000010  sw	r2, r0
  348=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  349=>x"FFF2",	-- 1111111111110010  liw	r2, 0x2070
  350=>x"2070",	-- 0010000001110000  
  351=>x"D202",	-- 1101001000000010  sw	r2, r0
  352=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  353=>x"FFF2",	-- 1111111111110010  liw	r2, 0x0000
  355=>x"D202",	-- 1101001000000010  sw	r2, r0
  356=>x"0840",	-- 0000100001000000  add	r0, r0, r1
  357=>x"C040",	-- 1100000001000000  li	r0, 8
  358=>x"C041",	-- 1100000001000001  li	r1, 8
  359=>x"063F",	-- 0000011000111111  dec	r7, r7
  360=>x"D239",	-- 1101001000111001  sw	r1, r7
  361=>x"063F",	-- 0000011000111111  dec	r7, r7
  362=>x"D238",	-- 1101001000111000  sw	r0, r7
  363=>x"FFF2",	-- 1111111111110010  liw	r2, font_map + 4 * 0x23
  364=>x"134C",	-- 0001001101001100  
  365=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  366=>x"023A",	-- 0000001000111010  
  367=>x"D038",	-- 1101000000111000  lw	r0, r7
  368=>x"043F",	-- 0000010000111111  inc	r7, r7
  369=>x"D039",	-- 1101000000111001  lw	r1, r7
  370=>x"043F",	-- 0000010000111111  inc	r7, r7
  371=>x"C0A2",	-- 1100000010100010  li	r2, 20
  372=>x"C003",	-- 1100000000000011  li	r3, 0
  373=>x"061B",	-- 0000011000011011  dec	r3, r3
  374=>x"BFDC",	-- 1011111111011100  brine	r3, $-1
  375=>x"0612",	-- 0000011000010010  dec	r2, r2
  376=>x"BF14",	-- 1011111100010100  brine	r2, $-4
  377=>x"FFF2",	-- 1111111111110010  liw	r2, key_press_map
  378=>x"1800",	-- 0001100000000000  
  379=>x"D012",	-- 1101000000010010  lw	r2, r2
  380=>x"8B90",	-- 1000101110010000  brieq	r2, event_not_kbd
  381=>x"063F",	-- 0000011000111111  dec	r7, r7
  382=>x"D23A",	-- 1101001000111010  sw	r2, r7
  383=>x"063F",	-- 0000011000111111  dec	r7, r7
  384=>x"D239",	-- 1101001000111001  sw	r1, r7
  385=>x"063F",	-- 0000011000111111  dec	r7, r7
  386=>x"D238",	-- 1101001000111000  sw	r0, r7
  387=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  388=>x"12C0",	-- 0001001011000000  
  389=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8
  390=>x"023A",	-- 0000001000111010  
  391=>x"D038",	-- 1101000000111000  lw	r0, r7
  392=>x"043F",	-- 0000010000111111  inc	r7, r7
  393=>x"D039",	-- 1101000000111001  lw	r1, r7
  394=>x"043F",	-- 0000010000111111  inc	r7, r7
  395=>x"D03A",	-- 1101000000111010  lw	r2, r7
  396=>x"043F",	-- 0000010000111111  inc	r7, r7
  397=>x"F413",	-- 1111010000010011  bspl	r3, r2, 0
  398=>x"81D8",	-- 1000000111011000  brieq	r3, event_kbd_no_up
  399=>x"C043",	-- 1100000001000011  li	r3, 8
  400=>x"0ACB",	-- 0000101011001011  sub	r3, r1, r3
  401=>x"809C",	-- 1000000010011100  brine	r3, event_kbd_no_clip_up
  402=>x"C781",	-- 1100011110000001  li	r1, 240
  403=>x"C043",	-- 1100000001000011  li	r3, 8
  404=>x"0AC9",	-- 0000101011001001  sub	r1, r1, r3
  405=>x"F453",	-- 1111010001010011  bspl	r3, r2, 1
  406=>x"8118",	-- 1000000100011000  brieq	r3, event_kbd_no_left
  407=>x"8084",	-- 1000000010000100  brine	r0, event_kbd_no_clip_left
  408=>x"C9C0",	-- 1100100111000000  li	r0, 39*8
  409=>x"0600",	-- 0000011000000000  dec	r0, r0
  410=>x"F493",	-- 1111010010010011  bspl	r3, r2, 2
  411=>x"81D8",	-- 1000000111011000  brieq	r3, event_kbd_no_down
  412=>x"C743",	-- 1100011101000011  li	r3, 232
  413=>x"0ACB",	-- 0000101011001011  sub	r3, r1, r3
  414=>x"809D",	-- 1000000010011101  brilt	r3, event_kbd_no_clip_down
  415=>x"C001",	-- 1100000000000001  li	r1, 0
  416=>x"C043",	-- 1100000001000011  li	r3, 8
  417=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  418=>x"F4D3",	-- 1111010011010011  bspl	r3, r2, 3
  419=>x"8198",	-- 1000000110011000  brieq	r3, event_kbd_no_right
  420=>x"C9C3",	-- 1100100111000011  li	r3, 39*8
  421=>x"0AC3",	-- 0000101011000011  sub	r3, r0, r3
  422=>x"809D",	-- 1000000010011101  brilt	r3, event_kbd_no_clip_right
  423=>x"CFF8",	-- 1100111111111000  li	r0, -1
  424=>x"0400",	-- 0000010000000000  inc	r0, r0
  425=>x"AF83",	-- 1010111110000011  bri	-, redraw
  426=>x"B3C3",	-- 1011001111000011  bri	-, event_loop
  427=>x"C750",	-- 1100011101010000  li	r0, 234
  428=>x"C1C2",	-- 1100000111000010  li	r2, 56
  429=>x"FAC6",	-- 1111101011000110  bail	-, r6, div_16_16
  430=>x"01C3",	-- 0000000111000011  
  431=>x"C448",	-- 1100010001001000  li	r0, 137
  432=>x"C472",	-- 1100010001110010  li	r2, 142
  433=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  434=>x"01B7",	-- 0000000110110111  
  435=>x"C03A",	-- 1100000000111010  li r2, 7
  436=>x"FAC6",	-- 1111101011000110  bail	-, r6, fact_16
  437=>x"01CE",	-- 0000000111001110  
  438=>x"FFFF",	-- 1111111111111111  reset
  439=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  440=>x"2524",	-- 0010010100100100  xor	r4, r4, r4
  441=>x"C085",	-- 1100000010000101  li	r5, 16
  442=>x"0849",	-- 0000100001001001  add	r1, r1, r1
  443=>x"0C00",	-- 0000110000000000  adc	r0, r0, r0
  444=>x"0EDB",	-- 0000111011011011  sbc	r3, r3, r3
  445=>x"209B",	-- 0010000010011011  and	r3, r3, r2
  446=>x"08C9",	-- 0000100011001001  add	r1, r1, r3
  447=>x"0D00",	-- 0000110100000000  adc	r0, r0, r4
  448=>x"062D",	-- 0000011000101101  dec	r5, r5
  449=>x"BE6C",	-- 1011111001101100  brine	r5, mult_16_16.loop
  450=>x"E383",	-- 1110001110000011  ba	-, r6
  451=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  452=>x"C084",	-- 1100000010000100  li	r4, 16
  453=>x"0800",	-- 0000100000000000  add	r0, r0, r0
  454=>x"0C49",	-- 0000110001001001  adc	r1, r1, r1
  455=>x"0A8B",	-- 0000101010001011  sub	r3, r1, r2
  456=>x"80DD",	-- 1000000011011101  brilt	r3, div_16_16.skip
  457=>x"0A89",	-- 0000101010001001  sub	r1, r1, r2
  458=>x"0400",	-- 0000010000000000  inc	r0, r0
  459=>x"0624",	-- 0000011000100100  dec	r4, r4
  460=>x"BE64",	-- 1011111001100100  brine	r4, div_16_16.loop
  461=>x"E383",	-- 1110001110000011  ba	-, r6
  462=>x"2400",	-- 0010010000000000  xor	r0, r0, r0
  463=>x"2449",	-- 0010010001001001  xor	r1, r1, r1
  464=>x"8250",	-- 1000001001010000  brieq	r2, fact_16.end
  465=>x"0409",	-- 0000010000001001  inc	r1, r1
  466=>x"1008",	-- 0001000000001000  mova	r0, r1
  467=>x"FAC6",	-- 1111101011000110  bail	-, r6, mult_16_16
  468=>x"01B7",	-- 0000000110110111  
  469=>x"8104",	-- 1000000100000100  brine	r0, fact_16.overflow
  470=>x"01B7",	-- 0000000110110111  
  471=>x"0612",	-- 0000011000010010  dec	r2, r2
  472=>x"BE94",	-- 1011111010010100  brine	r2, fact_16.loop
  473=>x"E383",	-- 1110001110000011  ba	-, r6
  474=>x"063F",	-- 0000011000111111  dec	r7, r7
  475=>x"D23E",	-- 1101001000111110  sw	r6, r7
  476=>x"D013",	-- 1101000000010011  lw	r3, r2
  477=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  478=>x"84D8",	-- 1000010011011000  brieq	r3, puts.end
  479=>x"063F",	-- 0000011000111111  dec	r7, r7
  480=>x"D23A",	-- 1101001000111010  sw	r2, r7
  481=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  482=>x"01F4",	-- 0000000111110100  
  483=>x"D03A",	-- 1101000000111010  lw	r2, r7
  484=>x"043F",	-- 0000010000111111  inc	r7, r7
  485=>x"D013",	-- 1101000000010011  lw	r3, r2
  486=>x"4E1B",	-- 0100111000011011  shl	r3, r3, 7
  487=>x"6E1B",	-- 0110111000011011  shr	r3, r3, 7
  488=>x"8258",	-- 1000001001011000  brieq	r3, puts.end
  489=>x"063F",	-- 0000011000111111  dec	r7, r7
  490=>x"D23A",	-- 1101001000111010  sw	r2, r7
  491=>x"FAC6",	-- 1111101011000110  bail	-, r6, putchar
  492=>x"01F4",	-- 0000000111110100  
  493=>x"D03A",	-- 1101000000111010  lw	r2, r7
  494=>x"043F",	-- 0000010000111111  inc	r7, r7
  495=>x"0412",	-- 0000010000010010  inc	r2, r2
  496=>x"BB03",	-- 1011101100000011  bri	-, puts.loop
  497=>x"D03E",	-- 1101000000111110  lw	r6, r7
  498=>x"043F",	-- 0000010000111111  inc	r7, r7
  499=>x"E383",	-- 1110001110000011  ba	-, r6
  500=>x"063F",	-- 0000011000111111  dec	r7, r7
  501=>x"D23E",	-- 1101001000111110  sw	r6, r7
  502=>x"063F",	-- 0000011000111111  dec	r7, r7
  503=>x"D238",	-- 1101001000111000  sw	r0, r7
  504=>x"063F",	-- 0000011000111111  dec	r7, r7
  505=>x"D239",	-- 1101001000111001  sw	r1, r7
  506=>x"FFF2",	-- 1111111111110010  liw	r2, font_map
  507=>x"12C0",	-- 0001001011000000  
  508=>x"421B",	-- 0100001000011011  shl	r3, r3, 1
  509=>x"08D2",	-- 0000100011010010  add	r2, r2, r3
  510=>x"C043",	-- 1100000001000011  li	r3, 8
  511=>x"FAC6",	-- 1111101011000110  bail	-, r6, put_sprite_8_aligned
  512=>x"0214",	-- 0000001000010100  
  513=>x"D039",	-- 1101000000111001  lw	r1, r7
  514=>x"043F",	-- 0000010000111111  inc	r7, r7
  515=>x"D038",	-- 1101000000111000  lw	r0, r7
  516=>x"043F",	-- 0000010000111111  inc	r7, r7
  517=>x"0400",	-- 0000010000000000  inc	r0, r0
  518=>x"D03E",	-- 1101000000111110  lw	r6, r7
  519=>x"043F",	-- 0000010000111111  inc	r7, r7
  520=>x"E383",	-- 1110001110000011  ba	-, r6
  521=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  522=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  523=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  524=>x"0824",	-- 0000100000100100  add	r4, r4, r0
  525=>x"D011",	-- 1101000000010001  lw	r1, r2
  526=>x"D221",	-- 1101001000100001  sw	r1, r4
  527=>x"0412",	-- 0000010000010010  inc	r2, r2
  528=>x"0424",	-- 0000010000100100  inc	r4, r4
  529=>x"061B",	-- 0000011000011011  dec	r3, r3
  530=>x"BEDC",	-- 1011111011011100  brine	r3, put_sprite_16_aligned.loop
  531=>x"E383",	-- 1110001110000011  ba	-, r6
  532=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  533=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  534=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  535=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  536=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  537=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  538=>x"C0A5",	-- 1100000010100101  li	r5, 20
  539=>x"8404",	-- 1000010000000100  brine	r0, put_sprite_8_aligned.loop1
  540=>x"D010",	-- 1101000000010000  lw	r0, r2
  541=>x"D021",	-- 1101000000100001  lw	r1, r4
  542=>x"1A41",	-- 0001101001000001  mixhl	r1, r0, r1
  543=>x"D221",	-- 1101001000100001  sw	r1, r4
  544=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  545=>x"061B",	-- 0000011000011011  dec	r3, r3
  546=>x"E398",	-- 1110001110011000  baeq	r3, r6
  547=>x"D021",	-- 1101000000100001  lw	r1, r4
  548=>x"1E41",	-- 0001111001000001  mixll	r1, r0, r1
  549=>x"D221",	-- 1101001000100001  sw	r1, r4
  550=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  551=>x"0412",	-- 0000010000010010  inc	r2, r2
  552=>x"061B",	-- 0000011000011011  dec	r3, r3
  553=>x"E398",	-- 1110001110011000  baeq	r3, r6
  554=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop0
  555=>x"D010",	-- 1101000000010000  lw	r0, r2
  556=>x"D021",	-- 1101000000100001  lw	r1, r4
  557=>x"1809",	-- 0001100000001001  mixhh	r1, r1, r0
  558=>x"D221",	-- 1101001000100001  sw	r1, r4
  559=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  560=>x"061B",	-- 0000011000011011  dec	r3, r3
  561=>x"E398",	-- 1110001110011000  baeq	r3, r6
  562=>x"D021",	-- 1101000000100001  lw	r1, r4
  563=>x"1A09",	-- 0001101000001001  mixhl	r1, r1, r0
  564=>x"D221",	-- 1101001000100001  sw	r1, r4
  565=>x"0964",	-- 0000100101100100  add	r4, r4, r5
  566=>x"0412",	-- 0000010000010010  inc	r2, r2
  567=>x"061B",	-- 0000011000011011  dec	r3, r3
  568=>x"E398",	-- 1110001110011000  baeq	r3, r6
  569=>x"BC83",	-- 1011110010000011  bri	-, put_sprite_8_aligned.loop1
  570=>x"C03D",	-- 1100000000111101  li	r5, 7
  571=>x"2145",	-- 0010000101000101  and	r5, r0, r5
  572=>x"6400",	-- 0110010000000000  shr	r0, r0, 2
  573=>x"B5EB",	-- 1011010111101011  bri	r5, put_sprite_8_aligned
  574=>x"062D",	-- 0000011000101101  dec	r5, r5
  575=>x"460C",	-- 0100011000001100  shl r4, r1, 3
  576=>x"4209",	-- 0100001000001001  shl	r1, r1, 1
  577=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  578=>x"6001",	-- 0110000000000001  shr	r1, r0, 0
  579=>x"0E00",	-- 0000111000000000  sbc	r0, r0, r0
  580=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  581=>x"8AC4",	-- 1000101011000100  brine	r0, put_sprite_8.loop1
  582=>x"D010",	-- 1101000000010000  lw	r0, r2
  583=>x"063F",	-- 0000011000111111  dec	r7, r7
  584=>x"D23A",	-- 1101001000111010  sw	r2, r7
  585=>x"C002",	-- 1100000000000010  li	r2, 0
  586=>x"1A80",	-- 0001101010000000  mixhl	r0, r0, r2
  587=>x"C802",	-- 1100100000000010  li	r2, 0x100
  588=>x"3B52",	-- 0011101101010010  rrl	r2, r2, r5
  589=>x"3B40",	-- 0011101101000000  rrl	r0, r0, r5
  590=>x"D021",	-- 1101000000100001  lw	r1, r4
  591=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  592=>x"2612",	-- 0010011000010010  not	r2, r2
  593=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  594=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  595=>x"D221",	-- 1101001000100001  sw	r1, r4
  596=>x"C0A1",	-- 1100000010100001  li	r1, 20
  597=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  598=>x"D03A",	-- 1101000000111010  lw	r2, r7
  599=>x"043F",	-- 0000010000111111  inc	r7, r7
  600=>x"061B",	-- 0000011000011011  dec	r3, r3
  601=>x"E398",	-- 1110001110011000  baeq	r3, r6
  602=>x"D010",	-- 1101000000010000  lw	r0, r2
  603=>x"063F",	-- 0000011000111111  dec	r7, r7
  604=>x"D23A",	-- 1101001000111010  sw	r2, r7
  605=>x"C002",	-- 1100000000000010  li	r2, 0
  606=>x"1E80",	-- 0001111010000000  mixll	r0, r0, r2
  607=>x"C802",	-- 1100100000000010  li	r2, 0x100
  608=>x"3B52",	-- 0011101101010010  rrl	r2, r2, r5
  609=>x"3B43",	-- 0011101101000011  rrl	r3, r0, r5
  610=>x"D021",	-- 1101000000100001  lw	r1, r4
  611=>x"2010",	-- 0010000000010000  and	r0, r2, r0
  612=>x"2612",	-- 0010011000010010  not	r2, r2
  613=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  614=>x"2209",	-- 0010001000001001  or	r1, r1, r0
  615=>x"D221",	-- 1101001000100001  sw	r1, r4
  616=>x"C0A1",	-- 1100000010100001  li	r1, 20
  617=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  618=>x"D03A",	-- 1101000000111010  lw	r2, r7
  619=>x"043F",	-- 0000010000111111  inc	r7, r7
  620=>x"0412",	-- 0000010000010010  inc	r2, r2
  621=>x"061B",	-- 0000011000011011  dec	r3, r3
  622=>x"E398",	-- 1110001110011000  baeq	r3, r6
  623=>x"B5C3",	-- 1011010111000011  bri	-, put_sprite_8.loop0
  624=>x"D010",	-- 1101000000010000  lw	r0, r2
  625=>x"063F",	-- 0000011000111111  dec	r7, r7
  626=>x"D23A",	-- 1101001000111010  sw	r2, r7
  627=>x"063F",	-- 0000011000111111  dec	r7, r7
  628=>x"D23B",	-- 1101001000111011  sw	r3, r7
  629=>x"C002",	-- 1100000000000010  li	r2, 0
  630=>x"1C13",	-- 0001110000010011  mixlh	r3, r2, r0
  631=>x"C7FA",	-- 1100011111111010  li	r2, 0xFF
  632=>x"3F52",	-- 0011111101010010  rsl	r2, r2, r5
  633=>x"3F5B",	-- 0011111101011011  rsl	r3, r3, r5
  634=>x"D021",	-- 1101000000100001  lw	r1, r4
  635=>x"20D3",	-- 0010000011010011  and	r3, r2, r3
  636=>x"2612",	-- 0010011000010010  not	r2, r2
  637=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  638=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  639=>x"D221",	-- 1101001000100001  sw	r1, r4
  640=>x"0424",	-- 0000010000100100  inc	r4, r4
  641=>x"C002",	-- 1100000000000010  li	r2, 0
  642=>x"1A83",	-- 0001101010000011  mixhl	r3, r0, r2
  643=>x"CFFA",	-- 1100111111111010  li	r2, -1
  644=>x"3F52",	-- 0011111101010010  rsl	r2, r2, r5
  645=>x"3F5B",	-- 0011111101011011  rsl	r3, r3, r5
  646=>x"D021",	-- 1101000000100001  lw	r1, r4
  647=>x"20D3",	-- 0010000011010011  and	r3, r2, r3
  648=>x"2612",	-- 0010011000010010  not	r2, r2
  649=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  650=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  651=>x"D221",	-- 1101001000100001  sw	r1, r4
  652=>x"C099",	-- 1100000010011001  li	r1, 19
  653=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  654=>x"D03B",	-- 1101000000111011  lw	r3, r7
  655=>x"043F",	-- 0000010000111111  inc	r7, r7
  656=>x"D03A",	-- 1101000000111010  lw	r2, r7
  657=>x"043F",	-- 0000010000111111  inc	r7, r7
  658=>x"061B",	-- 0000011000011011  dec	r3, r3
  659=>x"E398",	-- 1110001110011000  baeq	r3, r6
  660=>x"063F",	-- 0000011000111111  dec	r7, r7
  661=>x"D23A",	-- 1101001000111010  sw	r2, r7
  662=>x"063F",	-- 0000011000111111  dec	r7, r7
  663=>x"D23B",	-- 1101001000111011  sw	r3, r7
  664=>x"C002",	-- 1100000000000010  li	r2, 0
  665=>x"1E13",	-- 0001111000010011  mixll	r3, r2, r0
  666=>x"C7FA",	-- 1100011111111010  li	r2, 0xFF
  667=>x"3F52",	-- 0011111101010010  rsl	r2, r2, r5
  668=>x"3F5B",	-- 0011111101011011  rsl	r3, r3, r5
  669=>x"D021",	-- 1101000000100001  lw	r1, r4
  670=>x"20D3",	-- 0010000011010011  and	r3, r2, r3
  671=>x"2612",	-- 0010011000010010  not	r2, r2
  672=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  673=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  674=>x"D221",	-- 1101001000100001  sw	r1, r4
  675=>x"0424",	-- 0000010000100100  inc	r4, r4
  676=>x"C002",	-- 1100000000000010  li	r2, 0
  677=>x"1E83",	-- 0001111010000011  mixll	r3, r0, r2
  678=>x"CFFA",	-- 1100111111111010  li	r2, -1
  679=>x"3F52",	-- 0011111101010010  rsl	r2, r2, r5
  680=>x"3F5B",	-- 0011111101011011  rsl	r3, r3, r5
  681=>x"D021",	-- 1101000000100001  lw	r1, r4
  682=>x"20D3",	-- 0010000011010011  and	r3, r2, r3
  683=>x"2612",	-- 0010011000010010  not	r2, r2
  684=>x"2089",	-- 0010000010001001  and	r1, r1, r2
  685=>x"22C9",	-- 0010001011001001  or	r1, r1, r3
  686=>x"D221",	-- 1101001000100001  sw	r1, r4
  687=>x"C0E9",	-- 1100000011101001  li	r1, 29
  688=>x"0864",	-- 0000100001100100  add	r4, r4, r1
  689=>x"D03B",	-- 1101000000111011  lw	r3, r7
  690=>x"043F",	-- 0000010000111111  inc	r7, r7
  691=>x"D03A",	-- 1101000000111010  lw	r2, r7
  692=>x"043F",	-- 0000010000111111  inc	r7, r7
  693=>x"0412",	-- 0000010000010010  inc	r2, r2
  694=>x"061B",	-- 0000011000011011  dec	r3, r3
  695=>x"E398",	-- 1110001110011000  baeq	r3, r6
  696=>x"AE03",	-- 1010111000000011  bri	-, put_sprite_8.loop1
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
