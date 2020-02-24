require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "YOUR-API-KEY"

get "/" do
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates # => [lat, long]
    "#{lat_long[0]} #{lat_long[1]}"
end