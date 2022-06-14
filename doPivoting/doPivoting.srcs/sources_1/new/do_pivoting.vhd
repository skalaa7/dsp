----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2022 04:14:27 PM
-- Design Name: 
-- Module Name: do_pivoting - Behavioral
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

entity divider_32 is
  Port (   dividend_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           dividend_tvalid: in STD_LOGIC;
           divisor_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           divisor_tvalid: in STD_LOGIC;
           clk : in STD_LOGIC;
           dout_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           dout_tvalid: out STD_LOGIC );
end divider_32;


architecture Behavioral of divider_32 is
component div_gen_0
    port(
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(55 DOWNTO 0));
end component;

SIGNAL dout_tdata_55: STD_LOGIC_VECTOR(55 DOWNTO 0);
begin
    div: div_gen_0
    port map(
        aclk => clk,
        s_axis_divisor_tvalid => divisor_tvalid,
        s_axis_divisor_tdata => divisor_tdata,
        s_axis_dividend_tvalid => dividend_tvalid,
        s_axis_dividend_tdata => dividend_tdata,
        m_axis_dout_tvalid => dout_tvalid,
        m_axis_dout_tdata => dout_tdata_55
    );
    dout_tdata <= dout_tdata_55(31 DOWNTO 0);
end Behavioral;
