require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'time'
require 'net/http'
require 'net/https'
require 'json'
if RUBY_VERSION < '1.9.0'
  require File.join(File.dirname(__FILE__), 'eep_client', 'const')
  require File.join(File.dirname(__FILE__), 'eep_client', 'response')  
else
  require_relative 'eep_client/const'
  require_relative 'eep_client/response'
end

## some constants
EVENT = 'event'
CLEAR = 'clear'
OK = 'ok'

# urls
BASE_URL = 'https://eep.eventenrichment.com'
BASE_RESOURCE = '/api/v1/'
EVENT_RESOURCE = BASE_RESOURCE + EVENT
CLEAR_RESOURCE = BASE_RESOURCE + CLEAR

# http config
POST = 'POST'
ACC_HDR = 'Accept'
CON_HDR = 'Content-type'
APP_JSON = 'application/json'

class EepClient
  def initialize(api_token, options = { })
    @api_token = api_token
    @debug = options[:debug]
    @base_url = options[:base_url] || BASE_URL
    
    unless options[:no_send]
      uri = URI(@base_url)      
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE if options[:no_verify]
      @http.set_debug_output($stdout) if @debug
    end
  end

  def send_event(event)
    json = format_event(event)
    if @debug
      puts "sending event json:"
      puts json
    end
    if @http
      headers = { ACC_HDR => APP_JSON, CON_HDR => APP_JSON }      
      res = @http.send_request(POST, EVENT_RESOURCE, json, headers)
      if res.is_a? Net::HTTPServerError
        res.error!
      else
        Response.new_instance(JSON.parse(res.body))
      end
    else
      Response.mock_event_ok
    end
  end

  def send_clear(clear)
    json = format_clear(clear)
    if @debug
      puts "sending clear json:"
      puts json
    end
    if @http
      headers = { ACC_HDR => APP_JSON, CON_HDR => APP_JSON }
      res = @http.send_request(POST, CLEAR_RESOURCE, json, headers)
      if res.is_a? Net::HTTPServerError
        res.error!
      else      
        Response.new_instance(JSON.parse(res.body))
      end
    else
      Response.mock_clear_ok      
    end
  end    

  private

  def format_data(type, data)
    packet = {
      api_token: @api_token,
      type => data
    }
    
    if @debug
      JSON.pretty_generate(packet)
    else
      JSON.generate(packet)
    end    
  end

  def format_event(data)
    # event time attrs can take strings (iso8601 format), ints (unix epoch) or Time objects
    [:creation_time, :last_time].each do |name|
      val = data[name]
      if val
        case
        when val.is_a?(Fixnum), val.is_a?(Bignum)
          data[name] = Time.at(val).iso8601
        when val.is_a?(Time)
          data[name] = val.iso8601
        end        
      end
    end
    format_data(:event, data)
  end

  def format_clear(data)
    h = { :local_instance_id => data[:local_instance_id], :source_location => data[:source_location] }
    format_data(:clear, h)
  end  
end
