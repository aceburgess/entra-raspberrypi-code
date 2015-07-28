require 'wiringpi'

PIN = 0
OUTPUT = WiringPi::OUTPUT

door = WiringPi::GPIO.new
door.pin_mode(PIN, OUTPUT)
door.digital_write(PIN, 0)