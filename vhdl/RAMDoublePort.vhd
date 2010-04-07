----------------------------------------------------------------------------------
--
-- File retrieved, on 07/02/2010, from :
-- http://sebastien-viardot.imag.fr/Enseignements/Archi1A2s/sources/RAMDoublePort.vhd
--
-- Slightly altered to get rid of vendor-specific packages and adjust formatting
-- Now auto-filled by asrom script
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAMDoublePort is
    Port ( AD1 : in  STD_LOGIC_VECTOR (12 downto 0);
           AD2 : in  STD_LOGIC_VECTOR (12 downto 0);
           DIN1 : in  STD_LOGIC_VECTOR (15 downto 0);
           DOUT1 : out  STD_LOGIC_VECTOR (15 downto 0);
           WE1 : in  STD_LOGIC;
           DOUT2 : out  STD_LOGIC_VECTOR (15 downto 0);
           OE1 : in  STD_LOGIC;
           CE1 : in  STD_LOGIC;
			  CLK : in STD_LOGIC);
end RAMDoublePort;

 -- memory map :
 --     0 -  4799 : VGA-mapped RAM (320*240 pix, 16 pix per word => 4800 words)
 --  4800 -  5823 : font map (8*8 : 4 words per character, 256 chars => 1024 words)
 --  5824 -  8191 : user data (2368 words)

