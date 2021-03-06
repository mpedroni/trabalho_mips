library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity DATA_MEMORY is 
generic(p_SIZE : integer := 32);
port (
  i_DATA : in  std_logic_vector(p_SIZE - 1 downto 0); -- Dado
  i_ADDR : in  std_logic_vector(p_SIZE - 1 downto 0); -- Endereço
  i_CLK  : in  std_logic; -- Clock
  i_WR   : in  std_logic; -- Escreve dado
  o_DATA : out std_logic_vector(p_SIZE - 1 downto 0));
end entity;

architecture arch_1 of DATA_MEMORY is 

  type t_MEMORY is array(255 downto 0) of std_logic_vector(p_SIZE-1 downto 0);

  signal w_MEMORY : t_MEMORY := (others=>(others=>'0'));

  signal w_ADDR : std_logic_vector(7 downto 0);

begin 

  w_ADDR <= i_ADDR(7 downto 0);
    MEMORY_WR:process(i_CLK, i_WR)
	 begin 
	   if(rising_edge(i_CLK)) then 
		  if(i_WR = '1') then 
		    w_MEMORY(to_integer(unsigned(w_ADDR)/4)) <= i_DATA;
		  end if;
		end if;
    end process;
  o_DATA <= w_MEMORY(to_integer(unsigned(w_ADDR)/4));
end arch_1;