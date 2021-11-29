library IEEE;
use ieee.std_logic_1164.all;
entity reso is
end entity reso ;
architecture bench of reso is
-- 1er cas: compilation et simulation avec un type résolu (std_logic)
--signal f0,f2,f4,f8 : std_logic:='0';
--signal S1,S2,sortie : std_logic;
-- 2éme cas: compilation et simulation avec un type NON résolu (std_ulogic)
signal f0,f2,f4,f8 : std_ulogic;
signal S1,S2,sortie : std_ulogic;
begin
-- génération des signaux
f0<=not(f0) after 10 ns;
f2<=not(f2) after 20 ns; f4<=not(f4) after 40 ns; f8<=not(f8) after 80 ns;
-- fonctions logiques
S1<= f0 or f2; S2<= f4 or f8;
sortie<= f0 or f2;
sortie<= f4 or f8;
end bench ;