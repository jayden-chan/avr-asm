default: build clean

clean:
	rm *.cof
	rm *.eep.hex
	rm *.obj

build:
	avra main.asm

deploy:
	sudo avrdude -p atmega2560 -c wiring -P /dev/ttyACM0 -b 115200 -D -F -U flash:w:main.hex

.PHONY: build deploy clean
