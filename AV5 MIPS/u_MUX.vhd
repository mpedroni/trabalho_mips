library ieee;
use ieee.std_logic_1164.all;

entity u_MUX is -- mux teste
 port(
		i_s      : in std_logic;
		i_R_data : in  std_logic_vector (15 downto 0);
		i_ULA    : in  std_logic_vector (15 downto 0);
      o_W_data : out std_logic_vector (15 downto 0)
		);
end u_MUX;

architecture arch_1 of u_MUX is
begin 
	o_W_data <= i_R_data when i_s = '1' else i_ULA;
end arch_1;