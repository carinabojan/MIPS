library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ram_wr_1st is
    port ( clk : in std_logic;
        we : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(31 downto 0);
        di : in std_logic_vector(31 downto 0);
        do : out std_logic_vector(31 downto 0);
        ALUResout: out std_logic_vector(31 downto 0));
    end ram_wr_1st ;
architecture Behavioral of ram_wr_1st is
    type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (
    others => X"00000000");
begin
process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            if we = '1' then
                ram(conv_integer(addr(5 downto 0))) <= di;
                do <= di;
            else
                do <= ram(conv_integer(addr(5 downto 0)));
        end if;
    end if;
end if;
end process;

ALUResout <= addr;

end Behavioral;