library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity u_CONTROLLER is
port(
     i_CLK            :  in std_logic; -- Clock
	  i_RST            :  in std_logic; -- Reset
     i_IR             :  in std_logic_vector(7 downto 0); -- Instrução (31-26)
);
end u_CONTROLLER;