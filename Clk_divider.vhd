----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Ryan Moro
-- 
-- Create Date: 09/25/2020 08:40:34 PM
-- Design Name: 
-- Module Name: clk_divider - Behavioral
-- Target Devices: Zybo Z7
-- Tool Versions: 
-- Description: clock divider to operate the programs at simulation speed and user input speed
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


entity clk_divider is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
signal clock_out : std_logic := '0';
signal count : integer := 1;
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            count <= count + 1;
            if(count = 62500000) then -- divide for 1Hz on board
                clock_out <= NOT clock_out;
                count <= 1;
            end if;
        end if;            
        clk_out <= clock_out;
    end process;
end Behavioral;
