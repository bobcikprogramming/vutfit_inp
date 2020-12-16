proc isim_script {} {

   add_divider "Signals of the Vigenere Interface"
   add_wave_label "" "CLK" /testbench/clk
   add_wave_label "" "RST" /testbench/rst
   add_wave_label "-radix ascii" "DATA" /testbench/tb_data
   add_wave_label "-radix ascii" "KEY" /testbench/tb_key
   add_wave_label "-radix ascii" "CODE" /testbench/tb_code

   add_divider "Vigenere Inner Signals"
   add_wave_label "" "state" /testbench/uut/state
   # sem doplnte vase vnitrni signaly. chcete-li v diagramu zobrazit desitkove
   # cislo, vlozte do prvnich uvozovek: -radix dec
	add_wave_label "-radix bin" "MEALY" /testbench/uut/mealyVystup
	add_wave_label "-radix ascii" "PSTATE" /testbench/uut/pState
	add_wave_label "-radix ascii" "NSTATE" /testbench/uut/nState
	add_wave_label "-radix dec" "VELIKOST_POSUNU" /testbench/uut/velikostPosunu
	add_wave_label "-radix ascii" "PRICTENI" /testbench/uut/pricteniSKorekci
	add_wave_label "-radix ascii" "ODECTENI" /testbench/uut/odecteniSKorekci

   run 8 ns
}
