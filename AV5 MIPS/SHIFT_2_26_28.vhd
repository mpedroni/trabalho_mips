library ieee;
use ieee.std_logic_1164.all;

entity SHIFT_2_26_28 is 
port(
  i_A : in std_logic_vector(25 downto 0);
  o_R : out std_logic_vector(27 downto 0));
end entity;

architecture arch_1 of SHIFT_2_26_28 is 

begin 

  o_R(27 downto 2) <= i_A;
  o_R(1 downto 0) <= "00";
end arch_1;