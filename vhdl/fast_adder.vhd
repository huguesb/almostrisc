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

entity fast_adder is
	generic(
		size : natural := 16
	);
	
	Port(
		A : in unsigned(size -1 downto 0);
		B : in unsigned(size -1 downto 0);
		CIN : in std_logic;
		
		S : out unsigned(size -1 downto 0);
		COUT : out std_logic
	);
end fast_adder;

architecture structural_ks of fast_adder is
-- G(i)(j), P(i)(j) : "group Generate", "group Propagate". i = group left position, j = group right position
	type Tr is array (size -1 downto 0) of unsigned (size -1 downto 0) ;
	signal G, P : Tr ;

	procedure HA (signal G, P : out std_Logic; signal A, B : in std_Logic) is
	begin
		G <= A and B; P <= A xor B;
	end HA;

	procedure BK (signal GO, PO : out std_Logic; signal GI1, PI1, GI2, PI2 : in std_Logic) is
	begin
		GO <= GI1 or ( PI1 and GI2 ); PO <= PI1 and PI2;
	end BK;

	function koggestone ( i , j : integer) return integer is
		variable p : integer ;
	begin
		p := 2 ;
		
		while p <= i - j loop
			p := p + p ;
		end loop ;
		
		if j = 0 or i - j + 1 = p then
			return i + 1 - p/2 ;
		else
			return 0 ;
		end if ;
	end koggestone ;
begin
	-- "HA" cells row
	HA_row  : for i in size -1 downto 0 generate
		HA( G(i)(i) , P(i)(i) ,   A(i) , B(i) ) ;
	end generate HA_row ;

	-- "BK" cells in Kogge and Stone's trees
	for_i : for i in size -1 downto 1 generate
		for_j : for j in i -1 downto 0 generate
			if_kg : if koggestone (i, j) > 0 generate
				BK( G(i)(j), P(i)(j), G(i)(koggestone(i, j)), P(i)(koggestone(i, j)), G(koggestone(i, j) -1)(j), P(koggestone(i, j) -1)(j) ) ;
			end generate if_kg ;
		end generate for_j ;
	end generate for_i ;

	Cout <= G(size -1)(0) ;
	
	-- "XOR" gates row
	XOR_row  : for i in size -1 downto 1 generate
		S(i) <= P(i)(i) xor (G(i-1)(0) or (P(i - 1)(0) and Cin));
	end generate XOR_row ;
	
	S(0) <= P(0)(0) xor Cin;
end structural_ks;

