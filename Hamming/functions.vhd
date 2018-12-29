library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

package functions is

function Num_Pow_of_2(X : integer) return integer;
function Num_Pairity(n : integer)return integer;

end;

package body functions is

function Num_Pow_of_2(X : integer) return integer is
	
	variable flag:  real;
	variable temp1: real;
	variable temp2: real;
	
	begin
	
	temp1:= log2(real(X));
	temp2:= floor(temp1+0.001);
	flag:= temp1 - temp2;
	
	if flag<=0.0 then
		return 1;
	else
		return 0;
	end if;
	end Num_Pow_of_2;

function Num_Pairity(n : integer)return integer is

	variable k: integer:=1;
	
	begin
	
	for i in 0 to n loop
		if 2**k>=n+k+1 then
			---return k
		else
			k:=k+1;
		end if;
	end loop;
	
	return k;

end Num_Pairity;

end package body functions;
