require 'net/http'
require 'artoo'
require 'json'

class EntraApp

  attr_accessor  :sleep_seconds
  attr_reader    :open_seconds

  def initialize(place_id,params = nil)
    url = "http://10.0.2.185:3000/place_key/#{place_id}"
    @uri = URI(url)
    @uri.query = URI.encode_www_form(params) if params
    @sleep_seconds = 2
    @open_seconds = 5
  end

  def get_url
    puts "[#{Time.now}] - get - #{@uri} "
    res = Net::HTTP.get_response(@uri)
    if res.is_a?(Net::HTTPSuccess)
      @response = JSON.parse(res.body)
    else
      log_error res,@uri
    end
  end

  def can_open?
    @response["open"]
  end

  def update_status status
    url = "http://10.0.2.185:3000/client_key/#{@response['key']}/status/#{status}"
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      puts "[#{Time.now}] - Door #{status} successfully"
    else
      log_error(res,uri)
    end
  end

  private

  def log_error res,uri
    puts "[#{Time.now}] - something went wrong "
    puts "[#{Time.now}] - response for #{uri} : "
    puts "[#{Time.now}] - #{res.code}"
    puts "[#{Time.now}] - #{res.message}"
    puts "[#{Time.now}] - #{res.class.name}"
  end

end

connection :raspi, :adaptor => :raspi
device :led, :driver => :led, :pin => 11

work do
  entra = EntraApp.new(ARGV[0])
  while(true) do
    sleep entra.sleep_seconds
    entra.get_url
    if entra.can_open?
      led.on
      entra.update_status "opened"
      sleep entra.open_seconds
      led.off
      entra.update_status "closed"
    end
  end
end