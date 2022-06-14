----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2022 04:33:19 PM
-- Design Name: 
-- Module Name: dopivoting_tb - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
entity dopivoting_tb is
--  Port ( );
end dopivoting_tb;

architecture Behavioral of dopivoting_tb is
component divider_32 is
   Port (   dividend_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           dividend_tvalid: in STD_LOGIC;
           divisor_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           divisor_tvalid: in STD_LOGIC;
           clk : in STD_LOGIC;
           dout_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           dout_tvalid: out STD_LOGIC );
end component divider_32;

signal a_in_s, b_in_s:  STD_LOGIC_VECTOR (31 downto 0);
signal c_out_s: STD_LOGIC_VECTOR (31 downto 0);--ovde
signal clk: std_logic;
signal valid_a, valid_b: std_logic;
signal valid_out: std_logic;
begin
    duv: divider_32
        port map(
            dividend_tdata => a_in_s,
            divisor_tdata => b_in_s,
            clk => clk,
            dout_tdata => c_out_s,
            dividend_tvalid => valid_a,
            divisor_tvalid => valid_b,
            dout_tvalid => valid_out
        );
    
    
    clk_gen: process
    begin
        clk <= '0', '1' after 10ns;
        wait for 20ns;
    end process;
   
    stim_gen: process
    begin
        valid_a <= '1';
        valid_b<= '1';
        a_in_s <=std_logic_vector(to_signed(34,32)),std_logic_vector(to_signed(16,32)) after 20ns,std_logic_vector(to_signed(-4,32)) after 30ns ;
        b_in_s <=std_logic_vector(to_signed(17,32)),std_logic_vector(to_signed(4,32)) after 20ns,std_logic_vector(to_signed(2,32)) after 30ns ;
                    
    wait for 1000us;
    end process;
end Behavioral;
