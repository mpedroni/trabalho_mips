-- TOP MIPS monocycle
library ieee;
use ieee.std_logic_1164.all;

entity u_TOP_MIPS is
generic (p_SIZE : integer := 32);
port(
     i_CLK : in std_logic;
     i_RST : in std_logic
);
  
end entity u_TOP_MIPS;

architecture arch_1 of u_TOP_MIPS is
signal w_OPERATION : std_logic_vector(5 downto 0);
signal w_ALUOp		 : std_logic_vector(1 downto 0);
signal w_REGDST	 : std_logic;
signal w_ALUSrc	 : std_logic;		
signal w_MemtoReg	 : std_logic;
signal w_RegWrite	 : std_logic;
signal w_MemWrite	 : std_logic;
signal w_Jump		 : std_logic;
signal w_Branch	 : std_logic;

begin
u_control: entity work.u_CONTROLLER -- Controle
  port map(
    i_OP		   => w_OPERATION,
    i_CLK	   => i_CLK,
    --1-Bit
    o_RegDst   => w_REGDST,
    o_ALUSrc   => w_ALUSrc,
    o_MemtoReg	=> w_MemtoReg,
    o_RegWrite	=> w_RegWrite,
    o_MemWrite => w_MemWrite,
    o_Jump		=> w_Jump,
    o_Branch	=> w_Branch,
    --2-Bits
    o_ALUOp		=> w_ALUOp	
  );
  
u_datapath: entity work.DATAPATH_MIPS -- Datapath
generic map(p_SIZE => 32)
  port map(
    i_CLK		=> i_CLK,
    i_RSTn		=> i_RST,
    --1-Bit
    i_RegDst	=> w_REGDST,	
    i_ALUSrc  	=> w_ALUSrc,
    i_MemtoReg	=> w_MemtoReg,
    i_RegWrite	=> w_RegWrite,
    i_MemWrite	=> w_MemWrite,
    i_Jump	   => w_Jump,
    i_Branch	=> w_Branch,
    --2-Bit
    i_ALU_OP		=> w_ALUOp,	
    --Output to control
    o_OP			=> w_OPERATION
  );
end arch_1;