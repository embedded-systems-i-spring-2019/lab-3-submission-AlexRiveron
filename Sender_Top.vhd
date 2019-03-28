----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 04:29:34 PM
-- Design Name: 
-- Module Name: Sender_Top - Behavioral
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

entity Sender_Top is
    Port ( clk : in STD_LOGIC;
           TXD : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           CTS : out STD_LOGIC;
           RTS : out STD_LOGIC;
           RXD : out STD_LOGIC);
end Sender_Top;

architecture Behavioral of Sender_Top is

component debounce is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end component;

component clock_div is
    Port ( clk_in : in STD_LOGIC;
           div : out STD_LOGIC);
end component;

component  uart is
   port (

   clk, en, send, rx, rst      : in std_logic;
   charSend                    : in std_logic_vector (7 downto 0);
   ready, tx, newChar          : out std_logic;
   charRec                     : out std_logic_vector (7 downto 0)

);
end component;

component Sender is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           btn : in STD_LOGIC;
           rdy : in STD_LOGIC;
           rst : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end component;


signal db1,db2,div,send, ready : std_logic;
signal char: std_logic_vector (7 downto 0);


begin

CTS <= '0';
RTS <= '0';

u1: debounce
    port map(
        btn => btn(0),
        clk => clk,
        dbnc => db1);
u2: debounce
    port map(
        btn => btn(1),
        clk => clk,
        dbnc => db2);
u3: clock_div
    port map(
        clk_in => clk,
        div => div);
u4: Sender
    port map(
        clk => clk,
        btn => db2,
        en => div,
        rdy => ready,
        rst => db1,
        send => send,
        char => char);
u5: uart
    port map(
        clk => clk,
        en => div,
        rst => db1,
        rx => TXD,
        send => send,
        ready => ready,
        tx => RXD,
        charSend => char);
    

end Behavioral;
