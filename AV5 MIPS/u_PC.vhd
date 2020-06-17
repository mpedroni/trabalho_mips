-- PC MIPS monocycle
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity u_PC is
generic (p_SIZE : integer := 32);
port (
      i_CLK    : in  std_logic;
		i_RSTn   : in  std_logic;
		i_PC     : in  std_logic_vector (p_SIZE-1 downto 0);
	   o_PC     : out std_logic_vector (p_SIZE-1 downto 0));
end u_PC;

architecture arch_1 of u_PC is
signal w_PC : std_logic_vector(p_SIZE-1 downto 0):=(others=>'0');
begin
    -- Definindo se a saída do pc vai receber a instrução ou não		
    setPC:process(i_CLK, i_RSTn)
    begin
      if(i_RSTn = '0') then
		  w_PC <= (others=>'0');
		elsif(rising_edge(i_CLK)) then 
		  w_PC <= i_PC;
		end if;
    end process setPC;
	 o_PC <= w_PC;
end arch_1;
		