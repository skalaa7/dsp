----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2022 05:41:21 PM
-- Design Name: 
-- Module Name: dsp_tb - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsp_tb is
--  Port ( );
end dsp_tb;

architecture Behavioral of dsp_tb is
  component dsp is
  generic (WIDTHA:natural:=32;
          WIDTHB:natural:=32;
          SIGNED_UNSIGNED: string:= "signed");
 Port ( clk: in std_logic;
        a_i: in std_logic_vector (31 downto 0);
        b_i: in std_logic_vector (31 downto 0);
        c_i: in std_logic_vector (31 downto 0);
        mult_o: out std_logic_vector(31 downto 0);
        res_o: out std_logic_vector(31 downto 0));
end component dsp;

signal clk: std_logic;
signal a_i_s, b_i_s,c_i_s: std_logic_vector(31 downto 0);
signal res_o_s: std_logic_vector(31 downto 0);
signal mult_s: std_logic_vector(31 downto 0);
begin

        duv: dsp
        generic map(
        WIDTHA => 32,
        WIDTHB => 32,
        SIGNED_UNSIGNED => "signed"
        ) 
        port map(
            a_i => a_i_s,
            b_i => b_i_s,
            clk => clk,
            c_i => c_i_s,
            mult_o=>mult_s,
            res_o => res_o_s
        );

clk_gen: process
    begin
        clk <= '0', '1' after 10ns;
        wait for 20ns;
    end process;
    
 stim_gen: process
    begin
        a_i_s <=std_logic_vector(to_signed(-32,11))& "000000000000000000000",std_logic_vector(to_signed(32,11))& "000000000000000000000" after 20ns,std_logic_vector(to_signed(-2,32)) after 40ns,std_logic_vector(to_signed(8,32))after 60ns,std_logic_vector(to_signed(5,32)) after 80ns,std_logic_vector(to_signed(1,32)) after 100ns,x"FFBFFFFF" after 120ns;
        b_i_s <=std_logic_vector(to_signed(-32,11))& "000000000000000000000",std_logic_vector(to_signed(32,11))& "000000000000000000000" after 20ns,std_logic_vector(to_signed(3,32)) after 40ns,std_logic_vector(to_signed(8,32))after 60ns,std_logic_vector(to_signed(1,32)) after 80ns,std_logic_vector(to_signed(-3,32)) after 100ns,x"FFBFFFFF" after 120ns;
        c_i_s <=std_logic_vector(to_signed(1,11))& "000000000000000000000",std_logic_vector(to_signed(1,11))& "000000000000000000000" after 20ns,std_logic_vector(to_signed(100,32)) after 40ns,std_logic_vector(to_signed(64,32))after 60ns,std_logic_vector(to_signed(2,32)) after 80ns,std_logic_vector(to_signed(-3,32)) after 100ns,x"FFBFFFFF" after 120ns;
               -- 0 1 106  0   1 0
    wait;
    end process;
     
end Behavioral;
