require 'net/http'
require 'artoo'

class EntraApp
  
  def initialize(url,params = nil)
    @uri = URI(url)
    @uri.query = URI.encode_www_form(params) if params
  end

  def get_url
    puts "[#{Time.now}] - get - #{@uri} " 
    # req.basic_auth 'user', 'pass'
    res = Net::HTTP.get_response(@uri)
    if res.is_a?(Net::HTTPSuccess)
      # res.body
      puts "success..."
      return true
    else
      puts "[#{Time.now}] - something went wrong "
      puts "[#{Time.now}] - response for #{@uri} : "
      puts "[#{Time.now}] - #{res.code}"
      puts "[#{Time.now}] - #{res.message}"
      puts "[#{Time.now}] - #{res.class.name}"
      return false
    end
  end

end

connection :raspi, :adaptor => :raspi
device :led, :driver => :led, :pin => 11

work do
  entra = EntraApp.new(ARGV[0])
  sleep_seconds = 2
  while(true) do
    sleep sleep_seconds
    if entra.get_url
      sleep_seconds = 2
      puts "opening..."
      led.toggle
    else
      sleep_seconds = 10
    end
  end
end