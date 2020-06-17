-- Instruction Memory MIPS monocycle
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity u_INSTRUCTION_MEMORY is
port (
      i_PC          : in std_logic_vector (31 downto 0);
	   o_INSTRUCTION : out std_logic_vector (31 downto 0)
	  );
end u_INSTRUCTION_MEMORY;

architecture arch_1 of u_INSTRUCTION_MEMORY is

subtype word  is std_logic_vector (31 downto 0);
type ROM_type is array (0 to 7) of word;
constant rom_data: ROM_type:=(
   "00000010001100100100000000100000", -- add $t0, $s1, $s2
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000",
   "00000000000000000000000000000000"
	);
begin 

o_INSTRUCTION <= rom_data(to_integer(unsigned(i_PC))/4);

end arch_1;
