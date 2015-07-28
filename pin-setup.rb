require 'wiringpi'

PIN = 0
OUTPUT = WiringPi::OUTPUT

io = WiringPi::GPIO.new
io.mode(PIN, OUTPUT)
io.write(PIN, 0)