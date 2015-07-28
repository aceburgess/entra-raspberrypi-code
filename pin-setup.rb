require 'wiringpi'

PIN = 0
OUTPUT = WiringPi::OUTPUT

DOOR = WiringPi::GPIO.new
DOOR.pin_mode(PIN, OUTPUT)
DOOR.digital_write(PIN, 0)