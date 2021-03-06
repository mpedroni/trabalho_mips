library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity DATAPATH_MIPS is
generic (p_SIZE : integer :=  32);
  port(
  i_CLK   	 : in  std_logic;
  i_RSTn   	 : in  std_logic;
  i_RegDst	 : in  std_logic;
  i_ALUSrc   : in  std_logic;
  i_MemtoReg : in  std_logic;
  i_RegWrite : in  std_logic;
  i_MemWrite : in  std_logic;
  i_Jump		 : in  std_logic;
  i_Branch	 : in  std_logic;
  i_ALU_OP   : in  std_logic_vector(1 downto 0);		
  o_OP		 : out std_logic_vector(5 downto 0));
end entity;

architecture arch_1 of DATAPATH_MIPS is

  component ADDER_32 is 
    generic(p_SIZE : integer := 32);
    port(
      i_A : in  std_logic_vector(p_SIZE-1 downto 0);
      i_B : in  std_logic_vector(p_SIZE-1 downto 0);
      o_R : out std_logic_vector(p_SIZE-1 downto 0));
  end component;
  
  component MUX_32 is 
    generic (p_SIZE : integer := 32);
    port(
      i_A   : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_B   : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_SEL : in  std_logic;
      o_R   : out std_logic_vector(p_SIZE - 1 downto 0));
  end component;
  
  component u_PC is 
    generic (p_SIZE : integer := 32);
    port (
      i_CLK    : in  std_logic;
      i_RSTn   : in  std_logic;
      i_PC     : in  std_logic_vector (p_SIZE-1 downto 0);
      o_PC     : out std_logic_vector (p_SIZE-1 downto 0));
  end component;
  
  component u_INSTRUCTION_MEMORY is 
    port(
      i_PC          : in  std_logic_vector (31 downto 0);
		i_CLK         : in  std_logic;
	   o_INSTRUCTION : out std_logic_vector (31 downto 0));
  end component;

  component BANK_REGISTER is 
    generic (p_SIZE    : integer := 32;
			    addr_SIZE : integer := 5);
    port (
      i_CLK       : in  std_logic;
      i_RSTn      : in  std_logic;
      i_WR        : in  std_logic;
      i_RD_ADDR_A : in  std_logic_vector(addr_SIZE - 1 downto 0);
      i_RD_ADDR_B : in  std_logic_vector(addr_SIZE - 1 downto 0);
      i_WR_ADDR   : in  std_logic_vector(addr_SIZE - 1 downto 0);
      i_DATA      : in  std_logic_vector(p_SIZE - 1 downto 0);
      o_RD_DATA_A : out std_logic_vector(p_SIZE - 1 downto 0);
      o_RD_DATA_B : out std_logic_vector(p_SIZE - 1 downto 0));
  end component;

  component ULA_MIPS is 
    generic(p_SIZE : integer := 32);
    port (
      i_A      : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_B      : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_ULA_OP : in  std_logic_vector(2 downto 0);
      o_R      : out std_logic_vector(p_SIZE - 1 downto 0);
      o_ZERO   : out std_logic);
  end component;  
  
  component ULA_OP is 
    port (
      i_ULA_OP   : in  std_logic_vector(1 downto 0);
      i_INSTRUCT : in  std_logic_vector(5 downto 0);
      o_ULA      : out std_logic_vector(2 downto 0));
  end component;
  
  component DATA_MEMORY is 
    generic(p_SIZE : integer := 32);
    port (
      i_DATA : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_ADDR : in  std_logic_vector(p_SIZE - 1 downto 0);
      i_CLK  : in  std_logic;
      i_WR   : in  std_logic;
      o_DATA : out std_logic_vector(p_SIZE - 1 downto 0));
  end component;
  
  component EXT_32 is 
    port(
      i_D : in  std_logic_vector(15 downto 0);
      o_D : out std_logic_vector(31 downto 0));
  end component;
  
  component SHIFT_2_32 is
    port(
      i_A : in  std_logic_vector(31 downto 0);
      o_R : out std_logic_vector(31 downto 0));
  end component;
  
  component SHIFT_2_26_28 is 
    port(
      i_A : in  std_logic_vector(25 downto 0);
      o_R : out std_logic_vector(27 downto 0));
  end component;
  
  component CONC_28_32 is 
    port(
      i_A : in  std_logic_vector(27 downto 0); 
      i_B : in  std_logic_vector(31 downto 0);
      o_R : out std_logic_vector(31 downto 0));
  end component;
  
  --component MUX_5 is 
  --  generic (p_SIZE : integer := 5);
  --  port(
  --    i_A   : in  std_logic_vector(p_SIZE - 1 downto 0);
  --    i_B   : in  std_logic_vector(p_SIZE - 1 downto 0);
  --    i_SEL : in  std_logic;
  --    o_R   : out std_logic_vector(p_SIZE - 1 downto 0));
  --end component;
	 
  signal w_PC_4_OUT       : std_logic_vector(31 downto 0);
  signal w_PC		        : std_logic_vector(31 downto 0);
  signal w_NEXT_PC        : std_logic_vector(31 downto 0);
  signal w_AND_OUT        : std_logic;
  signal w_ZERO_OUT       : std_logic;
  signal w_INSTRUCTION    : std_logic_vector(31 downto 0);
  signal w_OUT_MUX_5A     : std_logic_vector(4  downto 0);
  signal w_OUT_SIG		  : std_logic_vector(31 downto 0);
  signal w_OPERATION		  : std_logic_vector(2  downto 0);
  signal w_OUT_MUX_ALU    : std_logic_vector(31 downto 0);
  signal w_OUT_RD_A		  : std_logic_vector(31 downto 0);
  signal w_OUT_RD_B		  : std_logic_vector(31 downto 0);
  signal w_OUT_ALU_32	  : std_logic_vector(31 downto 0);
  signal w_OUT_SHIFT_32   : std_logic_vector(31 downto 0);
  signal w_OUT_ADDER 	  : std_logic_vector(31 downto 0);
  signal w_OUT_MUX_BRANCH : std_logic_vector(31 downto 0);
  signal w_OUT_SHIFT_28	  : std_logic_vector(27 downto 0);
  signal w_OUT_CONC		  : std_logic_vector(31 downto 0);
  signal w_OUT_DATAMEM	  : std_logic_vector(31 downto 0);
  signal w_OUT_MUX_DATA	  : std_logic_vector(31 downto 0);
  signal w_OPCODE		     : std_logic_vector(5  downto 0);
  signal w_RS    		     : std_logic_vector(4  downto 0);
  signal w_RT 			     : std_logic_vector(4  downto 0);
  signal w_RD 			     : std_logic_vector(4  downto 0);
  signal w_SHAMT 		     : std_logic_vector(4  downto 0);
  signal w_FUNCTION	     : std_logic_vector(5  downto 0);
  signal w_IMEDIATE	     : std_logic_vector(15 downto 0);
  signal w_IJUMP		     : std_logic_vector(25 downto 0);
	 
  begin 
  
  w_OPCODE     <= w_INSTRUCTION(31 downto 26);	
  w_RS    	  	<= w_INSTRUCTION(25 downto 21);
  w_RT 		 	<= w_INSTRUCTION(20 downto 16);
  w_RD 		 	<= w_INSTRUCTION(15 downto 11);
  w_SHAMT 	 	<= w_INSTRUCTION(10 downto  6);
  w_FUNCTION 	<= w_INSTRUCTION(5  downto  0);
  w_IMEDIATE 	<= w_INSTRUCTION(15 downto  0);
  w_IJUMP		<= w_INSTRUCTION(25 downto  0);
  
  w_PC_4_OUT   <= w_PC + x"00000004";
  w_AND_OUT    <= i_Branch AND w_ZERO_OUT;
  o_OP         <= w_OPCODE;
  
  u_PC1 : u_PC 
    generic map(
	   p_SIZE => 32
	 )
	 port map(
	   i_CLK  => i_CLK, 
	   i_RSTn => i_RSTn,
	   i_PC   => w_NEXT_PC,
	   o_PC   => w_PC);
		
  u_INSTRUCTION_MEMORY1 : u_INSTRUCTION_MEMORY
    port map(
	   i_PC          => w_PC,
		i_CLK         => i_CLK,
	   o_INSTRUCTION => w_INSTRUCTION);
  
  u_MUX_5 : MUX_32
    generic map(
	   p_SIZE => 5
	 )
	 port map(
	   i_A   => w_RT,
      i_B   => w_RD,
      i_SEL => i_RegDst,
      o_R   => w_OUT_MUX_5A);

  u_MUX_32_ULA : MUX_32
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_A   => w_OUT_RD_B,
      i_B   => w_OUT_SIG,
      i_SEL => i_ALUSrc,
      o_R   => w_OUT_MUX_ALU);
  
  u_MUX_32_B : MUX_32
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_A   => w_PC_4_OUT,
      i_B   => w_OUT_ADDER,
      i_SEL => w_AND_OUT,
      o_R   => w_OUT_MUX_BRANCH);
  
  u_MUX_32_J : MUX_32
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_A   => w_OUT_MUX_BRANCH,
      i_B   => w_OUT_CONC,
      i_SEL => i_Jump,
      o_R   => w_NEXT_PC); 

  u_MUX_32_D : MUX_32
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_A   => w_OUT_ALU_32,
      i_B   => w_OUT_DATAMEM,
      i_SEL => i_MemtoReg,
      o_R   => w_OUT_MUX_DATA);

  u_BANK_REGISTER : BANK_REGISTER
    port map(
	   i_CLK       => i_CLK,
	   i_RSTn      => i_RSTn, 
	   i_WR        => i_RegWrite,
	   i_RD_ADDR_A => w_RS,
	   i_RD_ADDR_B => w_RT,
	   i_WR_ADDR   => w_OUT_MUX_5A,
	   i_DATA      => w_OUT_MUX_DATA,
	   o_RD_DATA_A => w_OUT_RD_A,
	   o_RD_DATA_B => w_OUT_RD_B);

  u_ULA_OP : ULA_OP
    port map(
	   i_ULA_OP   => i_ALU_OP, 
	   i_INSTRUCT => w_FUNCTION,
	   o_ULA      => w_OPERATION);
  
  
  u_ULA_MIPS : ULA_MIPS
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_A      => w_OUT_RD_A,
	   i_B      => w_OUT_MUX_ALU,
	   i_ULA_OP => w_OPERATION,
	   o_R      => w_OUT_ALU_32,
	   o_ZERO   => w_ZERO_OUT);

  u_DATA_MEMORY : DATA_MEMORY
    generic map(
	   p_SIZE => 32
	 )
    port map(
	   i_DATA => w_OUT_RD_B,
	   i_ADDR => w_OUT_ALU_32,
	   i_CLK  => i_CLK,
	   i_WR   => i_MemWrite,
	   o_DATA => w_OUT_DATAMEM);
  
  u_EXT_32 : EXT_32
    port map(
	   i_D => w_IMEDIATE,
	   o_D => w_OUT_SIG);
		
  u_SHIFT_2_32 : SHIFT_2_32
    port map(
	   i_A => w_OUT_SIG, 
      o_R => w_OUT_SHIFT_32);
  
  u_SHIFT_2_26_28 : SHIFT_2_26_28 
    port map(
	   i_A => w_IJUMP,
	   o_R => w_OUT_SHIFT_28);
		
  u_CONC_28_32 : CONC_28_32
    port map(
	   i_A => w_OUT_SHIFT_28, 
	   i_B => w_PC_4_OUT,
	   o_R => w_OUT_CONC); 
end arch_1;