architecture Behavioral of RAMDoublePort is
 constant low_address: natural := 0;
 constant high_address: natural := 8192;  
 subtype octet is std_logic_vector( 15 downto 0 );
 type zone_memoire is
         array (natural range low_address to high_address) of octet;
 signal memoire: zone_memoire := (
  4804 => x"0050",
  4806 => x"8870",
  4808 => x"0050",
  4810 => x"7088",
  4812 => x"50F8",
  4813 => x"F8F8",
  4814 => x"F870",
  4815 => x"2000",
  4816 => x"2070",
  4817 => x"F8F8",
  4818 => x"F870",
  4819 => x"2000",
  4820 => x"7070",
  4821 => x"20F8",
  4822 => x"F820",
  4823 => x"7000",
  4824 => x"2070",
  4825 => x"F8F8",
  4826 => x"7020",
  4827 => x"7000",
  4829 => x"7070",
  4830 => x"7000",
  4832 => x"F8F8",
  4833 => x"8888",
  4834 => x"88F8",
  4835 => x"F800",
  4837 => x"7050",
  4838 => x"7000",
  4840 => x"F8F8",
  4841 => x"88A8",
  4842 => x"88F8",
  4843 => x"F800",
  4844 => x"2070",
  4845 => x"A820",
  4846 => x"7088",
  4847 => x"7000",
  4848 => x"7088",
  4849 => x"7020",
  4850 => x"20F8",
  4851 => x"2000",
  4852 => x"3838",
  4853 => x"2020",
  4854 => x"60E0",
  4855 => x"6000",
  4856 => x"7878",
  4857 => x"4858",
  4858 => x"58C0",
  4859 => x"C000",
  4860 => x"00A8",
  4861 => x"5088",
  4862 => x"50A8",
  4864 => x"4060",
  4865 => x"7078",
  4866 => x"7060",
  4867 => x"4000",
  4868 => x"1030",
  4869 => x"70F0",
  4870 => x"7030",
  4871 => x"1000",
  4872 => x"2070",
  4873 => x"A820",
  4874 => x"A870",
  4875 => x"2000",
  4876 => x"5050",
  4877 => x"5050",
  4878 => x"0050",
  4879 => x"5000",
  4880 => x"78E8",
  4881 => x"E878",
  4882 => x"2828",
  4883 => x"2800",
  4884 => x"78C8",
  4885 => x"A050",
  4886 => x"2898",
  4887 => x"F000",
  4890 => x"F8F8",
  4891 => x"F800",
  4892 => x"2070",
  4893 => x"2020",
  4894 => x"7020",
  4895 => x"F800",
  4896 => x"2070",
  4897 => x"F820",
  4898 => x"2020",
  4899 => x"2000",
  4900 => x"2020",
  4901 => x"2020",
  4902 => x"F870",
  4903 => x"2000",
  4904 => x"0020",
  4905 => x"30F8",
  4906 => x"3020",
  4908 => x"0020",
  4909 => x"60F8",
  4910 => x"6020",
  4913 => x"4078",
  4917 => x"50F8",
  4918 => x"5000",
  4920 => x"0020",
  4921 => x"2070",
  4922 => x"70F8",
  4923 => x"F800",
  4924 => x"F8F8",
  4925 => x"7070",
  4926 => x"2020",
  4932 => x"1818",
  4933 => x"1818",
  4935 => x"1800",
  4936 => x"6666",
  4937 => x"6600",
  4940 => x"6666",
  4941 => x"FF66",
  4942 => x"FF66",
  4943 => x"6600",
  4944 => x"183E",
  4945 => x"603C",
  4946 => x"067C",
  4947 => x"1800",
  4948 => x"6266",
  4949 => x"0C18",
  4950 => x"3066",
  4951 => x"4600",
  4952 => x"3C66",
  4953 => x"3C38",
  4954 => x"6766",
  4955 => x"3F00",
  4956 => x"060C",
  4957 => x"1800",
  4960 => x"0C18",
  4961 => x"3030",
  4962 => x"3018",
  4963 => x"0C00",
  4964 => x"3018",
  4965 => x"0C0C",
  4966 => x"0C18",
  4967 => x"3000",
  4968 => x"0066",
  4969 => x"3CFF",
  4970 => x"3C66",
  4972 => x"0018",
  4973 => x"187E",
  4974 => x"1818",
  4978 => x"0018",
  4979 => x"1830",
  4981 => x"007E",
  4986 => x"0018",
  4987 => x"1800",
  4988 => x"0003",
  4989 => x"060C",
  4990 => x"1830",
  4991 => x"6000",
  4992 => x"3C66",
  4993 => x"6E76",
  4994 => x"6666",
  4995 => x"3C00",
  4996 => x"1818",
  4997 => x"3818",
  4998 => x"1818",
  4999 => x"7E00",
  5000 => x"3C66",
  5001 => x"060C",
  5002 => x"3060",
  5003 => x"7E00",
  5004 => x"3C66",
  5005 => x"061C",
  5006 => x"0666",
  5007 => x"3C00",
  5008 => x"060E",
  5009 => x"1E66",
  5010 => x"7F06",
  5011 => x"0600",
  5012 => x"7E60",
  5013 => x"7C06",
  5014 => x"0666",
  5015 => x"3C00",
  5016 => x"3C66",
  5017 => x"607C",
  5018 => x"6666",
  5019 => x"3C00",
  5020 => x"7E66",
  5021 => x"0C18",
  5022 => x"1818",
  5023 => x"1800",
  5024 => x"3C66",
  5025 => x"663C",
  5026 => x"6666",
  5027 => x"3C00",
  5028 => x"3C66",
  5029 => x"663E",
  5030 => x"0666",
  5031 => x"3C00",
  5033 => x"1800",
  5034 => x"0018",
  5037 => x"1800",
  5038 => x"0018",
  5039 => x"1830",
  5040 => x"0E18",
  5041 => x"3060",
  5042 => x"3018",
  5043 => x"0E00",
  5045 => x"7E00",
  5046 => x"7E00",
  5048 => x"7018",
  5049 => x"0C06",
  5050 => x"0C18",
  5051 => x"7000",
  5052 => x"3C66",
  5053 => x"060C",
  5054 => x"1800",
  5055 => x"1800",
  5056 => x"3C66",
  5057 => x"6E6E",
  5058 => x"6062",
  5059 => x"3C00",
  5060 => x"183C",
  5061 => x"667E",
  5062 => x"6666",
  5063 => x"6600",
  5064 => x"7C66",
  5065 => x"667C",
  5066 => x"6666",
  5067 => x"7C00",
  5068 => x"3C66",
  5069 => x"6060",
  5070 => x"6066",
  5071 => x"3C00",
  5072 => x"786C",
  5073 => x"6666",
  5074 => x"666C",
  5075 => x"7800",
  5076 => x"7E60",
  5077 => x"6078",
  5078 => x"6060",
  5079 => x"7E00",
  5080 => x"7E60",
  5081 => x"6078",
  5082 => x"6060",
  5083 => x"6000",
  5084 => x"3C66",
  5085 => x"606E",
  5086 => x"6666",
  5087 => x"3C00",
  5088 => x"6666",
  5089 => x"667E",
  5090 => x"6666",
  5091 => x"6600",
  5092 => x"3C18",
  5093 => x"1818",
  5094 => x"1818",
  5095 => x"3C00",
  5096 => x"1E0C",
  5097 => x"0C0C",
  5098 => x"0C6C",
  5099 => x"3800",
  5100 => x"666C",
  5101 => x"7870",
  5102 => x"786C",
  5103 => x"6600",
  5104 => x"6060",
  5105 => x"6060",
  5106 => x"6060",
  5107 => x"7E00",
  5108 => x"6377",
  5109 => x"7F6B",
  5110 => x"6363",
  5111 => x"6300",
  5112 => x"6676",
  5113 => x"7E7E",
  5114 => x"6E66",
  5115 => x"6600",
  5116 => x"3C66",
  5117 => x"6666",
  5118 => x"6666",
  5119 => x"3C00",
  5120 => x"7C66",
  5121 => x"667C",
  5122 => x"6060",
  5123 => x"6000",
  5124 => x"3C66",
  5125 => x"6666",
  5126 => x"663C",
  5127 => x"0E00",
  5128 => x"7C66",
  5129 => x"667C",
  5130 => x"786C",
  5131 => x"6600",
  5132 => x"3C66",
  5133 => x"603C",
  5134 => x"0666",
  5135 => x"3C00",
  5136 => x"7E18",
  5137 => x"1818",
  5138 => x"1818",
  5139 => x"1800",
  5140 => x"6666",
  5141 => x"6666",
  5142 => x"6666",
  5143 => x"3C00",
  5144 => x"6666",
  5145 => x"6666",
  5146 => x"663C",
  5147 => x"1800",
  5148 => x"6363",
  5149 => x"636B",
  5150 => x"7F77",
  5151 => x"6300",
  5152 => x"6666",
  5153 => x"3C18",
  5154 => x"3C66",
  5155 => x"6600",
  5156 => x"6666",
  5157 => x"663C",
  5158 => x"1818",
  5159 => x"1800",
  5160 => x"7E06",
  5161 => x"0C18",
  5162 => x"3060",
  5163 => x"7E00",
  5164 => x"3C30",
  5165 => x"3030",
  5166 => x"3030",
  5167 => x"3C00",
  5168 => x"0060",
  5169 => x"3018",
  5170 => x"0C06",
  5171 => x"0300",
  5172 => x"3C0C",
  5173 => x"0C0C",
  5174 => x"0C0C",
  5175 => x"3C00",
  5176 => x"0018",
  5177 => x"3C7E",
  5178 => x"1818",
  5179 => x"1818",
  5183 => x"00FF",
  5184 => x"6030",
  5185 => x"1800",
  5189 => x"3C06",
  5190 => x"3E66",
  5191 => x"3E00",
  5192 => x"0060",
  5193 => x"607C",
  5194 => x"6666",
  5195 => x"7C00",
  5197 => x"3C60",
  5198 => x"6060",
  5199 => x"3C00",
  5200 => x"0006",
  5201 => x"063E",
  5202 => x"6666",
  5203 => x"3E00",
  5205 => x"3C66",
  5206 => x"7E60",
  5207 => x"3C00",
  5208 => x"000E",
  5209 => x"183E",
  5210 => x"1818",
  5211 => x"1800",
  5213 => x"3E66",
  5214 => x"663E",
  5215 => x"067C",
  5216 => x"0060",
  5217 => x"607C",
  5218 => x"6666",
  5219 => x"6600",
  5220 => x"0018",
  5221 => x"0038",
  5222 => x"1818",
  5223 => x"3C00",
  5224 => x"0006",
  5225 => x"0006",
  5226 => x"0606",
  5227 => x"063C",
  5228 => x"0060",
  5229 => x"606C",
  5230 => x"786C",
  5231 => x"6600",
  5232 => x"0038",
  5233 => x"1818",
  5234 => x"1818",
  5235 => x"3C00",
  5237 => x"667F",
  5238 => x"7F6B",
  5239 => x"6300",
  5241 => x"7C66",
  5242 => x"6666",
  5243 => x"6600",
  5245 => x"3C66",
  5246 => x"6666",
  5247 => x"3C00",
  5249 => x"7C66",
  5250 => x"667C",
  5251 => x"6060",
  5253 => x"3E66",
  5254 => x"663E",
  5255 => x"0606",
  5257 => x"7C66",
  5258 => x"6060",
  5259 => x"6000",
  5261 => x"3E60",
  5262 => x"3C06",
  5263 => x"7C00",
  5264 => x"0018",
  5265 => x"7E18",
  5266 => x"1818",
  5267 => x"0E00",
  5269 => x"6666",
  5270 => x"6666",
  5271 => x"3E00",
  5273 => x"6666",
  5274 => x"663C",
  5275 => x"1800",
  5277 => x"636B",
  5278 => x"7F3E",
  5279 => x"3600",
  5281 => x"663C",
  5282 => x"183C",
  5283 => x"6600",
  5285 => x"6666",
  5286 => x"663E",
  5287 => x"0C78",
  5289 => x"7E0C",
  5290 => x"1830",
  5291 => x"7E00",
  5292 => x"1C30",
  5293 => x"3060",
  5294 => x"3030",
  5295 => x"1C00",
  5296 => x"1818",
  5297 => x"1818",
  5298 => x"1818",
  5299 => x"1818",
  5300 => x"380C",
  5301 => x"0C06",
  5302 => x"0C0C",
  5303 => x"3800",
  5304 => x"0032",
  5305 => x"4C00",
  5308 => x"0020",
  5309 => x"5088",
  5310 => x"8888",
  5311 => x"F800",
  5312 => x"7088",
  5313 => x"8088",
  5314 => x"7020",
  5315 => x"C000",
  5316 => x"0070",
  5317 => x"8088",
  5318 => x"7020",
  5319 => x"C000",
  5320 => x"1448",
  5321 => x"88C8",
  5322 => x"A898",
  5323 => x"8800",
  5324 => x"2850",
  5325 => x"00B0",
  5326 => x"C888",
  5327 => x"8800",
  5328 => x"1020",
  5329 => x"7088",
  5330 => x"F888",
  5331 => x"8800",
  5332 => x"4020",
  5333 => x"7088",
  5334 => x"F888",
  5335 => x"8800",
  5336 => x"5000",
  5337 => x"7088",
  5338 => x"F888",
  5339 => x"8800",
  5340 => x"2050",
  5341 => x"0070",
  5342 => x"88F8",
  5343 => x"8800",
  5344 => x"1020",
  5345 => x"F880",
  5346 => x"F080",
  5347 => x"F800",
  5348 => x"4020",
  5349 => x"F880",
  5350 => x"F080",
  5351 => x"F800",
  5352 => x"5000",
  5353 => x"F880",
  5354 => x"F080",
  5355 => x"F800",
  5356 => x"2050",
  5357 => x"F880",
  5358 => x"F080",
  5359 => x"F800",
  5360 => x"1020",
  5361 => x"F820",
  5362 => x"2020",
  5363 => x"F800",
  5364 => x"4020",
  5365 => x"F820",
  5366 => x"2020",
  5367 => x"F800",
  5368 => x"5000",
  5369 => x"F820",
  5370 => x"2020",
  5371 => x"F800",
  5372 => x"2050",
  5373 => x"F820",
  5374 => x"2020",
  5375 => x"F800",
  5376 => x"1020",
  5377 => x"7088",
  5378 => x"8888",
  5379 => x"7000",
  5380 => x"4020",
  5381 => x"7088",
  5382 => x"8888",
  5383 => x"7000",
  5384 => x"5000",
  5385 => x"7088",
  5386 => x"8888",
  5387 => x"7000",
  5388 => x"2050",
  5389 => x"7088",
  5390 => x"8888",
  5391 => x"7000",
  5392 => x"1020",
  5393 => x"8888",
  5394 => x"8888",
  5395 => x"7000",
  5396 => x"4020",
  5397 => x"8888",
  5398 => x"8888",
  5399 => x"7000",
  5400 => x"5000",
  5401 => x"8888",
  5402 => x"8888",
  5403 => x"7000",
  5404 => x"2050",
  5405 => x"0088",
  5406 => x"8888",
  5407 => x"7000",
  5408 => x"1020",
  5409 => x"7008",
  5410 => x"7888",
  5411 => x"7800",
  5412 => x"4020",
  5413 => x"7008",
  5414 => x"7888",
  5415 => x"7800",
  5416 => x"5000",
  5417 => x"7008",
  5418 => x"7888",
  5419 => x"7800",
  5420 => x"2050",
  5421 => x"7008",
  5422 => x"7888",
  5423 => x"7800",
  5424 => x"1020",
  5425 => x"7884",
  5426 => x"FC80",
  5427 => x"7C00",
  5428 => x"2010",
  5429 => x"7884",
  5430 => x"FC80",
  5431 => x"7C00",
  5432 => x"5000",
  5433 => x"7884",
  5434 => x"FC80",
  5435 => x"7C00",
  5436 => x"2050",
  5437 => x"7884",
  5438 => x"FC80",
  5439 => x"7C00",
  5440 => x"1020",
  5441 => x"0060",
  5442 => x"2020",
  5443 => x"7000",
  5444 => x"4020",
  5445 => x"0060",
  5446 => x"2020",
  5447 => x"7000",
  5448 => x"0050",
  5449 => x"0060",
  5450 => x"2020",
  5451 => x"7000",
  5452 => x"2050",
  5453 => x"0060",
  5454 => x"2020",
  5455 => x"7000",
  5456 => x"1020",
  5457 => x"0070",
  5458 => x"8888",
  5459 => x"7000",
  5460 => x"4020",
  5461 => x"0070",
  5462 => x"8888",
  5463 => x"7000",
  5464 => x"0050",
  5465 => x"0070",
  5466 => x"8888",
  5467 => x"7000",
  5468 => x"2050",
  5469 => x"0070",
  5470 => x"8888",
  5471 => x"7000",
  5472 => x"1020",
  5473 => x"0088",
  5474 => x"8898",
  5475 => x"6800",
  5476 => x"4020",
  5477 => x"0088",
  5478 => x"8898",
  5479 => x"6800",
  5480 => x"0050",
  5481 => x"0088",
  5482 => x"8898",
  5483 => x"6800",
  5484 => x"2050",
  5485 => x"0088",
  5486 => x"8898",
  5487 => x"6800",
  5488 => x"5000",
  5489 => x"8850",
  5490 => x"2020",
  5491 => x"2000",
  5492 => x"5000",
  5493 => x"8850",
  5494 => x"2040",
  5495 => x"8000",
  5496 => x"2000",
  5497 => x"2040",
  5498 => x"8088",
  5499 => x"7000",
  5500 => x"2020",
  5501 => x"0020",
  5502 => x"2020",
  5503 => x"2000",
  5505 => x"4890",
  5506 => x"4800",
  5509 => x"9048",
  5510 => x"9000",
  5512 => x"8822",
  5513 => x"8822",
  5514 => x"8822",
  5515 => x"8822",
  5516 => x"AA55",
  5517 => x"AA55",
  5518 => x"AA55",
  5519 => x"AA54",
  5520 => x"CCFF",
  5521 => x"33CC",
  5522 => x"FF33",
  5523 => x"CCFF",
  5524 => x"3030",
  5525 => x"3030",
  5526 => x"3030",
  5527 => x"3030",
  5529 => x"00FC",
  5530 => x"FC00",
  5532 => x"3030",
  5533 => x"303C",
  5534 => x"3C00",
  5536 => x"3030",
  5537 => x"30F0",
  5538 => x"F000",
  5541 => x"003C",
  5542 => x"3C30",
  5543 => x"3030",
  5545 => x"00F0",
  5546 => x"F030",
  5547 => x"3030",
  5548 => x"3030",
  5549 => x"30F0",
  5550 => x"F030",
  5551 => x"3030",
  5552 => x"3030",
  5553 => x"30FC",
  5554 => x"FC00",
  5556 => x"3030",
  5557 => x"303C",
  5558 => x"3C30",
  5559 => x"3030",
  5561 => x"00FC",
  5562 => x"FC30",
  5563 => x"3030",
  5564 => x"3030",
  5565 => x"30FC",
  5566 => x"FC30",
  5567 => x"3030",
  5568 => x"3030",
  5569 => x"3030",
  5570 => x"3000",
  5573 => x"00F0",
  5574 => x"F000",
  5577 => x"003C",
  5578 => x"3C00",
  5581 => x"0030",
  5582 => x"3030",
  5583 => x"3030",
  5584 => x"FC84",
  5585 => x"8484",
  5586 => x"8484",
  5587 => x"84FC",
  5588 => x"FCFC",
  5589 => x"CCCC",
  5590 => x"CCCC",
  5591 => x"FCFC",
  5592 => x"FCFC",
  5593 => x"FCFC",
  5594 => x"FCFC",
  5595 => x"FCFC",
  5596 => x"FCFC",
  5597 => x"FCFC",
  5600 => x"E0E0",
  5601 => x"E0E0",
  5602 => x"E0E0",
  5603 => x"E0E0",
  5604 => x"1C1C",
  5605 => x"1C1C",
  5606 => x"1C1C",
  5607 => x"1C1C",
  5610 => x"FCFC",
  5611 => x"FCFC",
  5613 => x"6890",
  5614 => x"9090",
  5615 => x"6800",
  5616 => x"3048",
  5617 => x"4870",
  5618 => x"4868",
  5619 => x"5000",
  5620 => x"00F8",
  5621 => x"8080",
  5622 => x"8080",
  5623 => x"8000",
  5624 => x"0040",
  5625 => x"A810",
  5626 => x"1010",
  5627 => x"1000",
  5628 => x"2020",
  5629 => x"5050",
  5630 => x"8888",
  5631 => x"F800",
  5632 => x"7088",
  5633 => x"6010",
  5634 => x"7088",
  5635 => x"7000",
  5637 => x"7880",
  5638 => x"F880",
  5639 => x"7800",
  5640 => x"2018",
  5641 => x"2040",
  5642 => x"3008",
  5643 => x"7000",
  5644 => x"7088",
  5645 => x"88F8",
  5646 => x"8888",
  5647 => x"7000",
  5649 => x"C040",
  5650 => x"4050",
  5651 => x"2000",
  5652 => x"2020",
  5653 => x"5050",
  5654 => x"8888",
  5655 => x"8800",
  5656 => x"00C0",
  5657 => x"2020",
  5658 => x"5048",
  5659 => x"8800",
  5661 => x"9080",
  5662 => x"90F8",
  5663 => x"8000",
  5664 => x"00F8",
  5665 => x"8888",
  5666 => x"8888",
  5667 => x"8800",
  5669 => x"00F8",
  5670 => x"5050",
  5671 => x"5000",
  5672 => x"FC40",
  5673 => x"2010",
  5674 => x"2040",
  5675 => x"F800",
  5677 => x"7890",
  5678 => x"9090",
  5679 => x"6000",
  5681 => x"78A0",
  5682 => x"2020",
  5683 => x"1800",
  5684 => x"2020",
  5685 => x"70A8",
  5686 => x"7020",
  5687 => x"2000",
  5688 => x"8048",
  5689 => x"5020",
  5690 => x"5090",
  5691 => x"0800",
  5692 => x"0070",
  5693 => x"8888",
  5694 => x"8850",
  5695 => x"D800",
  5696 => x"00F8",
  5697 => x"00F8",
  5698 => x"00F8",
  5700 => x"0020",
  5701 => x"20F8",
  5702 => x"2020",
  5703 => x"F800",
  5704 => x"C030",
  5705 => x"0830",
  5706 => x"C000",
  5707 => x"F800",
  5708 => x"1860",
  5709 => x"8060",
  5710 => x"1800",
  5711 => x"F800",
  5712 => x"0020",
  5713 => x"00F8",
  5714 => x"0020",
  5716 => x"3048",
  5717 => x"3000",
  5720 => x"0018",
  5721 => x"1010",
  5722 => x"9050",
  5723 => x"2000",
  5724 => x"6010",
  5725 => x"2070",
  5728 => x"7088",
  5729 => x"8890",
  5730 => x"8888",
  5731 => x"88B0",
  5732 => x"0020",
  5733 => x"70A0",
  5734 => x"A070",
  5735 => x"2000",
  5736 => x"3C50",
  5737 => x"90FC",
  5738 => x"9090",
  5739 => x"9C00",
  5740 => x"7C90",
  5741 => x"909C",
  5742 => x"9090",
  5743 => x"7C00",
  5744 => x"7088",
  5745 => x"80F0",
  5746 => x"4040",
  5747 => x"F800",
  5748 => x"8888",
  5749 => x"50F8",
  5750 => x"20F8",
  5751 => x"2000",
  5752 => x"1028",
  5753 => x"2020",
  5754 => x"20A0",
  5755 => x"4000",
  5756 => x"F880",
  5757 => x"80F0",
  5758 => x"8888",
  5759 => x"F000",
  5760 => x"F050",
  5761 => x"5090",
  5762 => x"90F8",
  5763 => x"8800",
  5764 => x"A8A8",
  5765 => x"70A8",
  5766 => x"A8A8",
  5767 => x"A800",
  5768 => x"7088",
  5769 => x"0830",
  5770 => x"0888",
  5771 => x"7000",
  5772 => x"8888",
  5773 => x"C8A8",
  5774 => x"9888",
  5775 => x"8800",
  5776 => x"5020",
  5777 => x"88C8",
  5778 => x"A898",
  5779 => x"8800",
  5780 => x"7848",
  5781 => x"4848",
  5782 => x"4848",
  5783 => x"C800",
  5784 => x"8888",
  5785 => x"8888",
  5786 => x"88F8",
  5787 => x"0800",
  5788 => x"8888",
  5789 => x"8878",
  5790 => x"0808",
  5791 => x"0800",
  5792 => x"A8A8",
  5793 => x"A8A8",
  5794 => x"A8A8",
  5795 => x"F800",
  5796 => x"A8A8",
  5797 => x"A8A8",
  5798 => x"A8F8",
  5799 => x"0800",
  5800 => x"C040",
  5801 => x"4070",
  5802 => x"4848",
  5803 => x"7000",
  5804 => x"8888",
  5805 => x"88E8",
  5806 => x"9898",
  5807 => x"E800",
  5808 => x"8080",
  5809 => x"80F0",
  5810 => x"8888",
  5811 => x"F000",
  5812 => x"7088",
  5813 => x"0878",
  5814 => x"0888",
  5815 => x"7000",
  5816 => x"90A8",
  5817 => x"A8E8",
  5818 => x"A8A8",
  5819 => x"9000",
  5820 => x"7888",
  5821 => x"8878",
  5822 => x"4888",
  5823 => x"8800",
  5824 => x"4865",
  5825 => x"6C6C",
  5826 => x"6F20",
  5827 => x"576F",
  5828 => x"726C",
  5829 => x"6421",
  5830 => x"0041",
  5831 => x"6E6F",
  5832 => x"7468",
  5833 => x"6572",
  5834 => x"2074",
  5835 => x"6573",
  5836 => x"7400",
  others => x"0000"
 );
begin
   process(CLK)
	begin 
		if (CLK'event AND CLK='1') then
			DOUT2 <= memoire(to_integer(unsigned(AD2)));
		end if;
	end process;

	process(CLK)
	begin 
		if (CLK'event AND CLK='1') then
			if ((CE1='1') AND (OE1='1')) then 
				DOUT1<=memoire(to_integer(unsigned(AD1)));
			else 
				DOUT1<=(others =>'0');
			end if;		
		end if;
	end process;
	
	process (CLK)
	begin
	  IF (CLK'event AND CLK='1') then
			if ((CE1='1') AND (WE1='1')) then 
				memoire(to_integer(unsigned(AD1)))<=DIN1;
			end if;
		  end if;
	end process;
	
end Behavioral;
