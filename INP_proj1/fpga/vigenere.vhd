library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- rozhrani Vigenerovy sifry
entity vigenere is
   port(
         CLK : in std_logic;
         RST : in std_logic;
         DATA : in std_logic_vector(7 downto 0);
         KEY : in std_logic_vector(7 downto 0);

         CODE : out std_logic_vector(7 downto 0)
    );
end vigenere;

-- V souboru fpga/sim/tb.vhd naleznete testbench, do ktereho si doplnte
-- znaky vaseho loginu (velkymi pismeny) a znaky klice dle vaseho prijmeni.

architecture behavioral of vigenere is

	 signal mealyVystup: std_logic_vector(1 downto 0);
	 type state is (plus, minus);
	 signal pState: state := plus;
	 signal nState: state := minus;
	 
    signal velikostPosunu: std_logic_vector(7 downto 0);
	 signal pricteniSKorekci: std_logic_vector(7 downto 0);
	 signal odecteniSKorekci: std_logic_vector(7 downto 0);
	

begin

	--- Mealohy automat ---
	process(RST, CLK)
	begin
		if (RST='1') then
			pState <= pState;
		elsif (CLK'event) and (CLK='1') then
			pState <= nState;
		end if;
	end process;

	process(pState)
	begin
		nState <= pState;
		case pState is
			when plus =>
				  nState <= minus;
			when minus =>
				  nState <= plus;
			--when others => null;
		end case;
	end process;
	
	process(pState, RST, DATA)
	begin
		case pState is
			when plus =>
				if(DATA > 47 and DATA < 58) then
					mealyVystup <= "10"; --- Hashtag ---
				elsif(RST = '1') then
					mealyVystup <= "10"; --- Hashtag ---
				else
					mealyVystup <= "00"; --- Plus ---
				end if;
			when minus =>
				if(DATA > 47 and DATA < 58) then
					mealyVystup <= "10"; --- Hashtag ---
				elsif(RST = '1') then
					mealyVystup <= "10"; --- Hashtag ---
				else
					mealyVystup <= "01"; --- Minus ---
				end if;
		end case;
	end process;
	
	----------------------------------
	
	--- Proces multiplexoru ---
	process(pricteniSKorekci, odecteniSKorekci, mealyVystup)
	begin
		case mealyVystup is
			when "00" => CODE <= pricteniSKorekci;
			when "01" => CODE <= odecteniSKorekci;
			when others => CODE <= "00100011"; --- hashtag binární kód ---
		end case;
	end process;

	--- Proces pro velikost posunu ---
	process (KEY, DATA) is
	begin
		velikostPosunu <= KEY - 64;
	end process;
   
	--- Proces pro pøiètení èíselné hodnoty ke znaku ---
	process (velikostPosunu, DATA) is
		variable novaData: std_logic_vector(7 downto 0);
	begin
		novaData := DATA + velikostPosunu;
		
		if(novaData > 90) then
			novaData := novaData - 26;
		end if;
		
		pricteniSKorekci <= novaData;
	end process;

	--- Proces pro odeètení èíselné hodnoty od znaku ---
	process (velikostPosunu, DATA) is
		variable novaData: std_logic_vector(7 downto 0);
	begin
		novaData := DATA - velikostPosunu;
		
		if(novaData < 65) then
			novaData := novaData + 26;
		end if;
		
		odecteniSKorekci <= novaData;
	end process;



end behavioral;
