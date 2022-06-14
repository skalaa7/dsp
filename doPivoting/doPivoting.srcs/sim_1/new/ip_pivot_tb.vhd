----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2022 08:25:40 AM
-- Design Name: 
-- Module Name: ip_pivot_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity ip_pivot_tb is
--  Port ( );
end ip_pivot_tb;


architecture Behavioral of ip_pivot_tb is
component ip_pivot
 generic (COLSIZE: integer := 101;
          ROWSIZE: integer := 51);
    Port ( clk : in STD_LOGIC;
           reset: in STD_LOGIC;
           --FIRST MEMORY PORT
           data1_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           address1 : out STD_LOGIC_VECTOR(12 DOWNTO 0);
           data1_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           en1_out : out STD_LOGIC;
           we1 : out STD_LOGIC;
           --SECOND MEMORY PORT
           data2_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           address2 : out STD_LOGIC_VECTOR(12 DOWNTO 0);
           data2_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           en2_out : out STD_LOGIC;
           we2 : out STD_LOGIC;
           
           start : in STD_LOGIC;
           ready: out STD_LOGIC
           );
  end component;

--block ram
component blk_mem_gen_0
PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

--singnals for bram 
signal    clka_s : STD_LOGIC;
signal    ena_s :  STD_LOGIC;
signal    wea_s :  STD_LOGIC_VECTOR(0 DOWNTO 0);
signal    addra_s :  STD_LOGIC_VECTOR(12 DOWNTO 0);
signal    dina_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal    douta_s :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal    clkb_s :  STD_LOGIC;
signal    enb_s :  STD_LOGIC;
signal    web_s :  STD_LOGIC_VECTOR(0 DOWNTO 0);
signal    addrb_s :  STD_LOGIC_VECTOR(12 DOWNTO 0);
signal    dinb_s :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal    doutb_s :  STD_LOGIC_VECTOR(31 DOWNTO 0);

signal clk, en1_s, en2_s, we1_s, we2_s, start_s, ready_s, reset_s: std_logic;
signal data1_in_s, data1_out_s, data2_in_s, data2_out_s: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal address1_s, address2_s: STD_LOGIC_VECTOR(12 DOWNTO 0);
begin
   duv: ip_pivot
   port map(
        clk => clk,
        reset => reset_s,
        data1_in => data1_in_s,
        address1 => address1_s,
        data1_out => data1_out_s,
        we1 => we1_s,
        data2_in  => data2_in_s,
        address2  => address2_s,
        data2_out   => data2_out_s,
        en2_out  => en2_s,
        we2  => we2_s,
        start   => start_s,
        ready => ready_s
    );

bram: blk_mem_gen_0
     port map
     (
    --memorija mapirana na pomocne
    clka => clk,
    ena => ena_s,
    wea => wea_s,
    addra => addra_s,
    dina => dina_s,
    douta => douta_s,
    
    clkb => clkb_s,
    enb => enb_s,
    web => web_s,
    addrb => addrb_s,
    dinb => dinb_s,
    doutb => doutb_s
     );
     
clk_gen: process
    begin
        clk <= '0', '1' after 10ns;
        wait for 20ns;
        start_s <= '1';
    end process;
    
stim_gen: process
    begin
        
    wait;
    end process;
end Behavioral;
