-- PC MIPS monocycle
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity u_PC is
port (
      i_CLK    : in std_logic;
		i_RESET  : in std_logic;
		i_PC_IN  : in std_logic_vector (31 downto 0);
	   o_PC_OUT : out std_logic_vector (31 downto 0)
	  );
end u_PC;

architecture arch_1 of u_PC is
    signal w_PC_RESET : std_logic;
begin
    -- Definindo se a saída do pc vai receber a instrução ou não
    setPC:process(i_CLK)
    begin
	     if (rising_edge(i_CLK)) then
		      if (w_PC_RESET='1') then
				    o_PC_OUT <= (others => '0');
				else
				    o_PC_OUT <= i_PC_IN;
				end if;
			end if;
		end process setPC;
	-- Definindo a saída do w_PC_RESET, se vai resetar ou não
	resetPC:process(i_RESET, i_CLK)
	begin 
	    if (i_RESET='1') then
		     w_PC_RESET<='1';
	    elsif ((rising_edge(i_CLK)) and (i_RESET='0')) then
		     w_PC_RESET<='0';
		 end if;
	end process resetPC;
end arch_1;
		