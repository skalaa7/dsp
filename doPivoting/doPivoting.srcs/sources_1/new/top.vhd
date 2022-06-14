----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/02/2022 01:56:58 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           --software to memory
           ena_in : IN STD_LOGIC;
           wea_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra_in : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
           dina_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           douta_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end top;

architecture Behavioral of top is
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

--32 bit signed divivder


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


signal sel: STD_LOGIC;
begin
   

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

     
  process(clk,ena_in,wea_in,addra_in,dina_in, sel ) is
  begin
    if(rising_edge(clk)) then
        if( sel = '0' )then
            ena_s <= ena_in;
            wea_s <= wea_in;
            addra_s <= addra_in;
            dina_s <= dina_in;
            douta_out <= douta_s;
        else
            
        end if;
    end if;
  end process;    
        
end Behavioral;
