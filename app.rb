require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     


get "/" do
  view "ask"
end

    ForecastIO.api_key = "11aeb56853dd3a8b89a9f7acd90f6f07"

get "/news" do
    #convert search to lat long for weather
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates # => [lat, long]
    @lat = lat_long[0]
    @long = lat_long[1]
    @city = params["location"].capitalize
    
    #convert lat long to weather
    forecast = ForecastIO.forecast(@lat, @long).to_hash
    
    #global var for weather
    @current_temp = forecast["currently"]["temperature"].round(0)
    @current_summary = forecast["currently"]["summary"].downcase
    @forecast_array = forecast["daily"]["data"]
    
    #news stuff
    require 'open-uri'
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=2e60fd1f57eb44449c66ab6de1f94f08"
    news = HTTParty.get(url).parsed_response.to_hash
    @news_headline = news['articles']

    view "news"
end