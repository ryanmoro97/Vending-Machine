----------------------------------------------------------------------------------
---- Company: Department of Electrical and Computer Engineering, University of Alberta
---- Engineer: Ryan Moro
-- 
-- Create Date: 11/01/2020 07:56:11 PM
-- Design Name: vending machine testbench
-- Module Name: vending_tb - Behavioral
-- Target Devices: 
-- Tool Versions: 
-- Description: simulation testbench for vending machine fsm
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

entity vending_tb is
end vending_tb;

architecture Behavioral of vending_tb is

component vending is 
  Port ( clk            : in std_logic;
         reset          : in std_logic;
         item_sel       : in std_logic;                           -- sel=0 for chocolate, sel=1 for chips
         coins_in       : in std_logic_vector(1 downto 0);        -- "00" - 0$, "01" - 1$, "10" - 2$, "11" - 5$
         change_out     : out std_logic_vector(1 downto 0);       -- changeout is displayed on two leds - "00" - 0$
                                                                  -- "01" - 1$, "10" - 2$ and "11" - 5$
         display_sum    : out std_logic_vector(6 downto 0);       -- display the current sum of inserted money on the seven segment
         select_segment : out std_logic;                          -- select the left or right segment
         chips          : out std_logic;                          -- turn on the LED to dispense chips
         chocolate      : out std_logic);                         -- turn on the LED to dispense chocolate
end component;


signal clk_design : std_logic;
signal rst        : std_logic;
signal item_select      : std_logic;
signal coins_inserted : std_logic_vector(1 downto 0);
signal change_dispensed : std_logic_vector(1 downto 0);  

signal display_coin_sum : std_logic_vector(6 downto 0); 
signal segment_select : std_logic; 
signal chip_led : std_logic;
signal choc_led : std_logic;

constant clk_period : time := 40 ns;

begin
    seq_map : vending port map(clk => clk_design,
                                reset => rst,
                                item_sel => item_select,
                                coins_in => coins_inserted,
                                change_out => change_dispensed,
                                display_sum => display_coin_sum,
                                select_segment => segment_select,
                                chips => chip_led,
                                chocolate => choc_led);                             
   clk_process :process
   begin
        clk_design <= '0';
        wait for clk_period/2;  
        clk_design <= '1';
        wait for clk_period/2;  
   end process;                                   

    stim_proc: PROCESS 
    begin
    rst <= '1';
    wait for 50ns;
    rst <= '0';

     wait for clk_period*2;
     coins_inserted <= "00";
     wait for clk_period*2;
     
     item_select <= '1'; -- chips 4$, 1$ 2$ 5$ inserted
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "10";
     wait for clk_period*2;
     coins_inserted <= "11";
     wait for clk_period*2;
     
     
     item_select <= '1'; -- chips 4$, 5$ inserted
     wait for clk_period*2;
     coins_inserted <= "11";
     wait for clk_period*2;
     
     
     item_select <= '1'; -- chips 4$, 1$ 2$ 1$ inserted
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "10";
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     
     item_select <= '0'; -- chocolate 3$, 1$ 2$ inserted
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "10";
     wait for clk_period*2;

     item_select <= '0'; -- chocolate 3$, 1$ 1$ 5$ inserted
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "11";
     wait for clk_period*2;
     
     item_select <= '0'; -- chocolate 3$, 2$ 5$ inserted
     wait for clk_period*2;
     coins_inserted <= "10";
     wait for clk_period*2;
     coins_inserted <= "11";
     wait for clk_period*2;
     
     item_select <= '0'; -- chips 4$, 1$ 1$, 1$, 2$  inserted
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "01";
     wait for clk_period*2;
     coins_inserted <= "10";
     wait for clk_period*2;

        
    end process;
end Behavioral;


