LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY cir_74AC299 IS

	port(
	CP,MR_BAR,DS0,DS7 : IN std_logic;
	S : IN std_logic_vector(1 downto 0);
	OE_BAR : IN std_logic_vector (1 downto 0);
	IO : INOUT std_logic_vector(7 downto 0);
	Q0,Q7 : OUT std_logic
	);
END cir_74AC299;

ARCHITECTURE behavioral OF cir_74AC299 IS

signal	tmp :std_logic;
signal	Q_in : std_logic_vector (7 downto 0);
--signal	Q_inHOLD : std_logic_vector (7 downto 0):=X"00";
BEGIN
	


	Process1 : PROCESS (S,MR_BAR,CP,Q_in)
	
	BEGIN
			
	
			IF(MR_BAR='0') THEN
		Q_in <= X"00";

			

			ELSIF(CP'EVENT AND CP = '1') THEN
			--IF(S="00") THEN --mode hold
		--Q_inHOLD <= (others => '0');
		
			--END IF;

			IF(S = "01") THEN -- decalage à droite
				Q_in <= Q_in(6 downto 0) & DS7;
				
			END IF;
			IF(S= "10") THEN--decalage à gauche 
				
				Q_in <= DS0 & Q_in(7 downto 1) ;
			END IF;
			IF(S="11" AND tmp='1') THEN		-- chargement parallele 
				Q_in<= IO;
			END IF;

	

	END IF;
	Q0 <= Q_in(0); --chargement des LSB et MSB des sorties series dans Q0 et Q7
	Q7 <= Q_in(7);	

	END PROCESS Process1;

	Process2 : PROCESS (MR_BAR,OE_BAR,CP,Q_in,S)

	BEGIN
		IF(MR_BAR='0') THEN
		IO<= (others=>'0');
		ELSE 
		--IF (S="00") THEN
		--IO <= Q_inHOLD;
		--END IF;
		IF((OE_BAR(0)='0' and OE_BAR(1)='0') AND (S(1)='1' NAND S(0)='1')) THEN
			IO<=Q_in;
		END IF;
	
		
		IF((OE_BAR(0) = '0' nand OE_BAR(1)='0') OR (S(1) = '1' AND S(0) = '1')) THEN

			IO<= "ZZZZZZZZ";
		END IF;
		
		IF(OE_BAR(0) ='0' nand OE_BAR(1)='0') THEN 
			tmp <= '0';
		ELSE	
	 
			tmp <= '1';
		END IF;
		END IF;

	END PROCESS Process2;

END behavioral;

----testbench

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY cir_74AC299_tb IS
END cir_74AC299_tb;

ARCHITECTURE cir_74AC299_tb_a OF cir_74AC299_tb IS
	
	signal CPtb,MR_BARtb,DS0tb,DS7tb,Q0tb,Q7tb: std_logic:='0';
	signal Stb: std_logic_vector(1 downto 0);
	signal OE_BARtb: std_logic_vector(1 downto 0):="00";
	signal IOtb : std_logic_vector(7 downto 0);

component cir_74AC299 IS
	port(
	CP,MR_BAR,DS0,DS7 : IN std_logic;
	S : IN std_logic_vector(1 downto 0);
	OE_BAR : IN std_logic_vector(1 downto 0);
	IO : INOUT std_logic_vector(7 downto 0);
	Q0,Q7 : OUT std_logic
	);
END component;


BEGIN
	
	cir_74AC299_c : cir_74AC299 
	
	port map (CPtb,MR_BARtb,DS0tb,DS7tb ,Stb,OE_BARtb,IOtb,Q0tb,Q7tb);
	
	
	CPtb<=not(CPtb) after 10 ns;
	IOtb <= "10101010" when (Stb(0) ='1' and Stb(1) = '1' and OE_BARtb(0)='0' and OE_BARtb(1)='0')
	else(others => 'Z');
	DS0tb <= '0';
	DS7tb <= '1';
	
	MR_BARtb <= '1','0' after 500 ns;
	
	Stb <= "01","00" after 200 ns,"10" after 240 ns;

	OE_BARtb(0) <= not(OE_BARtb(0))after 100 ns;
	OE_BARtb(1) <= not(OE_BARtb(1))after 300 ns;
	
	
	
END cir_74AC299_tb_a ;



configuration cir_74AC299_cfg of cir_74AC299_tb IS
	for cir_74AC299_tb_a
		for cir_74AC299_c : cir_74AC299 
		use entity work.cir_74AC299(behavioral);
		end for;
	end for;
end configuration cir_74AC299_cfg;

