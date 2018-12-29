library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.functions.all;
--------------------------------

entity Hamming_tb is
generic (n:integer:=4); --num of data bits
end entity Hamming_tb;

architecture arc_Hamming_tb of Hamming_tb is

component HammingEncoder is --name of componant = name of design!
generic (n: integer);
port (
		CLK,EN,RST :in std_logic;
		uncoded : in std_logic_vector(1 to n);
		Valid : out std_logic;
		coded : out std_logic_vector(1 to (Num_Pairity(n)+n))

     );
end component HammingEncoder;

component HammingDecoder is --name of componant = name of design!
generic (n: integer);
port (
		CLK,RST :in std_logic;
		coded_de : in std_logic_vector(1 to (Num_Pairity(n)+n));
		Valid_in : in std_logic;
		decoded : out std_logic_vector(1 to n);
		Valid_out : out std_logic;
		Error : out std_logic

     );
end component HammingDecoder;

--- general inputs
signal  EN,RST : std_logic;
signal  CLK : std_logic;

--- encoder
signal uncoded :  std_logic_vector (1 to n); -- input
signal Valid : std_logic; -- enable output
signal coded :  std_logic_vector (1 to (Num_Pairity(n)+n)); -- output

--- decoder
signal Valid_in : std_logic; -- enable input
signal Valid_out : std_logic; -- enable output
signal Error : std_logic;
signal coded_de : std_logic_vector(1 to (Num_Pairity(n)+n)); -- input
signal decoded : std_logic_vector(1 to n); -- output

--- other
signal uncoded_cnt : integer :=0;
constant CLK_PERIOD : time := 100 ps;

begin

	u1: HammingEncoder
	generic map(n=>n)
	port map(
		EN=>EN,
		RST=>RST,
		CLK=>CLK,
		uncoded=>uncoded,
		Valid=>Valid,
		coded=>coded	
	);
	
	u2: HammingDecoder
	generic map(n=>n)
	port map(
		RST=>RST,
		CLK=>CLK,
		Valid_in=>Valid_in,
		Valid_out=>Valid_out,
		Error=>Error,
		coded_de=>coded_de,
		decoded=>decoded
	);
	
	Valid_in<=Valid;
	
   Init_process :process
   begin
		EN<='1';
        RST <= '1';
		wait for CLK_PERIOD/100;
		RST <= '0';
		wait;
   end process;
	
   Clk_process :process
   begin
        Clk <= '1';
        wait for CLK_PERIOD/2;  
        Clk <= '0';
        wait for CLK_PERIOD/2; 
   end process;
   
   Stim_process: process 
   begin  
		 
		uncoded <= std_logic_vector(to_unsigned(uncoded_cnt, uncoded'length));
		uncoded_cnt<=uncoded_cnt+1;
		
		wait for CLK_PERIOD;                        
  end process;
  
  Flip_process: process
  
  variable bit_i : integer:=1;
  variable temp : std_logic_vector (1 to (Num_Pairity(n)+n));
  
  begin
  
  	wait for CLK_PERIOD/2;
	
	temp:=coded;
	temp(bit_i):= NOT temp(bit_i);
	
	--- bit_index++
	bit_i:=bit_i+1;
	if bit_i=(Num_Pairity(n)+n) then
		bit_i:=1;
	end if;
	---

	coded_de<=temp;
  
  end process;

end architecture arc_Hamming_tb;











