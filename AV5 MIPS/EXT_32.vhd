library ieee;
use ieee.std_logic_1164.all;

entity EXT_32 is 
port(
  i_D : in std_logic_vector(15 downto 0);
  o_D : out std_logic_vector(31 downto 0));
end entity;

architecture arch_1 of EXT_32 is 
begin 
  o_D(31) <= i_D(15);
  o_D(14 downto 0) <= i_D(14 downto 0);
  o_D(30 downto 15) <= (others=>'0');
end arch_1;