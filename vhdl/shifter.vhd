----------------------------------------------------------------------------------
--
-- Copyright 2010 Hugues Bruant. All rights reserved.
--
-- <hugues.bruant@ensimag.imag.fr>
--
-- This file is part of a school project and licensed under the terms of FreeBSD
-- license (2-clause BSD also refered to as Simplified BSD License)
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
	generic(
		size : natural := 16;
		level : natural := 4
	);
	
	Port(
		A : in unsigned(size -1 downto 0);
		D : in unsigned(level -1 downto 0);
		R : in std_logic;
		
		S : out unsigned(size -1 downto 0);
		COUT : out std_logic
	);
end shifter;

architecture Behavioral of shifter is
	type tr is array (level+1 downto 0) of unsigned (size -1 downto 0) ;
	signal sD : tr;
	signal sCout : unsigned(level downto 0);
	signal sMask : unsigned(size - 1 downto 0);
begin
	COUT <= sD(level)(0);
	
	-- input reversal mux
	rev_in : for i in 0 to size - 1 generate
		--sD(0)(i) <= A(size - 1 - i) when R='0' else A(i);
		
		-- pack reversal with mandatory extra shift :
		sD(0)(i) <= A((size - 2 - i) mod size) when R='0' else A((i + 1) mod size);
	end generate;
	
	-- mask generation for shift (vs rot)
-- 	msk_lvl_gen : for i in 0 to level - 1 generate
-- 		msk_bit_gen : for j in 0 to i generate
-- 			
-- 		end generate;
-- 	end generate;
	
	-- naive mask gen : could be optimized by manual gate instanciation
	msk_gen : for i in 0 to size-1 generate
		sMask(size - 1 - i) <= '0' when to_integer(D)>=i else '1';
	end generate;
	
	-- successive rotate stages
	lvl_gen : for i in 0 to level-1 generate
		bit_gen : for j in 0 to size - 1 generate
			sD(i + 1)(j) <= sD(i)((j + 2**i) mod size) when D(i)='1' else sD(i)(j);
		end generate;
	end generate;
	
	-- apply mask
	sD(level+1) <= sD(level) and sMask;
	
	-- output reversal mux
	rev_out : for i in 0 to size - 1 generate
		S(i) <= sD(level+1)(size - 1 - i) when R='0' else sD(level+1)(i);
	end generate;
	
end Behavioral;
