-- Instruction Memory MIPS monocycle
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity u_INSTRUCTION_MEMORY is
  port(
    i_PC          : in  std_logic_vector (31 downto 0);
	 i_CLK         : in  std_logic;
	 o_INSTRUCTION : out std_logic_vector (31 downto 0));
end u_INSTRUCTION_MEMORY;

architecture arch_1 of u_INSTRUCTION_MEMORY is

subtype word  is std_logic_vector (31 downto 0);
type ROM_type is array (0 to 7) of word;
signal rom_data: ROM_type:=(
	"00100000000100000000000000000000",
   "00100000000100010000000000000001",
   "00100000000100100000000000000010",
   "00100000000100110000000000000011",
   "00100000000101000000000000000100",
   "00010010011101000000000000000001",
   "00000010001100101000000000100000",
   "00000010000100111000000000100010"
	);
signal w_PC : std_logic_vector (7 downto 0);
begin 
w_PC <= i_PC(7 downto 0);
  process(i_CLK)
  begin 
    if(rising_edge(i_CLK)) then
      o_INSTRUCTION <= rom_data(to_integer(unsigned(w_PC))/4);
    end if;
  end process;
end arch_1;
