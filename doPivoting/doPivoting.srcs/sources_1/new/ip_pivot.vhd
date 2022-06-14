----------------------------------------------------------------------------------
-- Company:
-- Engineer: 
-- 
-- Create Date: 06/02/2022 02:43:39 PM
-- Design Name: 
-- Module Name: ip_pivot - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ip_pivot is
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
end ip_pivot;

architecture Behavioral of ip_pivot is
--declaration of divider component
component divider_32
Port (     dividend_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           dividend_tvalid: in STD_LOGIC;
           divisor_tdata : in STD_LOGIC_VECTOR (31 downto 0);
           divisor_tvalid: in STD_LOGIC;
           clk : in STD_LOGIC;
           dout_tdata : out STD_LOGIC_VECTOR (31 downto 0);
           dout_tvalid: out STD_LOGIC );
end component;
--declaration of dsp component
component dsp is
  generic(WIDTHA:natural:=32;
          WIDTHB:natural:=32;
          SIGNED_UNSIGNED: string:= "signed");
 Port ( clk: in std_logic;
        a_i: in std_logic_vector (31 downto 0);
        b_i: in std_logic_vector (31 downto 0);
        c_i: in std_logic_vector (31 downto 0);
        res_o: out std_logic_vector(31 downto 0));
end component dsp;

    type state_type is (idle,S1, S2, S3, S4, S5, S6, S7, S8);
    signal state_reg, state_next: state_type;
 
 --signals for counters
    signal i_reg, i_next: unsigned(6 downto 0);
    signal j_reg, j_next: unsigned(6 downto 0);
 
 --signals
    signal pivotCol_reg, pivotCol_next: STD_LOGIC_VECTOR(31 downto 0);
    signal pivot_reg, pivot_next: STD_LOGIC_VECTOR(31 downto 0);
 
 --signals for a (first) memory port
    signal data1_in_reg, data1_in_next: STD_LOGIC_VECTOR(31 downto 0);
    signal addr1_reg, addr1_next: STD_LOGIC_VECTOR(12 downto 0);
    signal en1_reg, en1_next: STD_LOGIC;
    signal we1_reg, we1_next: STD_LOGIC;
    signal data1_out_reg, data1_out_next: STD_LOGIC_VECTOR(31 downto 0);
    
 --signals for b (second memory port)
    signal data2_in_reg, data2_in_next: STD_LOGIC_VECTOR(31 downto 0);
    signal addr2_reg, addr2_next: STD_LOGIC_VECTOR(12 downto 0);
    signal en2_reg, en2_next: STD_LOGIC;
    signal we2_reg, we2_next: STD_LOGIC;
    signal data2_out_reg, data2_out_next: STD_LOGIC_VECTOR(31 downto 0);
 
    type newRow_type is array (0 to 100)
                  of std_logic_vector(31 downto 0);
    signal newRow_reg,newRow_next: newRow_type;
 
    type pivotColVal_type is array (0 to 50)
                  of std_logic_vector(31 downto 0);
 
    signal pivotColVal_reg, pivotColVal_next : pivotColVal_type;
 
    --signals for divider
    signal  dividend_tdata_s : STD_LOGIC_VECTOR (31 downto 0);
    signal  dividend_tvalid_s: STD_LOGIC;
    signal  divisor_tdata_s :  STD_LOGIC_VECTOR (31 downto 0);
    signal  divisor_tvalid_s:  STD_LOGIC;
    signal  dout_tdata_s :     STD_LOGIC_VECTOR (31 downto 0);
    signal  dout_tvalid_s:     STD_LOGIC ;

    -- signals for DSP
    signal a_i_s, b_i_s,c_i_s: std_logic_vector(31 downto 0);
    signal res_o_s:            std_logic_vector(31 downto 0);
