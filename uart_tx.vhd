----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 04:37:14 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst, send : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           tx : out STD_LOGIC;
           ready : out STD_LOGIC
           );
end uart_tx;

architecture fsm of uart_tx is

--initialize state type and state variable
type state is (idle, start, data);
signal cur: state := idle;
--signal nxt: state;

--shared variable a : integer range 0 to 8:= 0;
signal i : std_logic_vector(2 downto 0);
signal s : STD_LOGIC_VECTOR (7 downto 0);

begin
    process(clk) begin
    if rising_edge(clk) then
        if( rst = '1') then
            cur <= idle;
            ready <= '1';
            --a := 0;
            i <= "000";
            tx <= '1';
            s <= "00000000";
        elsif(en = '1') then
            case cur is
                when idle =>
                    if send = '1' then
                        cur <= start;
                        tx <= '0';
                        s <= char;
                        ready <= '0';
                    else 
                        ready <= '1';
                        tx <= '1';  
                    end if;
                when start =>
                    --tx <= '0';
                    --ready <= '0';
                    cur <= data;
                    i <= "000";
                    tx <= s(0);
                    s <= '0' & s(7 downto 1);
                when data =>
                    if unsigned(i)<7 then
                        --ready <= '0';
                        tx <= s(0);
                        s <= '0' & s(7 downto 1);
                        --a = a + 1;
                        i <= std_logic_vector(unsigned(i) + 1);
                    else
                        tx <= '1';
                        cur <= idle;
                        --i <= "0000";
                    end if;
                when others =>
                    cur <= idle;
            end case;
        end if;
    end if;
end process;
end fsm;
