LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;	
use ieee.numeric_std.all;

------------------------------------------------------------
ENTITY fibonacci IS
GENERIC(DataWidth: integer);  
PORT (CLK, EN, INIT : IN std_logic;	
	N : IN std_logic_vector (7 downto 0);
	Sequence_Number : OUT std_logic_vector (DataWidth-1 downto 0);
	Overflow : OUT std_logic );
END fibonacci;
------------------------------------------------------------

ARCHITECTURE fibonacci OF fibonacci IS
SIGNAL a,b,c: std_logic_vector(DataWidth-1 downto 0);
SIGNAL cnt : std_logic_vector (7 downto 0);
BEGIN

PROCESS (CLK, EN, INIT, N, a, b, c, cnt)
variable tmp : std_logic :='0';
BEGIN

IF (INIT='1') THEN

b (DataWidth-1 downto 1) <= (others =>'0');
b(0) <= '1';
c <= (others =>'0');
a(DataWidth-1 downto 1) <= (others =>'0');
a(0) <= '1';
Overflow <='0';
cnt<= "00000001";
tmp :='0';

ELSIF (rising_edge(CLK) AND EN = '1') THEN


	cnt<= cnt +1;
	if(cnt < N and cnt > "00000010" ) Then	
	c <= b;
	b <= a;
	end if;

END IF;

			IF(cnt >= (N)AND cnt'EVENT) THEN
					tmp := '1';
			end if;
	IF(a<b AND a'EVENT) THEN
				Overflow <= '1';
			END IF;
a <= b + c;
			
Sequence_Number <= a;	
			
END PROCESS;

END fibonacci;

---------testbench
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;	
use ieee.numeric_std.all;

ENTITY fibonacci_tb IS


END fibonacci_tb;

ARCHITECTURE fibonacci_tb_a OF fibonacci_tb IS
	constant DataWidth :integer := 20; --Pour changer la valeur du DataWidth veuillez changer ici 

	signal CLKtb , ENtb , INITtb , Overflowtb : std_logic:='0';
	signal Sequence_Numbertb: std_logic_vector(DataWidth-1 downto 0);
	signal Ntb : std_logic_vector(7 downto 0);
component fibonacci IS
	Generic (DataWidth:integer);
	port(
	CLK,EN,INIT : IN std_logic;
	N : IN std_logic_vector(7 downto 0);
	Overflow : OUT std_logic;
	Sequence_Number : OUT std_logic_vector (DataWidth-1 downto 0)
	);
END component;


BEGIN
	
	fibonacci_c : fibonacci 
	Generic map(DataWidth => DataWidth)
	port map (CLKtb ,ENtb , INITtb, Ntb,  Overflowtb, Sequence_Numbertb);
	CLKtb<=not(CLKtb) after 10 ns;
	INITtb <= '1','0' after 15 ns,'1' after 620ns,'0' after 700 ns ;
	ENtb <= '1','0' after 5ns,'1' after 10ns;
	Ntb <=X"50";
END fibonacci_tb_a ;

------ configuration

configuration fibonacci_cfg of fibonacci_tb IS
	for fibonacci_tb_a
		for fibonacci_c : fibonacci 
		use entity work.fibonacci(fibonacci);
		end for;
	end for;
end configuration fibonacci_cfg;