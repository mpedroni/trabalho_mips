library ieee;
use ieee.std_logic_1164.all;

entity CONC_28_32 is 
port(
  i_A : in std_logic_vector(27 downto 0); 
  i_B : in std_logic_vector(31 downto 0);
  o_R : out std_logic_vector(31 downto 0));
end entity;

architecture arch_1 of CONC_28_32 is 
begin
  
  o_R(27 downto 0) <= i_A;
  o_R(31 downto 28) <= i_B(31 downto 28);

end arch_1;