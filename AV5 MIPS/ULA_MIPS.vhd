library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ULA_MIPS is
generic(p_SIZE : integer := 32);
port (
  i_A      : in  std_logic_vector(p_SIZE - 1 downto 0);
  i_B      : in  std_logic_vector(p_SIZE - 1 downto 0);
  i_ULA_OP : in  std_logic_vector(2 downto 0);
  o_R      : out std_logic_vector(p_SIZE - 1 downto 0);
  o_ZERO   : out std_logic);
end entity;

architecture arch_1 of ULA_MIPS is 

signal w_ULA_OUT : std_logic_vector(p_SIZE - 1 downto 0);
begin 

  ULA_OP:process(i_A, i_B, i_ULA_OP)
  begin 
    case i_ULA_OP is 
	   when "000" => 
		  w_ULA_OUT <= i_A and i_B;
		  
		when "001" => 
		  w_ULA_OUT <= i_A or i_B;
		
		when "010" =>
		  w_ULA_OUT <= i_A + i_B;
		
		when "110" =>
	     w_ULA_OUT <= i_A - i_B;
		
	   when others =>
	     w_ULA_OUT <= (others=>'0');
    
	 end case;
  end process;

o_R <= w_ULA_OUT;
o_ZERO <= '1' when w_ULA_OUT = x"00000000" else '0';
end arch_1;