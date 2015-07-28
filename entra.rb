require_relative 'pin-setup'
require 'net/http'
# require 'artoo'
require 'json'

class EntraApp

  attr_accessor  :sleep_seconds
  attr_reader    :open_seconds

  def initialize(base_url,place_id)
    @base_url = base_url
    @place_id = place_id
    url = "http://#{base_url}/place/#{place_id}/key"
    @uri = URI(url)
    @sleep_seconds = 1
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
    if @response.has_key?'master'
      url = "http://#{@base_url}/place/#{@place_id}/master/#{status}"
    else
      url = "http://#{@base_url}/key/#{@response['key']}/status/#{status}"
    end
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

# connection :raspi, :adaptor => :raspi
# device :led, :driver => :led, :pin => 11

work do
  entra = EntraApp.new(ARGV[0],ARGV[1])
  while(true) do
    sleep entra.sleep_seconds
    begin
      entra.get_url
      if entra.can_open?
        door.digital_write PIN, 1
        # led.on
        entra.update_status "opened"
        sleep entra.open_seconds
        door.digital_write PIN, 0
        entra.update_status "closed"
      end
    rescue Exception => msg
      door.digital_write PIN, 0
      puts "[#{Time.now}] - something went wrong closing door "
      puts msg
    end
  end
end