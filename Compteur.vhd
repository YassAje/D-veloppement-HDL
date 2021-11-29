LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY count1 IS
Port (  
  	clk,clear,up_down: IN std_logic;
	load : IN std_logic;
	load_data : IN std_logic_vector(7 downto 0):="01010100";
	load_data1 : IN integer range 0 to 255:= 84;
	qc1 : OUT integer range 0 to 255;
  	 qc : OUT std_logic_vector(7 downto 0)
 	);
 END count1;

ARCHITECTURE behavioral OF count1 IS

signal cnt : std_logic_vector(7 downto 0);
BEGIN
	PROCESS (clk,clear)
	
	VARIABLE cnt1 : INTEGER RANGE 0 TO 255;
	
	BEGIN

		--IF cnt <= "1111111" THEN
				--cnt <= "00000000";
				--END IF;

			--IF cnt1 = 255 THEN
				--cnt1=0;
			--END IF;
			---IF cnt1 = 0 THEN
				--cnt1:=255;
			--END IF;
	IF (clear='0') THEN
		--
		cnt<=(others=>'0');
		cnt1:= 0;
	ELSE IF (clear = '1' AND load='0') THEN
 	--	cnt <= (others => '0');

		cnt <= load_data; 
		cnt1:= load_data1;

		ELSE IF (clk'EVENT AND clk = '1') THEN
			
			IF (up_down ='1') THEN
			cnt <= cnt + "00000001"; 
			cnt1 := cnt1 + 1;
			IF cnt = "11111111" THEN
			cnt <= "00000000";
			END IF;
			IF cnt1 = 255 THEN
				cnt1:=0;
			END IF;
			

			ELSE 
			cnt <= cnt -"00000001";
			cnt1 := cnt1 - 1;
			IF cnt1 = 0 THEN
			cnt1:=255;		
			END IF;
			IF cnt <= "00000000" THEN
				cnt <= "11111111";
				END IF;
			
	END IF;
	END IF;
	END IF;
	END IF;
		
		
		qc<= cnt; 
		qc1<= cnt1;


		

	END PROCESS;
END behavioral;

--testbenh
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY count1_tb IS
END count1_tb;

ARCHITECTURE count1_tb_a OF count1_tb IS
	
	signal cleartb , clktb , loadtb,up_downtb : std_logic:='0';	
	signal qctb: std_logic_vector(7 downto 0);	
	signal qc1tb : integer range 0 to 255;

component count1 IS

	Port ( clk,clear: IN std_logic;
	        load,up_down : IN std_logic;
	        --load_data : IN std_logic_vector(7 downto 0);
	        qc : OUT std_logic_vector(7 downto 0);
	        qc1 : OUT integer range 0 to 255
 	);

end component;


begin
	count1_c : count1 port map (clk =>clktb, clear =>cleartb,load=> loadtb,up_down=>up_downtb,qc=>qctb, qc1=> qc1tb);	
	clktb<=not(clktb) after 10 ns;
	cleartb <= '1'	,'0' after 20 ns,'1' after 60ns ;
	loadtb <= '1', '0' after 300ns,'1' after 400ns;
	up_downtb <= '1', '0' after 8700ns;


	


end count1_tb_a ;

--configuration

configuration count1_cfg of count1_tb IS
	for count1_tb_a
		for count1_c : count1 
		use entity work.count1(behavioral);
		end for;
	end for;
end configuration count1_cfg;
------------------ Commentaire
-- j'ai essayé de rajouter une sortie vecteur(7 downto 0) afain de visualiser les résultats en binaire comme bonus
-- mais j'ai constaté un petit retard au niveau du sortie binaire 
-- j'ai pas arrivé a trouver une solution et donc j'ai compris que c'est lié à la nature des signaux et des variables
-- puisque un variable est instantanément affecté par la valeur alors qu'un signal devrait attendre la fin du processus pour recevoir la valeur