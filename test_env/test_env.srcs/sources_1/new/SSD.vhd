----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2024 04:30:16 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
  Port (cnt: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal cnt_SSD: std_logic_vector(16 downto 0);
signal digit: std_logic_vector(3 downto 0);

begin

process (cnt_SSD, cnt)
begin
   case cnt_SSD(16 downto 14) is
      when "000" => digit <= cnt(3 downto 0);
      when "001" => digit <= cnt(7 downto 4);
      when "010" => digit <= cnt(11 downto 8);
      when "011" => digit <= cnt(15 downto 12);
      when "100" => digit <= cnt(19 downto 16);
      when "101" => digit <= cnt(23 downto 20);
      when "110" => digit <= cnt(27 downto 24);
      when "111" => digit <= cnt(31 downto 28);
   end case;
end process;

process (cnt_SSD, cnt)
begin
   case cnt_SSD(16 downto 14) is
      when "000" => an <= "11111110";
      when "001" => an <= "11111101";
      when "010" => an <= "11111011";
      when "011" => an <= "11110111";
      when "100" => an <= "11101111";
      when "101" => an <= "11011111";
      when "110" => an <= "10111111";
      when "111" => an <= "01111111";
   end case;
end process;

process(clk)
    begin
    if rising_edge(clk) then
        cnt_SSD <= cnt_SSD + 1;
     end if;
end process;

with digit Select
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

end Behavioral;
