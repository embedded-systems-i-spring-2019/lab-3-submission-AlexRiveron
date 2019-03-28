----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2019 08:49:33 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

signal counter: std_logic_vector(1 downto 0);

begin
process(clk)
    begin
        if(rising_edge(clk)) then
            if (btn = '1') then
                case (counter) is
                    when "11" => dbnc <= '1';
                    when "00" | "01" | "10" => dbnc <= '0';
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    when others => dbnc <= '0';
                        counter <= "00";
                 end case;
            else if (btn = '0') then
                counter <= "00";
                dbnc <= '0';
            else
                counter <= "00";
                dbnc <= '0';
            end if;
            end if;   
        end if;
end process;

end Behavioral;