begin
 --port map for divider
 div: divider_32
     port map
      (    dividend_tdata =>  dividend_tdata_s,
           dividend_tvalid => dividend_tvalid_s,
           divisor_tdata =>   divisor_tdata_s,
           divisor_tvalid =>  divisor_tvalid_s,
           clk  =>            clk,
           dout_tdata =>      dout_tdata_s,
           dout_tvalid =>     dout_tvalid_s
      );
 --generic and port map for DSP
 duv: dsp
        generic map(
        WIDTHA => 32,
        WIDTHB => 32,
        SIGNED_UNSIGNED => "signed"
        )
        port map(
            a_i   => a_i_s,
            b_i   => b_i_s,
            clk   => clk,
            c_i   => c_i_s,
            res_o => res_o_s
        );
 
 --defining registers     
 process (clk, reset)
 begin
    if reset = '1' then
        state_reg <= idle;
        --counters
        i_reg <= (others => '0');
        j_reg <= (others => '0');
        --
        pivotCol_reg <= (others => '0');
        pivot_reg <= (others => '0');
        --memory a ports interface
        data1_in_reg <= (others => '0');
        addr1_reg  <= (others => '0');
        en1_reg <= '0';
        we1_reg <= '0';
        data1_out_reg <= (others => '0');
        --memory b ports interface
        data2_in_reg <= (others => '0');
        addr2_reg  <= (others => '0');
        en2_reg <= '0';
        we2_reg <= '0';
        data2_out_reg <= (others => '0');
        
        --101 register defining newRow array
        for index in 0 to 100 loop
            newRow_reg(index) <= (others => '0');
        end loop;
        --51 register defining pivotColVal
        for index in 0 to 50 loop
            pivotColVal_reg(index) <= (others => '0');
        end loop;
       elsif (clk'event and clk = '1') then
        state_reg <= idle;
        
        i_reg <= i_next;
        j_reg <= j_next;
        
        pivotCol_reg <= pivotCol_next;
        pivot_reg <= pivot_next;
        
        data1_in_reg <= data1_in_next;
        addr1_reg  <= addr1_next;
        en1_reg <= en1_next;
        we1_reg <= we1_next;
        data1_out_reg <= data1_out_next;
        
        data2_in_reg <= data2_in_next;
        addr2_reg  <= addr2_next;
        en2_reg <= en2_next;
        we2_reg <= we2_next;
        data2_out_reg <= data2_out_next;
        
        --for index in 0 to 100 loop
        --    newRow_reg(index) <= newRow_next(index);
        --end loop;

        --for index in 0 to 50 loop
        --    pivotColVal_reg(index) <= pivotColVal_next(index);
        --end loop;
        newRow_reg <= newRow_next;
        pivotColVal_reg <= pivotColVal_next;
    end if;
 end process;
 
 process(state_reg, dout_tvalid_s,dout_tdata_s, start, data1_in, data2_in, pivotCol_reg , pivot_reg , i_reg,  j_reg,  data1_in_reg, addr1_reg,  en1_reg,  we1_reg,data1_out_reg,   data2_in_reg, addr2_reg,  en2_reg,  we2_reg, data2_out_reg,
                                        pivotCol_next, pivot_next, i_next, j_next, data1_in_next,addr1_next, en1_next, we1_next,data1_out_next, data2_in_next,addr2_next, en2_next, we2_next,data2_out_next,
                                        newRow_reg,  pivotColVal_reg, 
                                        newRow_next, pivotColVal_next)
 begin
 -- Default assignments
    i_next <= i_reg;
    j_next <= j_reg;
    data1_in_next <= data1_in_reg;
    en1_next <= en1_reg;
    we1_next <= we1_reg;
    data1_out_next <= data1_out_reg;
    data2_in_next <= data2_in_reg;
    en2_next <= en2_reg;
    we2_next <= we2_reg;
    data2_out_next <= data2_out_reg;
    
    newRow_next <= newRow_reg;
    pivotColVal_next<= pivotColVal_reg;
    
    pivotCol_reg <= pivotCol_next;
    pivot_reg <= pivot_next;

    address1 <=  (others => '0');
    data1_out <= (others => '0');
    en1_out <=   '0'; 
    we1 <=       '0';
    address2 <=  (others => '0');
    data2_out <= (others => '0');
    en2_out <=   '0'; 
    we2 <=       '0';
    ready <=     '0';
case state_reg is
    when idle =>
        ready <= '1';
        if start = '1' then
            addr1_next <=  "1010000011110"; --5151
            i_next <= to_unsigned( 0, 7);
            j_next <= to_unsigned( 0, 7);
            --turning on divider
            en1_next <= '1';
            state_next <= s1; 
                       
        else
            state_next <= idle;
        end if;
     when s1 =>
        pivotCol_next <= data1_in;
        addr1_next <=  pivotCol_next(12 downto 0); --5151
        state_next <= s2;
     when s2 =>
        addr1_next <= (others => '0');
        pivot_reg <= data1_in;
        state_next <= s3;
     when s3 =>
        dividend_tvalid_s <= '1';
        divisor_tvalid_s <= '1';
        dividend_tdata_s <= pivot_reg;
        divisor_tdata_s  <= data1_in;
        addr1_next <= std_logic_vector(unsigned(addr1_reg) + 1);
        if ( dout_tvalid_s = '0') then
            state_next <= s3;
        else
            state_next <= s4;
        end if;
     when s4 =>
        newRow_next(to_integer(i_reg)) <= dout_tdata_s;
        dividend_tdata_s <= pivot_reg;
        divisor_tdata_s  <= data1_in;
        i_next <= i_reg + 1;
        addr1_next <= std_logic_vector(unsigned(addr1_reg) + 1);
        if(addr1_reg = 101) then
            state_next <= s5;
        else
            state_next <= s4;   
        end if;
     when s5 =>
        newRow_next(to_integer(i_reg)) <= dout_tdata_s;
        i_next <= i_reg + 1;
        if(i_reg = 101) then
            state_next <= s6;
        else
            state_next <= s5;
        end if;
     when s6 => 
         addr1_next <= (others => '0');
         i_next <= to_unsigned(0,7);
         state_next <= S7;
         we1_reg <= '1';
     when S7 =>
        data1_out <= newRow_next(to_integer(i_reg));
        addr1_next <= std_logic_vector(unsigned(addr1_reg) + 1);
        if(addr1_reg = 101) then
            state_next <= s8;
        else
            state_next <= s7;
        end if;
      when S8 =>
        --addr1_next <= std_logic_vector(to_unsigned(COLSIZE,13))+ pivotCol_reg;
        --state_next <= S9;
      --when S9 =>
        --pivotColVal_next(to_integer(j_reg)) <= data1_in;
        --j_next <= j_reg + 1;
        --addr1_next <= std_logic_vector(to_unsigned(COLSIZE,13))+ addr1_reg;
        --if(j_reg = 51) then
        --    state_next <= s10;
        --else
        --    state_next <= s9;
        --end if;
end case;
end process;

--system outputs
address1  <= addr1_reg;
data1_out <= data1_out_reg ;
en1_out   <= en1_reg;
we1       <= we1_reg;
address2  <= addr2_reg;
data2_out <= data2_out_reg;
en2_out   <= en2_reg;
we2       <= we2_reg;
           

end Behavioral;
