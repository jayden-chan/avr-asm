default: build clean

clean:
	rm *.cof
	rm *.eep.hex
	rm *.obj

build:
	avra a2q3.asm

deploy:
	sudo avrdude -p atmega2560 -c wiring -P /dev/ttyACM1 -b 115200 -D -F -U flash:w:a2q3.hex

.PHONY: build deploy clean
