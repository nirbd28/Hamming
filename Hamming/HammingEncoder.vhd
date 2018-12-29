library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.functions.all;

entity HammingEncoder is 
	generic (
		n:integer:=4 --num of data bits
	);

	port(
		CLK,EN,RST : in std_logic;
		uncoded : in std_logic_vector(1 to n);
		Valid : out std_logic;
		coded : out std_logic_vector(1 to (Num_Pairity(n)+n))
	);


end HammingEncoder;

architecture HammingEncoder_arch of HammingEncoder is 
constant m : integer:=Num_Pairity(n); --num of pairity bits
signal reg : std_logic_vector(1 to n);
signal Valid_temp : std_logic;	

begin

	process(RST,CLK)
	
	variable parity: std_logic_vector(1 to m);
	variable temp: std_logic_vector(1 to m+n):=(others=>'0');
	variable index: integer;
	variable temp_xor: std_logic:='0';
	
	variable done: integer;
	variable rise : integer;
	-----

	begin
		index:=1;
		
		temp:=(others=>'0');
		
		if RST='1' then
			
			reg<=(others=>'0');
			
		elsif rising_edge(CLK) then	
			if EN='1' then	
				Valid_temp<=EN;
				reg<=uncoded;
				for i in temp'low to temp'high loop
					
					if Num_Pow_of_2(i)=1 then
						-- pow of 2 - place of parity bits, set to '0' for xor default
					else
						temp(i):=reg(index); -- concatenation of d1,d2,d3... in specific order (not in pow of 2 indexes)
						index:=index+1;
					end if;
				end loop;	
				
				for i in temp'low to temp'high loop
					
					if Num_Pow_of_2(i)=1 then -- only parity bits (power of 2)
						
						done:=0;
						rise:=1; -- rise/fall : rise=1 - in cluster to do xor; rise=0 - not in cluster, skip
						temp_xor:='0';
						for j in i to temp'high loop
							
							if rise =1 then 
								temp_xor:=temp_xor xor temp(j);-- xor on all relevant bits
								done:=done+1; -- inner cluster counter - xor 
							else
								done:=done-1; -- inner cluster counter - skip 
							end if;

							if done=0 then
								rise:=1; -- switch to rise
							elsif done=i then
								rise:=0; -- switch to fall
							end if;
							
						end loop;
						temp(i):=temp_xor;		
					end if;
					
				end loop;
				Valid<=Valid_temp;
				coded<=temp;
			
			end if;	
			
		end if;

end process;

end HammingEncoder_arch;