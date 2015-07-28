require 'wiringpi'

PIN = 0

io = WiringPi::GPIO.new
io.mode PIN, OUTPUT