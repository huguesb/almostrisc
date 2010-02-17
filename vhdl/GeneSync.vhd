----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/GeneSync.vhd
--
-- Slightly altered to get rid of vendor-specific packages and adjust formatting
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GeneSync is
	Port (
		CLK, RESET : in std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		IMG : out std_logic;
		X : out std_logic_vector(9 downto 0);
		Y : out std_logic_vector(8 downto 0)
	);
end GeneSync;

architecture Behavioral of GeneSync is
	signal comptX : unsigned (10 downto 0);
	signal comptY : unsigned (9 downto 0);
	signal Yaux : unsigned (9 downto 0);
	signal pulseX : std_logic;
	signal pulseY: std_logic;
	signal IMGX : std_logic;
	signal IMGY : std_logic;
begin
	Y<=std_logic_vector(Yaux(8 downto 0));
	HSYNC<=pulseX;
	VSYNC<=pulseY;
	IMG<=IMGX AND IMGY;
	
	process (CLK)
	begin 
		if ( CLK'event and CLK='1' )then
			if ( RESET='1' ) then
				comptX <= (others => '0' );
				comptY <= (others => '0' );
			else
				if ( comptX(10 downto 1) < 800 ) then 
					comptX <= comptX+1;
				else 
					comptX <= (others => '0' );
				end if;
				
				if ( comptX = 0 ) then 
					if ( comptY < 521 ) then 
						comptY <= comptY+1;
					else 
						comptY <= (others => '0' );
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process (comptX)
	begin 
		if ( comptX(10 downto 1) < 96 ) then 
			X <= (others => '0' );
			pulseX <= '0' ;
			IMGX <= '0' ;
		else 
			if ( comptX(10 downto 1) < (96+48) ) then 
				X<= (others => '0' );
				pulseX <= '1';
				IMGX <= '0';
			else 
				if ( comptX(10 downto 1) < (96+48+640) ) then 
					X <= std_logic_vector(comptX(10 downto 1)-96-48);
					IMGX <= '1' ;
					pulseX <= '1' ;
				else 
					X <= (others => '0' );
					pulseX <= '1' ;
					IMGX <= '0' ;
				end if;		
			end if;
		end if;
	end process;

	process (comptY)
	begin 
		if ( comptY < 2 ) then 
			Yaux <= (others => '0' );
			pulseY<='0';
			IMGY <= '0';
		else 
			if ( comptY < (2+29) ) then 
				Yaux <= (others => '0' );
				pulseY <= '1' ;
				IMGY <= '0' ;
				
			else 
				if ( comptY < (2+29+480) ) then 
					Yaux <=comptY-2-29;
					pulseY <= '1' ;
					IMGY <= '1' ;
				else 
					Yaux<= (others => '0' );
					pulseY <= '1' ;
					IMGY <= '0' ;
				end if;		
			end if;
		end if;
	end process;

end Behavioral;

