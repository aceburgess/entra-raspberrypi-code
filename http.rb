require 'net/http'

class EntraApp
  
  def initialize(url,params = nil)
    @uri = URI(url)
    @uri.query = URI.encode_www_form(params) if params
    @loop = true
  end

  def start
    while(@loop) do
      get_url
      sleep 2
    end
  end

  def stop
    @loop = false
  end

  def get_url
    puts "[#{Time.now}] - get - #{@uri} " 
    res = Net::HTTP.get_response(@uri)
    if res.is_a?(Net::HTTPSuccess)
      # res.body
      puts "success..."
    else
      puts "[#{Time.now}] - something went wrong "
      puts "[#{Time.now}] - response for #{@uri} : "
      puts "[#{Time.now}] - #{res}"
    end
  end
end

entra = EntraApp.new(ARGV[0])
entra.start