----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2024 04:19:09 PM
-- Design Name: 
-- Module Name: Instruction_Decoder - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Decoder is
  Port (Instr: in std_logic_vector(31 downto 0);
        wd: in std_logic_vector(31 downto 0);
        rd1: out std_logic_vector(31 downto 0);
        rd2: out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0);
        ext_imm: out std_logic_vector(31 downto 0);
        clk: in std_logic;
        regwr: in std_logic;
        regdst: in std_logic;
        extOp: in std_logic;
        wa: in std_logic_vector(4 downto 0));
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is

component reg_file is
    port ( clk : in std_logic;
    ra1 : in std_logic_vector(4 downto 0);
    ra2 : in std_logic_vector(4 downto 0);
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    regwr : in std_logic;
    rd1 : out std_logic_vector(31 downto 0);
    rd2 : out std_logic_vector(31 downto 0)
    );
end component;

signal outmux: std_logic_vector(4 downto 0);

begin

U1: reg_file port map(clk, Instr(25 downto 21), Instr(20 downto 16), outmux, wd, regwr, rd1, rd2);

process(Instr, extOp)
begin
    if extOp = '0' then
        ext_imm <= x"0000" & Instr(15 downto 0);
    else
        if Instr(15) = '1' then
            ext_imm <= x"1111" & Instr(15 downto 0);
        else
            ext_imm <= x"0000" & Instr(15 downto 0);
        end if;
    end if;
end process;

func <= Instr(5 downto 0);
sa <= Instr(10 downto 6);

end Behavioral;
