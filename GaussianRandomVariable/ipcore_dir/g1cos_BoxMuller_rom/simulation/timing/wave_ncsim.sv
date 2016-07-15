<<<<<<< 06f93c07eb6db127e1822abe99b171b9e456bead

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /g1cos_BoxMuller_rom_tb/status
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/DOUTA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/CLKB
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/ADDRB
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/DOUTB
console submit -using simulator -wait no "run"
=======

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /g1cos_BoxMuller_rom_tb/status
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/DOUTA
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/CLKB
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/ADDRB
      waveform add -signals /g1cos_BoxMuller_rom_tb/g1cos_BoxMuller_rom_synth_inst/bmg_port/DOUTB
console submit -using simulator -wait no "run"
>>>>>>> daily update
