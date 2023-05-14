-------------------------------------------------------------------------------
-- Arithmetic logic unit
--
-- Ports:
--   - op [in]  : 4-bit instruction opcode
--   - i1 [in]  : operand 1
--   - i2 [in]  : operand 2
--   - o  [out] : result
--   - st [out] : 4-bit status flags
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
  port ( op : in  std_logic_vector(3 downto 0);
         i1 : in  std_logic_vector(15 downto 0);
         i2 : in  std_logic_vector(15 downto 0);
         o  : out std_logic_vector(15 downto 0);
         st : out std_logic_vector(3 downto 0) );
end entity;

architecture arch of alu is
  signal temp:  std_logic_vector(16 downto 0);
  signal Z,N,C,V,logic:std_logic;
  --signal buff:std_logic_vector(15 downto 0);
begin
  process(op,i1,i2)
    begin 
  case (op) is 
  when "0000" =>temp<= '0' &(i1 and i2);logic<='1';--and
  when "0001" => temp<='0' &(i1 or i2);logic<='1';--or
  when "0010" =>temp<='0' &(i1 xor i2); logic<='1'; --xor
  when "0011" =>temp<= '0' & not i2 ; logic<='1';--not
  when "0100" =>temp <= ('0'&i1)+('0'&i2);logic<='0';--add
  when "0101"=>temp<='0' & (i1 - i2);logic<='0';--sub
  when "0110" =>temp <=to_stdlogicvector( to_bitvector('0'&i1) sll to_integer(signed(i2)));logic<='0';--lsl
  when "0111" =>temp <= to_stdlogicvector( to_bitvector('0'&i1) srl to_integer(signed(i2))) ;logic<='0';--lsr
  when "1000" =>temp <= '0'&i2;
  when "1001" =>temp <= '0'&i1;
  when "1010" =>temp <='0' &i2;logic<='0'; 
  when "1011" =>temp <='0' &i1;logic<='0';
  when "1100" =>temp <='0'&(i1 + i2); logic<='0';
  when "1101" =>temp <='0'&(i1 - i2); logic<='0';
  when "1110" =>temp <='0' &i2;logic<='0'; 
  when "1111" =>temp <='0' &i2; logic<='0';
  when others=>null;
  end case;
  end process;
o<=temp(15 downto 0);
C<='1' when (temp(16)='1' and logic='0') else '0' ;
Z<='1' when (temp(15 downto 0)=x"0000") else '0';
N<='1' when (temp(15)='1') else '0';
V<='1' when ((temp(15)='1' and i1(15)='0' and i2(15)='0' and logic='0')or (temp(15)='0' and i1(15)='1' and i2(15)='1' and logic='0') ) else '0';

st<=Z&N&C&V;

end architecture;
