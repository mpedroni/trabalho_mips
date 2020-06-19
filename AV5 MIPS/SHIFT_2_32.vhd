library ieee;
use ieee.std_logic_1164.all;

entity SHIFT_2_32 is 
port(
  i_A : in std_logic_vector(31 downto 0);
  o_R : out std_logic_vector(31 downto 0));
end entity;

architecture arch_1 of SHIFT_2_32 is 

begin 
  
  o_R(31 downto 2) <= i_A(29 downto 0);
  o_R(1 downto 0) <= "00";
  
end arch_1;