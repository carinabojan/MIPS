----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 04:38:36 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
port(clk : in STD_LOGIC;
           en : out STD_LOGIC;
           input: in STD_LOGIC);
end component;

component SSD is
 Port (cnt: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0));
end component;

component reg_file is
    port ( clk : in std_logic;
    ra1 : in std_logic_vector(4 downto 0);
    ra2 : in std_logic_vector(4 downto 0);
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    regwr : in std_logic;
    rd1 : out std_logic_vector(31 downto 0);
    rd2 : out std_logic_vector(31 downto 0));
end component;

component ram_wr_1st is
    port ( clk : in std_logic;
        we : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(31 downto 0);
        di : in std_logic_vector(31 downto 0);
        do : out std_logic_vector(31 downto 0);
        ALUResout: out std_logic_vector(31 downto 0));
end component;

component InstructionFetch is
  Port ( PcSrc: in std_logic;
        Jmp: in std_logic;
        BrAddr: in std_logic_vector(31 downto 0);
        JmpAddr: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        Instr: out std_logic_vector(31 downto 0);
        Pc4: out std_logic_vector(31 downto 0);
        en: in std_logic
        );
end component;

component Instruction_Decoder is
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
end component;

component ExecutionUnit is
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
end component;

signal func: STD_LOGIC_VECTOR(5 downto 0);
signal cnt: STD_LOGIC_VECTOR(5 downto 0);
signal sa: STD_LOGIC_VECTOR(4 downto 0);
signal en1: std_logic;
signal en2: std_logic;
signal regwr: std_logic;
signal regdst: std_logic;
signal extOp: std_logic;
signal digits: std_logic_vector(31 downto 0);
signal wd: std_logic_vector(31 downto 0);
signal ext_imm: std_logic_vector(31 downto 0);
signal rd1 : std_logic_vector(31 downto 0);
signal rd2 : std_logic_vector(31 downto 0);
signal do : std_logic_vector(31 downto 0);
signal instr: std_logic_vector(31 downto 0);
signal Pc4: std_logic_vector(31 downto 0);
signal PcSrc: std_logic;
signal Jump: std_logic;
signal ALUSrc: std_logic;
signal ALULs: std_logic;
signal ALUZero: std_logic;
signal ALUGr: std_logic;
signal ALURes: std_logic_vector(31 downto 0);
signal BrAddr: std_logic_vector(31 downto 0);
signal JumpAddr: std_logic_vector(31 downto 0);
signal MemWr: std_logic;
signal MemData: std_logic_vector(31 downto 0);
signal AluRo: std_logic_vector(31 downto 0);
signal PcSrcAct: std_logic;
signal MemToReg: std_logic;   
signal bgez: std_logic; 
signal bltz: std_logic;

--Semnale pipeline
signal PC4RegOut: std_logic_vector(31 downto 0);
signal instrReg: std_logic_vector(31 downto 0);

-- Semnale reg 2
signal rd1Reg: std_logic_vector(31 downto 0);
signal rd2Reg: std_logic_vector(31 downto 0);
signal ext_immReg: std_logic_vector(31 downto 0);
signal saReg: STD_LOGIC_VECTOR(4 downto 0);
signal funcReg: STD_LOGIC_VECTOR(5 downto 0);
signal rtReg: std_logic_vector(4 downto 0);
signal rdReg: std_logic_vector(4 downto 0);
signal jmpReg2: std_logic;
signal memReg2: std_logic;
signal WrReg2: std_logic;
signal memWrReg2: std_logic;
signal BrReg2: std_logic;
signal AluOpReg2: std_logic_vector(5 downto 0);
signal AluSrcReg2: std_logic;
signal RegDstReg2: std_logic;
signal BgezReg2: std_logic;
signal BltzReg2: std_logic;

-- Semnale reg 3
signal memReg3: std_logic;
signal WrReg3: std_logic;
signal memWrReg3: std_logic;
signal BrReg3: std_logic;
signal ALULs3: std_logic;
signal ALUZero3: std_logic;
signal ALUGr3: std_logic;
signal RegDstReg3: std_logic;
signal BrAddrReg3: std_logic_vector(31 downto 0);
signal ALUResReg3: std_logic_vector(31 downto 0);
signal rd2Reg3: std_logic_vector(31 downto 0);
signal BgezReg3: std_logic;
signal BltzReg3: std_logic;
signal muxRegdst: std_logic_vector(4 downto 0);


-- Semnale reg 4
signal wbReg4: std_logic;
signal regWrReg4: std_logic;
signal MemDataReg4: std_logic_vector(31 downto 0);
signal ALUResultReg4: std_logic_vector(31 downto 0);
signal WriteAddressReg4: std_logic_vector(4 downto 0);

begin

U2: SSD port map(digits, clk, an, cat);
U1: MPG port map(clk, en1, btn(0));
--U3: MPG port map(clk, en2, btn(1));
U6: InstructionFetch port map(PcSrcAct, Jump, BrAddr, JumpAddr, clk, instr, Pc4, en1);
U7: Instruction_Decoder port map(instrReg, wd, rd1, rd2, funcReg, saReg, ext_immReg, clk, regWrReg4 , regdstreg2, extOp, WriteAddressReg4);
U8: ExecutionUnit port map(rd1Reg, rd2Reg, ALUSrcReg2, ext_immReg, saReg, funcReg, AluOpReg2, Pc4RegOut, ALUZero, ALUGr, ALULs, ALUResReg3, BrAddr);
U9: ram_wr_1st port map(clk, memWrReg3,'1', ALUResReg3 , rd2Reg3, MemData,  AluRo);

