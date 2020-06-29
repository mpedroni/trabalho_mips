-- TOP MIPS TB monocycle
library ieee;
use ieee.std_logic_1164.all;

entity u_TOP_MIPS_TB is
end u_TOP_MIPS_TB;

architecture arch_1 of u_TOP_MIPS_TB is
component u_TOP_MIPS
port(
     i_CLK : in std_logic;
     i_RST : in std_logic
	  
);
end component;

constant clk_period : time := 10 ns;
signal w_CLK : std_logic := '0';
signal w_RESET : std_logic := '0';

begin

TOP : u_TOP_MIPS port map (
     i_CLK => w_CLK,
	  i_RST => w_RESET
);


process
begin 
w_RESET <= '0';
wait for clk_period;
w_RESET <= '1';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

w_CLK <= '1';
wait for clk_period;
w_CLK <= '0';
wait for clk_period;

end process;
end arch_1;