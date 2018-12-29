library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use work.functions.all;

entity HammingDecoder is 
	generic (
		n:integer:=4
	);

	port(
		CLK,RST :in std_logic;
		coded_de : in std_logic_vector(1 to (Num_Pairity(n)+n));
		Valid_in : in std_logic;
		decoded : out std_logic_vector(1 to n);
		Valid_out : out std_logic;
		Error : out std_logic
	);


end HammingDecoder;

architecture HammingDecoder_arch of HammingDecoder is 
constant m : integer:=Num_Pairity(n);
signal reg : std_logic_vector(1 to m+n);
signal Valid_temp : std_logic;

begin

	process(RST,CLK)
	
	variable parity : std_logic_vector(1 to m);
	variable temp : std_logic_vector(1 to m+n);
	variable index : integer;
	variable temp_xor : std_logic:='0';
	variable bit_error : integer;
	variable p_index : integer;
	
	variable done: integer;
	variable rise : integer;
	-----
	
	begin

		index:=1;
		
		if RST='1' then
			reg<=(others=>'0');
			
		elsif rising_edge(CLK) then	
			p_index:=m;
			
			if Valid_in='1' then
				
				Valid_temp<=Valid_in;
				reg<=coded_de;
				temp:=reg;
				
				for i in temp'low to temp'high loop
							
							if Num_Pow_of_2(i)=1 then
								
								done:=0;
								rise:=1; 
								temp_xor:='0';
								for j in i to temp'high loop
									
									if rise =1 then
										temp_xor:=temp_xor xor temp(j);
										done:=done+1; 
									else
										done:=done-1;
									end if;

									if done=0 then
										rise:=1;
									elsif done=i then
										rise:=0;
									end if;
								end loop;
								
								parity(p_index):=temp_xor;--slots in decending order: ...p16,p8,p4,p2,p1 
								p_index:=p_index-1;
								
							end if;
				end loop;
				
				----- fix error
				bit_error:=to_integer(unsigned(parity));
				if bit_error> temp'length then
					Error<='1';
				elsif bit_error=0 then
					---
				else
					temp(bit_error):=not temp(bit_error);
				end if;
				-----
				
				for i in temp'low to temp'high loop
						
						if Num_Pow_of_2(i)=1 then
							-- pow of 2
						else
							decoded(index)<=temp(i);
							index:=index+1;
						end if;
				end loop;
				
				Valid_out<=Valid_temp;
			end if;
			

		end if;

		
end process;

end HammingDecoder_arch;