library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- use work.brom_data_pkg.all;

entity ROMPROG is
   port ( AD  : in    std_logic_vector (12 downto 0); 
          CLK : in    std_logic; 
          D   : out   std_logic_vector (15 downto 0));
end ROMPROG;

architecture BEHAVIORAL of ROMPROG is
	component RAMB16_S2
		generic
		(
			INIT : bit_vector := X"000";
			SRVAL : bit_vector := X"000";
			WRITE_MODE : string := "READ_FIRST";
			INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_20 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_21 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_22 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_23 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_24 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_25 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_26 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_27 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_28 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_29 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_2F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_30 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_31 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_32 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_33 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_34 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_35 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_36 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_37 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_38 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_39 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_3F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INITP_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
		);
		port ( ADDR : in    std_logic_vector (12 downto 0); 
				CLK  : in    std_logic; 
				DI   : in    std_logic_vector (1 downto 0); 
-- 				-- DIP  : in    std_logic_vector (0 downto 0); 
				EN   : in    std_logic; 
				SSR  : in    std_logic; 
				WE   : in    std_logic; 
				DO   : out   std_logic_vector (1 downto 0)
-- 				-- DOP  : out   std_logic_vector (0 downto 0)
);
	end component;
begin
	XLXI_0 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_0_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_0_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_0_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_0_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_0_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_0_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_0_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_0_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_0_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_0_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_0_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_0_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_0_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_0_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_0_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_0_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_0_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_0_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_0_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_0_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_0_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_0_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_0_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_0_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_0_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_0_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_0_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_0_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_0_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_0_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_0_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_0_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_0_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_0_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_0_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_0_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_0_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_0_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_0_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_0_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_0_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_0_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_0_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_0_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_0_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_0_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_0_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_0_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_0_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_0_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_0_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_0_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_0_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_0_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_0_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_0_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_0_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_0_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_0_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_0_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_0_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_0_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_0_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_0_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(1 downto 0)
		-- DOP=>open
	);
	
	XLXI_1 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_1_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_1_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_1_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_1_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_1_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_1_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_1_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_1_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_1_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_1_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_1_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_1_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_1_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_1_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_1_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_1_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_1_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_1_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_1_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_1_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_1_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_1_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_1_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_1_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_1_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_1_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_1_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_1_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_1_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_1_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_1_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_1_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_1_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_1_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_1_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_1_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_1_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_1_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_1_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_1_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_1_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_1_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_1_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_1_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_1_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_1_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_1_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_1_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_1_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_1_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_1_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_1_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_1_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_1_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_1_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_1_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_1_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_1_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_1_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_1_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_1_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_1_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_1_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_1_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(3 downto 2)
		-- DOP=>open
	);
	
	XLXI_2 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_2_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_2_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_2_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_2_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_2_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_2_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_2_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_2_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_2_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_2_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_2_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_2_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_2_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_2_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_2_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_2_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_2_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_2_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_2_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_2_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_2_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_2_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_2_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_2_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_2_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_2_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_2_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_2_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_2_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_2_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_2_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_2_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_2_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_2_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_2_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_2_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_2_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_2_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_2_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_2_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_2_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_2_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_2_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_2_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_2_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_2_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_2_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_2_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_2_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_2_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_2_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_2_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_2_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_2_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_2_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_2_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_2_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_2_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_2_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_2_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_2_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_2_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_2_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_2_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(5 downto 4)
		-- DOP=>open
	);
	
	XLXI_3 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_3_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_3_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_3_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_3_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_3_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_3_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_3_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_3_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_3_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_3_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_3_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_3_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_3_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_3_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_3_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_3_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_3_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_3_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_3_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_3_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_3_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_3_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_3_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_3_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_3_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_3_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_3_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_3_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_3_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_3_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_3_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_3_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_3_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_3_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_3_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_3_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_3_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_3_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_3_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_3_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_3_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_3_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_3_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_3_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_3_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_3_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_3_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_3_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_3_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_3_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_3_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_3_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_3_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_3_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_3_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_3_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_3_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_3_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_3_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_3_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_3_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_3_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_3_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_3_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(7 downto 6)
		-- DOP=>open
	);
	
	XLXI_4 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_4_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_4_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_4_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_4_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_4_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_4_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_4_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_4_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_4_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_4_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_4_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_4_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_4_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_4_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_4_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_4_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_4_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_4_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_4_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_4_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_4_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_4_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_4_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_4_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_4_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_4_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_4_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_4_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_4_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_4_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_4_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_4_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_4_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_4_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_4_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_4_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_4_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_4_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_4_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_4_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_4_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_4_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_4_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_4_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_4_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_4_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_4_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_4_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_4_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_4_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_4_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_4_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_4_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_4_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_4_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_4_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_4_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_4_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_4_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_4_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_4_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_4_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_4_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_4_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(9 downto 8)
		-- DOP=>open
	);
	
	XLXI_5 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_5_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_5_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_5_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_5_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_5_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_5_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_5_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_5_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_5_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_5_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_5_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_5_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_5_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_5_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_5_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_5_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_5_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_5_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_5_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_5_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_5_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_5_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_5_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_5_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_5_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_5_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_5_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_5_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_5_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_5_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_5_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_5_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_5_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_5_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_5_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_5_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_5_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_5_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_5_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_5_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_5_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_5_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_5_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_5_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_5_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_5_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_5_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_5_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_5_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_5_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_5_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_5_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_5_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_5_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_5_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_5_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_5_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_5_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_5_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_5_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_5_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_5_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_5_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_5_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(11 downto 10)
		-- DOP=>open
	);
	
	XLXI_6 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_6_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_6_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_6_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_6_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_6_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_6_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_6_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_6_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_6_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_6_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_6_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_6_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_6_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_6_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_6_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_6_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_6_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_6_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_6_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_6_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_6_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_6_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_6_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_6_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_6_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_6_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_6_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_6_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_6_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_6_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_6_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_6_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_6_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_6_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_6_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_6_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_6_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_6_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_6_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_6_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_6_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_6_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_6_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_6_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_6_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_6_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_6_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_6_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_6_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_6_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_6_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_6_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_6_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_6_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_6_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_6_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_6_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_6_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_6_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_6_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_6_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_6_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_6_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_6_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(13 downto 12)
		-- DOP=>open
	);
	
	XLXI_7 : RAMB16_S2