-- architecture structural_bk of fast_adder_16 is
-- 	-- G(ii)(jj), P(ii)(jj) : "group Generate", "group Propagate". ii = group left position, jj = group right position
-- 	type Tr is array (15 downto 0) of Std_Logic_Vector (15 downto 0) ;
-- 	signal G, P : Tr ;
-- 
-- 	procedure HA (signal G, P : out Std_Logic; signal A, B : in Std_Logic) is
-- 	begin
-- 		G <= A and B; P <= A xor B;
-- 	end HA;
-- 
-- 	procedure BK (signal GO, PO : out Std_Logic; signal GI1, PI1, GI2, PI2 : in Std_Logic) is
-- 	begin
-- 		GO <= GI1 or ( PI1 and GI2 ); PO <= PI1 and PI2;
-- 	end BK;
-- begin
-- 	-- "HA" cells row
-- 	HA ( G(15)(15) , P(15)(15) ,   A(15) , B(15) ) ;
-- 	HA ( G(14)(14) , P(14)(14) ,   A(14) , B(14) ) ;
-- 	HA ( G(13)(13) , P(13)(13) ,   A(13) , B(13) ) ;
-- 	HA ( G(12)(12) , P(12)(12) ,   A(12) , B(12) ) ;
-- 	HA ( G(11)(11) , P(11)(11) ,   A(11) , B(11) ) ;
-- 	HA ( G(10)(10) , P(10)(10) ,   A(10) , B(10) ) ;
-- 	HA ( G(09)(09) , P(09)(09) ,   A(09) , B(09) ) ;
-- 	HA ( G(08)(08) , P(08)(08) ,   A(08) , B(08) ) ;
-- 	HA ( G(07)(07) , P(07)(07) ,   A(07) , B(07) ) ;
-- 	HA ( G(06)(06) , P(06)(06) ,   A(06) , B(06) ) ;
-- 	HA ( G(05)(05) , P(05)(05) ,   A(05) , B(05) ) ;
-- 	HA ( G(04)(04) , P(04)(04) ,   A(04) , B(04) ) ;
-- 	HA ( G(03)(03) , P(03)(03) ,   A(03) , B(03) ) ;
-- 	HA ( G(02)(02) , P(02)(02) ,   A(02) , B(02) ) ;
-- 	HA ( G(01)(01) , P(01)(01) ,   A(01) , B(01) ) ;
-- 	HA ( G(00)(00) , P(00)(00) ,   A(00) , B(00) ) ;
-- 
-- 	-- "BK" cells row 1
-- 	BK ( G(15)(14) , P(15)(14) , G(15)(15) , P(15)(15) , G(14)(14) , P(14)(14) ) ;
-- 	BK ( G(13)(12) , P(13)(12) , G(13)(13) , P(13)(13) , G(12)(12) , P(12)(12) ) ;
-- 	BK ( G(11)(10) , P(11)(10) , G(11)(11) , P(11)(11) , G(10)(10) , P(10)(10) ) ;
-- 	BK ( G(09)(08) , P(09)(08) , G(09)(09) , P(09)(09) , G(08)(08) , P(08)(08) ) ;
-- 	BK ( G(07)(06) , P(07)(06) , G(07)(07) , P(07)(07) , G(06)(06) , P(06)(06) ) ;
-- 	BK ( G(05)(04) , P(05)(04) , G(05)(05) , P(05)(05) , G(04)(04) , P(04)(04) ) ;
-- 	BK ( G(03)(02) , P(03)(02) , G(03)(03) , P(03)(03) , G(02)(02) , P(02)(02) ) ;
-- 	BK ( G(01)(00) , P(01)(00) , G(01)(01) , P(01)(01) , G(00)(00) , P(00)(00) ) ;
-- 
-- 	-- "BK" cells row 2
-- 	BK ( G(15)(12) , P(15)(12) , G(15)(14) , P(15)(14) , G(13)(12) , P(13)(12) ) ;
-- 	BK ( G(14)(12) , P(14)(12) , G(14)(14) , P(14)(14) , G(13)(12) , P(13)(12) ) ;
-- 	BK ( G(11)(08) , P(11)(08) , G(11)(10) , P(11)(10) , G(09)(08) , P(09)(08) ) ;
-- 	BK ( G(07)(04) , P(07)(04) , G(07)(06) , P(07)(06) , G(05)(04) , P(05)(04) ) ;
-- 	BK ( G(03)(00) , P(03)(00) , G(03)(02) , P(03)(02) , G(01)(00) , P(01)(00) ) ;
-- 	BK ( G(02)(00) , P(02)(00) , G(02)(02) , P(02)(02) , G(01)(00) , P(01)(00) ) ;
-- 
-- 	-- "BK" cells row 3
-- 	BK ( G(15)(08) , P(15)(08) , G(15)(12) , P(15)(12) , G(11)(08) , P(11)(08) ) ;
-- 	BK ( G(14)(08) , P(14)(08) , G(14)(12) , P(14)(12) , G(11)(08) , P(11)(08) ) ;
-- 	BK ( G(13)(08) , P(13)(08) , G(13)(12) , P(13)(12) , G(11)(08) , P(11)(08) ) ;
-- 	BK ( G(12)(08) , P(12)(08) , G(12)(12) , P(12)(12) , G(11)(08) , P(11)(08) ) ;
-- 	BK ( G(10)(08) , P(10)(08) , G(10)(10) , P(10)(10) , G(09)(08) , P(09)(08) ) ;
-- 	BK ( G(07)(00) , P(07)(00) , G(07)(04) , P(07)(04) , G(03)(00) , P(03)(00) ) ;
-- 	BK ( G(05)(00) , P(05)(00) , G(05)(04) , P(05)(04) , G(03)(00) , P(03)(00) ) ;
-- 	BK ( G(04)(00) , P(04)(00) , G(04)(04) , P(04)(04) , G(03)(00) , P(03)(00) ) ;
-- 
-- 	-- "BK" cells row 4
-- 	BK ( G(15)(00) , P(15)(00) , G(15)(08) , P(15)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(14)(00) , P(14)(00) , G(14)(08) , P(14)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(13)(00) , P(13)(00) , G(13)(08) , P(13)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(12)(00) , P(12)(00) , G(12)(08) , P(12)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(11)(00) , P(11)(00) , G(11)(08) , P(11)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(10)(00) , P(10)(00) , G(10)(08) , P(10)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(09)(00) , P(09)(00) , G(09)(08) , P(09)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(08)(00) , P(08)(00) , G(08)(08) , P(08)(08) , G(07)(00) , P(07)(00) ) ;
-- 	BK ( G(06)(00) , P(06)(00) , G(06)(06) , P(06)(06) , G(05)(00) , P(05)(00) ) ;
-- 
-- 	-- "XOR" gates row
-- 	Cout <= G(15)(00) ;
-- 	S(15) <= P(15)(15) xor G(14)(00) ;
-- 	S(14) <= P(14)(14) xor G(13)(00) ;
-- 	S(13) <= P(13)(13) xor G(12)(00) ;
-- 	S(12) <= P(12)(12) xor G(11)(00) ;
-- 	S(11) <= P(11)(11) xor G(10)(00) ;
-- 	S(10) <= P(10)(10) xor G(09)(00) ;
-- 	S(09) <= P(09)(09) xor G(08)(00) ;
-- 	S(08) <= P(08)(08) xor G(07)(00) ;
-- 	S(07) <= P(07)(07) xor G(06)(00) ;
-- 	S(06) <= P(06)(06) xor G(05)(00) ;
-- 	S(05) <= P(05)(05) xor G(04)(00) ;
-- 	S(04) <= P(04)(04) xor G(03)(00) ;
-- 	S(03) <= P(03)(03) xor G(02)(00) ;
-- 	S(02) <= P(02)(02) xor G(01)(00) ;
-- 	S(01) <= P(01)(01) xor G(00)(00) ;
-- 	S(00) <= P(00)(00) ;
-- end structural_bk;
