----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 03:06:35 PM
-- Design Name: 
-- Module Name: Sender - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sender is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           btn : in STD_LOGIC;
           rdy : in STD_LOGIC;
           rst : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end Sender;

architecture Behavioral of Sender is

signal n : std_logic_vector(2 downto 0):= "110";
signal i : std_logic_vector(2 downto 0):= "000";

type str is array (0 to 5) of std_logic_vector(7 downto 0);
signal NETID : str := (x"61",x"6a",x"72", x"32", x"33", x"34");

type state is (idle, busyA, busyB, busyC);
signal cur : state := idle;

--61 6a 72 32 33 34 

--ajr234
--61 6a 72 32 33 34 0a

begin
process(clk)
begin
if (rising_edge(clk)) then
    if (rst = '1') then
        i <= "000";
        cur <= idle;
    elsif en = '1' then
        case cur is
            when idle =>
                if btn = '1' and rdy = '1' and i < n then
                    send <= '1';
                    char <= NETID(to_integer(unsigned(i)));
                    i <= std_logic_vector(unsigned(i) + 1);
                    cur <= busyA;
                elsif btn = '1' and rdy = '1' and i = n then
                    i <=  "000";
                end if;
            when busyA =>
                cur <= busyB;
            when busyB => 
                send <= '0';
                cur <= busyC;
            when busyC =>
                if rdy = '1' and btn = '0' then
                    cur <= idle;
                end if;
        end case;
    end if;
end if;
end process;
end Behavioral;
