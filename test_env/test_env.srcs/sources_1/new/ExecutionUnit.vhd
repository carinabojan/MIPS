----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 04:24:40 PM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ExecutionUnit is
  Port ( Rd1: in std_logic_vector(31 downto 0);
  Rd2: in std_logic_vector(31 downto 0);
  AluSrc: in std_logic;
  Ext_imm: in std_logic_vector(31 downto 0);
  sa: in std_logic_vector(4 downto 0);
  func: in std_logic_vector(5 downto 0);
  AluOp: in std_logic_vector(5 downto 0);
  PC4: in std_logic_vector(31 downto 0);
  zero: out std_logic;
  gr: out std_logic;
  ls: out std_logic;
  AluRes: out std_logic_vector(31 downto 0);
  BranchAdress: out std_logic_vector(31 downto 0));
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal AluCtrl: std_logic_vector(2 downto 0);
signal AluResult: std_logic_vector(31 downto 0);
signal RD_2: std_logic_vector(31 downto 0);

begin

process(Rd1, Rd2, sa, AluCtrl)
begin

 case AluCtrl is
        when "000" => AluRes <= Rd1 + RD_2; --adunare
        when "001" => AluRes <=Rd1 - RD_2; --scadere
        when "010" => AluRes <= to_stdlogicvector(to_bitvector(Rd1) sll conv_integer(sa)); --shiftare stanga
        when "011" => AluRes <= to_stdlogicvector(to_bitvector(Rd1) srl conv_integer(sa)); --shiftare dreapta
        when "100" => AluRes <= Rd1 and RD_2;
        when "101" => AluRes <= Rd1 or RD_2;
        when "110" => AluRes <= Rd1(15 downto 0) * RD_2(15 downto 0);
        when "111" => AluRes <= std_logic_vector(to_signed(to_integer(signed(Rd1)/signed(RD_2)),32));
    end case;

end process;

process(func,AluOp)
begin
    case AluOp(5 downto 0) is 
        when "000000" =>
            case func is 
                when "000000" => AluCtrl <= "000";
                when "000001" => AluCtrl <= "001";
                when "000010" => AluCtrl <= "010";
                when "000011" => AluCtrl <= "011";
                when "000100" => AluCtrl <= "100";
                when "000101" => AluCtrl <= "101";
                when "000110" => AluCtrl <= "110";
                when "000111" => AluCtrl <= "111";
                when others => AluCtrl <= "000";
            end case;
        when "000001" => AluCtrl <= "000";
        when "000010" => AluCtrl <= "000";
        when "000011" => AluCtrl <= "000";
        when "000100" => AluCtrl <= "001";
        when "000101" => AluCtrl <= "000"; --bgez
        when "000110" => AluCtrl <= "000"; --bltz
        when "000111" => AluCtrl <= "000"; --jump
        when others => AluCtrl <= "000";
    end case;
end process;

process(ALUSrc,RD2,Ext_Imm)
begin
    case AluSrc is 
        when '0' => RD_2 <= Rd2;
        when '1' => RD_2 <= Ext_Imm;
    end case;
end process;

BranchAdress <= to_stdlogicvector(to_bitvector(RD1) sll conv_integer("10")) + PC4;
AluRes <= AluResult;

process(AluResult)
begin
    if AluResult > 0 then
        gr <= '1';
        ls <= '0';
        Zero <= '0';
    elsif AluResult < 0 then
        gr <= '0';
        ls <= '1';
        Zero <= '0';
    else
        gr <= '0';
        ls <= '0';
        Zero <= '1';
    end if;
end process;

end Behavioral;
