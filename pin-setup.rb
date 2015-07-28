require 'wiringpi'

PIN = 0
OUTPUT = WiringPi::OUTPUT

io = WiringPi::GPIO.new
io.pin_mode(PIN, OUTPUT)
io.digital_write(PIN, 1)