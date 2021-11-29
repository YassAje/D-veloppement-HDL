LIBRARY IEEE;

USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY BCD_4nombres IS
Port (  
	CLK,CLR,Enable : IN std_logic;
	Unite,Dizaine,Centaine,millier : OUT std_logic_vector(3 downto 0);
	Carry : OUT std_logic
	);
END BCD_4nombres;

--compteur BCD 4nombres d'abord de BCD 2 nombres

ARCHITECTURE BCDcount OF BCD_4nombres IS
--begin   



  --    if CLR='0' then
    --     cnt := "0000";
--	 cnt1 := "0000";
--	Carry <= '0';
  --    elsif(CLK'event and CLK='1') then
-- 	 if Enable='1' then
	 --   if (cnt="1001" and cnt1/="1001") then
	  --     cnt:="0000";
--		cnt1 := cnt1 +1;
	--	else if (cnt = "1001" and cnt1 = "1001") then
	--	cnt := "0000";
	--	cnt1:= "0000";
	--	Carry <='1';
	--    else
	--       cnt := cnt + 1;
	--    end if;
	---	
	--	end if;
--         end if;
 --     end if;
--Unite <= cnt;
--Dizaine <= cnt1;
 --  end process;
component BCD_2nombres IS
	Port (  
	CLK,CLR,Enable : IN std_logic;
	Unite,Dizaine : OUT std_logic_vector(3 downto 0);
	Carry : OUT std_logic
	);
END component;
	
SIGNAL	Carry_U1,Enable_U2,CLR_U1 : STD_LOGIC;
SIGNAL	Centaine_dectect : std_logic_vector(3 downto 0);
--signal cnt : std_logic_vector (3 downto 0);


BEGIN
	U1 : BCD_2nombres PORT MAP(	CLK => CLK, CLR => CLR_U1, Enable => Enable, Unite => Unite, Dizaine => Dizaine, Carry => Carry_U1 );
	
	U2 : BCD_2nombres PORT MAP(	CLK => CLK, CLR => CLR, Enable => Enable_U2, Unite => Centaine_dectect, Dizaine => millier, Carry => Carry );


	
	
	PROCESS (Carry_U1,Enable_U2,Centaine_dectect,CLR_U1,CLR)
	
	--variable cnt,cnt2 : std_logic_vector(3 downto 0);
	BEGIN

	
				IF(CLR ='0') THEN
					CLR_U1 <= '0';
					Enable_U2 <= '0';
				ELSE
				
					IF (Carry_U1 = '1' AND Carry_U1'EVENT) THEN
						Enable_U2 <= '1';
						CLR_U1 <= '0';
					END IF;
					IF (Carry_U1 = '0') THEN
						CLR_U1 <= '1';
					END IF;
					
					IF (Centaine_dectect'EVENT) THEN
						Enable_U2 <= '0';					
					END IF;
					
				END IF;
				--IF ( cnt = "1001" ) then
					--cnt <= (others => '0');
			--	END IF;
				Centaine <= Centaine_dectect;
				--millier <= cnt;

	END PROCESS;
END BCDcount;
--testbenh
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY BCD_4nombres_tb IS
END BCD_4nombres_tb;

ARCHITECTURE BCD_4nombres_tb_a OF BCD_4nombres_tb IS
	
	signal CLKtb , CLRtb , Enabletb , Carrytb : std_logic:='0';
	signal Unitetb ,Dizainetb,Centainetb,milliertb: std_logic_vector(3 downto 0);

component BCD_4nombres IS
	Port ( 
	CLK,CLR,Enable : IN std_logic;
	Unite,Dizaine,Centaine,millier : OUT std_logic_vector(3 downto 0);
	Carry : OUT std_logic
	);
END component;


BEGIN
	
	BCD_4nombres_c : BCD_4nombres port map (CLKtb,CLRtb,Enabletb,Unitetb,Dizainetb,Centainetb,milliertb,Carrytb);
	CLRtb <= '0','1' after 5 ns;
	Enabletb <= '1';
	CLKtb<=not(CLKtb) after 10 ns;
	


END BCD_4nombres_tb_a ;

--configuration

configuration BCD_4nombres_cfg of BCD_4nombres_tb IS
	for BCD_4nombres_tb_a
		for BCD_4nombres_c : BCD_4nombres 
		use entity work.BCD_4nombres(BCDcount);
		end for;
	end for;
end configuration BCD_4nombres_cfg;