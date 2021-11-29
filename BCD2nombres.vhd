LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY BCD_2nombres IS
Port (  CLK,CLR,Enable : IN std_logic; Carry : OUT std_logic; Unite,Dizaine : OUT std_logic_vector(3 downto 0));
END BCD_2nombres;

ARCHITECTURE BCDcount OF BCD_2nombres IS

BEGIN
	PROCESS (CLK,CLR,Enable)

	variable cnt,cnt1 : std_logic_vector(3 downto 0);

begin   



      if CLR='0' then
         cnt := "0000";
	 cnt1 := "0000";
	Carry <= '0';
      elsif(CLK'event and CLK='1') then
 	 if Enable='1' then
	    if (cnt="1001" and cnt1/="1001") then
	       cnt:="0000";
		cnt1 := cnt1 +1;
		else if (cnt = "1001" and cnt1 = "1001") then
		cnt := "0000";
		cnt1:= "0000";
		Carry <='1';
	    else
	       cnt := cnt + 1;
	    end if;
		
		end if;
         end if;
      end if;
Unite <= cnt;
Dizaine <= cnt1;
   end process;

END BCDcount;

--testbench
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY BCD_2nombres_tb IS
END BCD_2nombres_tb;

ARCHITECTURE BCD_2nombres_tb_a OF BCD_2nombres_tb IS
	
	signal CLKtb , CLRtb , Enabletb , Carrytb : std_logic:='0';
	signal Unitetb ,Dizainetb: std_logic_vector(3 downto 0);

component BCD_2nombres IS
	Port (  CLK,CLR,Enable : IN std_logic; Unite,Dizaine : OUT std_logic_vector(3 downto 0); Carry : OUT std_logic );
END component;


BEGIN
	
	CLKtb<=not(CLKtb) after 10 ns;
	BCD_2nombres_c : BCD_2nombres port map (CLKtb,CLRtb,Enabletb,Unitetb,Dizainetb,Carrytb);
	CLRtb <= '0','1' after 20 ns,'0' after 6100 ns;
	Enabletb <= '1' ,'0' after 1200 ns,'1' after 1600ns;
	
	


END BCD_2nombres_tb_a ;

--configuration

configuration BCD_2nombres_cfg of BCD_2nombres_tb IS
	for BCD_2nombres_tb_a
		for BCD_2nombres_c : BCD_2nombres
		use entity work.BCD_2nombres(BCDcount);
		end for;
	end for;
end configuration BCD_2nombres_cfg;