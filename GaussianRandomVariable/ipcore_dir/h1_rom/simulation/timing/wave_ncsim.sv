
 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /h1_rom_tb/status
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/DOUTA
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/CLKB
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/ADDRB
      waveform add -signals /h1_rom_tb/h1_rom_synth_inst/bmg_port/DOUTB
console submit -using simulator -wait no "run"
