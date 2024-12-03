----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2024 04:25:57 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
  Port ( PcSrc: in std_logic;
        Jmp: in std_logic;
        BrAddr: in std_logic_vector(31 downto 0);
        JmpAddr: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        Instr: out std_logic_vector(31 downto 0);
        Pc4: out std_logic_vector(31 downto 0);
        en: in std_logic
        );
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal PC: std_logic_vector(31 downto 0);
signal Addr: std_logic_vector(31 downto 0);
signal muxBranch: std_logic_vector(31 downto 0);
signal muxJump: std_logic_vector(31 downto 0);

type ROM is array(0 to 63) of std_logic_vector(31 downto 0);
signal ROM_mem: ROM :=(
    b"000001_00000_00001_0000000000000000", -- addi $1 $0 0, s<-0 initializam o variabila de sum cu 0
    b"000001_00000_00010_0000000000010100", -- addi $2 $0 20, initializam pe i cu 20
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000110_00000_00010_0000000000000110", -- bltz $2 6, if i < 0 pt un for care se executa descrescator
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00001_00010_00001_00000_000000", -- add $1 $1 $2, echivalent cu s<-s+i se face suma
    b"000001_00010_00010_1111111111111111", -- addi $2 $2 -1, echivalent cu i--
    b"000111_00000000000000000000000100", --j 4 se intoarce iar in for
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000001_00000_00001_0000000000000000", -- addi $4 $0 20
    b"000110_00001_00000_0000000000000110", --bltz $1 6 if s >=0 dar aici verificam condittia inversa iar daca nu e indeplinita se face jump
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00001_00100_00001_00000_000000", -- s<- s - 20, 20 este stocat in reg 4
    b"000111_00000000000000000000010101", --j 21 se sare peste instructiune pana la else in cazul in care nu e corect
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00001_00001_00001_00000_000110", --mult $1 $1 $1 s<-s*s
    b"000001_00000_00011_0000000000000101", --addi $3 $0 5 d<-5
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00000_00000_0000000000000000", -- noOp
    b"000000_00001_00011_00111_00000_000111", --div $1 $1 $3 s<-s/5
    others => x"00000000"
    );

begin

process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
             Addr <= PC;
        end if;
    end if;
end process;

process(PcSrc,BrAddr,muxBranch)
begin

if PcSrc = '1' then
    muxJump <= BrAddr;
else
    muxJump <= muxBranch;
end if;

end process;

process(Jmp,JmpAddr,muxJump)
begin

if Jmp = '1' then
    PC <= JmpAddr;
else
    PC <= muxJump;
end if;

end process;

muxBranch <= Addr + 4;
PC4 <= muxBranch;
Instr <= ROM_mem(conv_integer(Addr(7 downto 2)));

end Behavioral;
