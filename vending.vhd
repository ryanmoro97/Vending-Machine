----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Ryan Moro
--
-- Create Date: 08/07/2020 09:50:46 PM
-- Design Name: Vending Machine
-- Module Name: vending - Behavioral
-- Target Devices: Zybo Z7, PmodOLED
-- Tool Versions:
-- Description: VENDING MACHINE 
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--*********************************************************************************
-- The Vending Machine accepts 1$, 2$ and 5$ denominations. Chips price : 4$, Chocolate price : 3$
-- The current sum of the total money inserted should be displayed on the seven segment.
-- Hand over the change to the customer, and then dispense the item (chips/chocolate)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity vending is
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
end vending;

architecture Behavioral of vending is

component clk_divider is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

signal clk_o : std_logic;
type state_type is (sum_0,         -- state names represent the total sum of inserted money by the user
                    sum_1,
                    sum_2,
                    sum_3,
                    sum_4,
                    sum_5,
                    sum_6,
                    sum_7,
                    sum_8,
                    dispense);

signal present_state,next_state: state_type;    -- current and next state declaration.

begin

    label_clk_divider: clk_divider port map(clk_in => clk, clk_out => clk_o);

    select_segment <= '0'; --select the left segment

    process(clk_o,reset)
    begin
        if(reset = '1')then
        -- *** write one line of code to update the present state when reset=1
            present_state <= sum_0;
        elsif(clk_o'event and clk_o='1')then -- rising edge trigger
        -- *** write one line of code to update the present state
            present_state <= next_state;
        end if;
    end process;

    process(present_state, item_sel, coins_in) --*** complete the sensitivity list
        begin
        case present_state is
            when sum_0 =>
                            chips <= '0';
                            chocolate <= '0';
                            change_out <= "00";
                            --display the current sum of inserted money 
                            display_sum <= "0111111";

                            -- based on the inserted coins, update the next state
                            if(coins_in="00")then       -- nothing inserted
                                next_state <= sum_0;
                            elsif(coins_in="01")then    -- 1$ inserted
                                next_state <= sum_1;
                            elsif(coins_in="10")then    -- 2$ inserted
                                next_state <= sum_2;
                            else                        -- 5$ inserted
                                next_state <= sum_5;
                            end if;
            when sum_1 =>
                            chips <= '0';
                            chocolate <= '0';
                            change_out <= "00";

                            display_sum <= "0000110";

                            if(coins_in="00")then       -- nothing inserted
                                next_state <= sum_1;
                            elsif(coins_in="01")then    -- 1$ inserted
                                next_state <= sum_2;
                            elsif(coins_in="10")then    -- 2$ inserted
                                next_state <= sum_3;
                            else                        -- 5$ inserted
                                next_state <= sum_6;
                            end if;

            when sum_2 =>
                            chips <= '0';
                            chocolate <= '0';
                            change_out <= "00";

                            display_sum <= "1011011";

                            if(coins_in="00")then       -- nothing inserted
                                next_state <= sum_2;
                            elsif(coins_in="01")then    -- 1$ inserted
                                next_state <= sum_3;
                            elsif(coins_in="10")then    -- 2$ inserted
                                next_state <= sum_4;
                            else                        -- 5$ inserted
                                next_state <= sum_7;
                            end if;
            when sum_3 =>
                            chips <= '0';
                            chocolate <= '0';
                            change_out <= "00";
                            --*** write one line of code to display the current sum of inserted money on the seven segment display
                            display_sum <= "1001111";

                            if(item_sel='0')then
                                next_state <= dispense;
                            else    -- when item_sel='1'
                                if(coins_in="00")then       -- nothing inserted
                                    next_state <= sum_3;
                                elsif(coins_in="01")then    -- 1$ inserted
                                    next_state <= sum_4;
                                elsif(coins_in="10")then    -- 2$ inserted
                                    next_state <= sum_5;
                                else                        -- 5$ inserted
                                    next_state <= sum_8;
                                end if;
                            end if;
            when sum_4 =>
                            chips <= '0';
                            chocolate <= '0';

                            display_sum <= "1100110";

                            if(item_sel='0')then
                                change_out <= "01"; -- 3$ chocolate selected
                                next_state <= dispense;
                            else
                                change_out <= "00"; -- 4$ chips
                                next_state <= dispense;
                            end if;
                            -- end updating the design lines

            when sum_5 =>
                            chips <= '0';
                            chocolate <= '0';

                            display_sum <= "1101101";

                            if(item_sel='0')then -- chocolate 3$
                                change_out <= "10"; -- change 2$
                                next_state <= dispense;
                            else                 -- chips 4$
                                change_out <= "01"; -- change 1$
                                next_state <= dispense; 
                            end if;
            when sum_6 =>
                            chips <= '0';
                            chocolate <= '0';

                            display_sum <= "1111101";

                            if(item_sel='0')then -- chocolate 3$
                                change_out <= "10"; -- change 2$
                                next_state <= sum_4; 
                            else
                                change_out <= "10";
                                next_state <= dispense;
                            end if;
            when sum_7 =>
                            chips <= '0';
                            chocolate <= '0';

                            display_sum <= "0000111";
                            
                            if(item_sel='0')then
                                change_out <= "10";
                                next_state <= sum_5;
                            else
                                change_out <= "10";
                                next_state <= sum_5;
                            end if;
            when sum_8 =>
                            chips <= '0';
                            chocolate <= '0';

                            display_sum <= "1111111";

                            if(item_sel='0')then -- chocolate 3$
                                change_out <= "11"; -- change 5$
                                next_state <= dispense;
                            else -- chips 4$
                                change_out <= "10"; -- change 2$ -> sum_6 -> 2$ -> dispense
                                next_state <= sum_6;
                            end if;

            when dispense =>
                            change_out <= "00";
                            display_sum <= "0111111";

                            if(item_sel='0')then
                            --dispense chocolate
                            chocolate <= '1';
                            chips <= '0';
                            else
                            --dispense chips
                            chips <= '1';
                            chocolate <= '0';
                            end if;

                            next_state <= sum_0;

            end case;
    end process;
end Behavioral;
