require "sinatra"
require "sinatra/reloader"

# Pull in the HTTP class
require "http"
require "dotenv/load"

# define a route for the homepage

get("/") do
  # Assemble the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("ER_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  @list_cur = @currencies.keys

  # Render a view template
  erb(:homepage)

  # In the view template, embed the @parsed_data variable to
  # see what you're working with.
  
  # From there, use your Hash/Array skills to make the homepage 
  # match the target.
  
  # Remember to Make The Invisible Visible — View Source in 
  # Chrome to see what your templates are actually outputting, 
  # and embed as many instance variables as you need to (this 
  # is the new equivalent of pretty-printing everything).
end

get("/:currency") do 
  # Assemble the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("ER_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  @list_cur = @currencies.keys
  @cur = params.fetch("currency")
  erb(:one_currency)
end

get("/:currency/:target") do 
  
  @cur = params.fetch("currency")
  @target = params.fetch("target")
  
  # Assemble the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/convert?from=#{@cur}&to=#{@target}&amount=1&access_key=#{ENV.fetch("ER_KEY")}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  @result = @parsed_data.fetch("result")
  
  erb(:exchange_rate)
end