-- 	generic map (
-- 		INIT_00=>cROMPROG_XLXI_7_INIT_00,
-- 		INIT_01=>cROMPROG_XLXI_7_INIT_01,
-- 		INIT_02=>cROMPROG_XLXI_7_INIT_02,
-- 		INIT_03=>cROMPROG_XLXI_7_INIT_03,
-- 		INIT_04=>cROMPROG_XLXI_7_INIT_04,
-- 		INIT_05=>cROMPROG_XLXI_7_INIT_05,
-- 		INIT_06=>cROMPROG_XLXI_7_INIT_06,
-- 		INIT_07=>cROMPROG_XLXI_7_INIT_07,
-- 		INIT_08=>cROMPROG_XLXI_7_INIT_08,
-- 		INIT_09=>cROMPROG_XLXI_7_INIT_09,
-- 		INIT_0a=>cROMPROG_XLXI_7_INIT_0A,
-- 		INIT_0b=>cROMPROG_XLXI_7_INIT_0B,
-- 		INIT_0c=>cROMPROG_XLXI_7_INIT_0C,
-- 		INIT_0d=>cROMPROG_XLXI_7_INIT_0D,
-- 		INIT_0e=>cROMPROG_XLXI_7_INIT_0E,
-- 		INIT_0f=>cROMPROG_XLXI_7_INIT_0F,
-- 		INIT_10=>cROMPROG_XLXI_7_INIT_10,
-- 		INIT_11=>cROMPROG_XLXI_7_INIT_11,
-- 		INIT_12=>cROMPROG_XLXI_7_INIT_12,
-- 		INIT_13=>cROMPROG_XLXI_7_INIT_13,
-- 		INIT_14=>cROMPROG_XLXI_7_INIT_14,
-- 		INIT_15=>cROMPROG_XLXI_7_INIT_15,
-- 		INIT_16=>cROMPROG_XLXI_7_INIT_16,
-- 		INIT_17=>cROMPROG_XLXI_7_INIT_17,
-- 		INIT_18=>cROMPROG_XLXI_7_INIT_18,
-- 		INIT_19=>cROMPROG_XLXI_7_INIT_19,
-- 		INIT_1a=>cROMPROG_XLXI_7_INIT_1A,
-- 		INIT_1b=>cROMPROG_XLXI_7_INIT_1B,
-- 		INIT_1c=>cROMPROG_XLXI_7_INIT_1C,
-- 		INIT_1d=>cROMPROG_XLXI_7_INIT_1D,
-- 		INIT_1e=>cROMPROG_XLXI_7_INIT_1E,
-- 		INIT_1f=>cROMPROG_XLXI_7_INIT_1F,
-- 		INIT_20=>cROMPROG_XLXI_7_INIT_20,
-- 		INIT_21=>cROMPROG_XLXI_7_INIT_21,
-- 		INIT_22=>cROMPROG_XLXI_7_INIT_22,
-- 		INIT_23=>cROMPROG_XLXI_7_INIT_23,
-- 		INIT_24=>cROMPROG_XLXI_7_INIT_24,
-- 		INIT_25=>cROMPROG_XLXI_7_INIT_25,
-- 		INIT_26=>cROMPROG_XLXI_7_INIT_26,
-- 		INIT_27=>cROMPROG_XLXI_7_INIT_27,
-- 		INIT_28=>cROMPROG_XLXI_7_INIT_28,
-- 		INIT_29=>cROMPROG_XLXI_7_INIT_29,
-- 		INIT_2a=>cROMPROG_XLXI_7_INIT_2A,
-- 		INIT_2b=>cROMPROG_XLXI_7_INIT_2B,
-- 		INIT_2c=>cROMPROG_XLXI_7_INIT_2C,
-- 		INIT_2d=>cROMPROG_XLXI_7_INIT_2D,
-- 		INIT_2e=>cROMPROG_XLXI_7_INIT_2E,
-- 		INIT_2f=>cROMPROG_XLXI_7_INIT_2F,
-- 		INIT_30=>cROMPROG_XLXI_7_INIT_30,
-- 		INIT_31=>cROMPROG_XLXI_7_INIT_31,
-- 		INIT_32=>cROMPROG_XLXI_7_INIT_32,
-- 		INIT_33=>cROMPROG_XLXI_7_INIT_33,
-- 		INIT_34=>cROMPROG_XLXI_7_INIT_34,
-- 		INIT_35=>cROMPROG_XLXI_7_INIT_35,
-- 		INIT_36=>cROMPROG_XLXI_7_INIT_36,
-- 		INIT_37=>cROMPROG_XLXI_7_INIT_37,
-- 		INIT_38=>cROMPROG_XLXI_7_INIT_38,
-- 		INIT_39=>cROMPROG_XLXI_7_INIT_39,
-- 		INIT_3a=>cROMPROG_XLXI_7_INIT_3A,
-- 		INIT_3b=>cROMPROG_XLXI_7_INIT_3B,
-- 		INIT_3c=>cROMPROG_XLXI_7_INIT_3C,
-- 		INIT_3d=>cROMPROG_XLXI_7_INIT_3D,
-- 		INIT_3e=>cROMPROG_XLXI_7_INIT_3E,
-- 		INIT_3f=>cROMPROG_XLXI_7_INIT_3F
-- 	)
	port map (
		ADDR=>AD(12 downto 0),
		CLK=>CLK,
		DI=>(others=>'0'),
		-- DIP(0)=>'Z',
		EN=>'1',
		SSR=>'0',
		WE=>'0',
		DO=>D(15 downto 14)
		-- DOP=>open
	);
	
end BEHAVIORAL;
