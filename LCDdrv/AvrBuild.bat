@ECHO OFF
"E:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "E:\Projects\Fastex Checker\LCDdrv\labels.tmp" -fI -W+ie -o "E:\Projects\Fastex Checker\LCDdrv\LCDdrv.hex" -d "E:\Projects\Fastex Checker\LCDdrv\LCDdrv.obj" -e "E:\Projects\Fastex Checker\LCDdrv\LCDdrv.eep" -m "E:\Projects\Fastex Checker\LCDdrv\LCDdrv.map" "E:\Projects\Fastex Checker\LCDdrv\LCDdrv.asm"