process(clk)
begin
    if rising_edge(clk)then
        if en2 = '1' then
            PC4RegOut <= PC4;
            instrReg <= instr;
        end if;
    end if;
end process;

process(rtReg, rdReg, regdstreg2)
begin
    if regdstreg2 = '0' then
        muxregdst <= rtReg;
    else
        muxregdst <= rdReg;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk)then
        if en1 = '1' then
            rd1Reg <= rd1;
            rd2Reg <= rd2;
            ext_immReg <= ext_imm;
            saReg <= sa;
            rtReg <= instrReg(20 downto 16);
            rdReg <= instrReg(15 downto 11);
            jmpReg2 <= Jump;
            memReg2 <= memtoreg;
            wrReg2 <= regwr;
            memWrReg2 <= MemWr;
            BrReg2 <= PcSrc;
            AluOpReg2 <= instrReg(31 downto 26);
            AluSrcReg2 <= AluSrc;
            RegDstReg2 <= regdst;
            BgezReg2 <= bgez;
            BltzReg2 <= bltz;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk)then
        if en1 = '1' then
            memReg3 <= memReg2;
            wrReg3 <= wrReg2;
            memWrReg3 <= memWrReg2;
            BrReg3 <= BrReg2;
            RegDstReg3 <= RegDstReg2;
            BgezReg3 <= BgezReg2;
            BltzReg3 <= BltzReg2;
            ALULs3 <= aluls;
            ALUZero3 <= aluzero;
            ALUGr3 <= alugr;
            BrAddrReg3 <= BrAddr;
            rd2Reg3 <= rd2Reg;
        end if;
    end if;
end process;

process(clk)
begin

    if rising_edge(clk)then
        if en1 = '1' then
            wbReg4 <= memReg3;
            regWrReg4 <= wrReg3;
            MemDataReg4 <= MemData;
            ALUResultReg4 <= AluResReg3;
            WriteAddressReg4 <= muxRegdst;
        end if;
    end if;

end process;

process(MemToReg,MemData,ALURes)
begin
    case  wbReg4 is
        when '0' => wd <= ALUResultReg4;
        when others => wd <= MemDataReg4;
    end case;
end process;

process(clk)
    begin
    if rising_edge(clk) then
        if en1 = '1' then
            if sw(0) = '1' then
                cnt <= cnt + 1;
            else
                cnt <= cnt - 1;
            end if;
       end if;
    end if;
end process;

process(instr, Pc4, sw, ext_imm, rd1, rd2)
begin
    case sw(15 downto 13) is
        when "000" => digits <= instr;
        when "001" => digits <=rd1;
        when "010" => digits <=rd2;
        when "011" => digits <=ext_imm;
        when "100" => digits <=Pc4;
        when "101" => digits <= AluRes;
        when "110" => digits <= MemData;
        when others => digits <= x"00000000";
    end case;
end process;

JumpAddr <= PC4(31 downto 28) & instr(25 downto 0) & "00";
PcSrcAct <= (BrReg3 and AluZero3) or (bgezreg3 and Alugr3) or (bltzreg3 and aluls3);

process(instr)
begin
    case instr(31 downto 26) is
        when "000000" => PcSrc <= '0'; --tip R
                         Jump <= '0';
                         regdst <= '1';
                         regwr <= '1';
                         extOp <= '0';
                         AluSrc <= '0';
                         extop <= '0';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
            
        when "000001" => PcSrc <= '0'; -- addi
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '1';
                         extOp <= '1';
                         AluSrc <= '1';
                         extop <= '1';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
                         
        when "000010" => PcSrc <= '0'; --lw
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '1';
                         extOp <= '1';
                         AluSrc <= '1';
                         extop <= '1';
                         memwr <= '1';
                         memtoreg <= '1';
                         bgez <= '0';
                         bltz <= '0';
                         
        when "000011" => PcSrc <= '0'; --sw
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '1';
                         extOp <= '1';
                         AluSrc <= '1';
                         memwr <= '1';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
                         
        when "000100" => PcSrc <= '1'; --beq
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '0';
                         extOp <= '1';
                         AluSrc <= '1';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
        
        when "000101" => PcSrc <= '0'; --bgez
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '0';
                         extOp <= '1';
                         AluSrc <= '1';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '1';
                         bltz <= '0';
                         
        when "000110" => PcSrc <= '0'; --bltz
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '0';
                         extOp <= '1';
                         AluSrc <= '1';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '1';
                         
        when "000111" => PcSrc <= '0'; --jmp
                         Jump <= '1';
                         regdst <= '0';
                         regwr <= '0';
                         extOp <= '0';
                         AluSrc <= '1';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
                         
        when others => PcSrc <= '0';
                         Jump <= '0';
                         regdst <= '0';
                         regwr <= '0';
                         extOp <= '0';
                         AluSrc <= '0';
                         memwr <= '0';
                         memtoreg <= '0';
                         bgez <= '0';
                         bltz <= '0';
        end case;

end process;

end Behavioral;
