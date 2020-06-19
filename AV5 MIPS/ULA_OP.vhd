library ieee;
use ieee.std_logic_1164.all;

entity ULA_OP is 
port (
  i_ULA_OP   : in std_logic_vector(1 downto 0);
  i_INSTRUCT : in std_logic_vector(5 downto 0);
  o_ULA      : out std_logic_vector(2 downto 0));
end entity;

architecture arch_1 of ULA_OP is 
begin 

  o_ULA <= "010" when i_ULA_OP = "00" or (i_ULA_OP = "10" and i_INSTRUCT = "100000") else 
           "110" when i_ULA_OP = "01" or (i_ULA_OP(1) = '1' and i_INSTRUCT  = "100010") else 
			  "000" when (i_ULA_OP = "10" and i_INSTRUCT = "100100") else 
			  "001" when (i_ULA_OP = "10" and i_INSTRUCT = "100101") else
			  "111";
end arch_1;