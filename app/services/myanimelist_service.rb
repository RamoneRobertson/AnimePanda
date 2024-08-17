require 'net/http'
require 'json'
require 'open-uri'

class MyanimelistService
  BASE_URL = "https://api.myanimelist.net/v2"

  def initialize
    @token = ENV['MAL_CLIENT_ID']
  end

  def call_top_rank
    uri = URI("#{BASE_URL}/anime/ranking?ranking_type=all&limit=100")
    # Step 2: Create an HTTP request object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'  # Use SSL/TLS if the URL is HTTPS

    # Step 3: Create the GET request and set headers
    request = Net::HTTP::Get.new(uri.request_uri)
    request['X-MAL-CLIENT-ID'] = @token  # Replace with your actual client ID

    # Step 4: Send the HTTP request
    response = http.request(request)

    # Step 5: Parse the JSON response
    data = JSON.parse(response.body)
    data["data"]
  end

  def call_popular
    uri = URI("#{BASE_URL}/anime/ranking?ranking_type=bypopularity&limit=20")
    # Step 2: Create an HTTP request object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'  # Use SSL/TLS if the URL is HTTPS

    # Step 3: Create the GET request and set headers
    request = Net::HTTP::Get.new(uri.request_uri)
    request['X-MAL-CLIENT-ID'] = @token  # Replace with your actual client ID

    # Step 4: Send the HTTP request
    response = http.request(request)

    # Step 5: Parse the JSON response
    data = JSON.parse(response.body)
    data["data"]
  end

  def find_anime(title)
    uri = URI("#{BASE_URL}/anime?q=#{title}&limit=1")
    # Step 2: Create an HTTP request object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'  # Use SSL/TLS if the URL is HTTPS

    # Step 3: Create the GET request and set headers
    request = Net::HTTP::Get.new(uri.request_uri)
    request['X-MAL-CLIENT-ID'] = @token  # Replace with your actual client ID

    # Step 4: Send the HTTP request
    response = http.request(request)

    # Step 5: Parse the JSON response
    JSON.parse(response.body)
  end


  def call_anime(id)
    # Step 1: Define the API endpoint
    uri = URI("#{BASE_URL}/anime/#{id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics")

    # Step 2: Create an HTTP request object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'  # Use SSL/TLS if the URL is HTTPS

    # Step 3: Create the GET request and set headers
    request = Net::HTTP::Get.new(uri.request_uri)
    request['X-MAL-CLIENT-ID'] = @token  # Replace with your actual client ID

    # Step 4: Send the HTTP request
    response = http.request(request)

    # Step 5: Parse the JSON response
    JSON.parse(response.body)
  end

  def call_user(id)
    uri = URI("#{BASE_URL}/users/#{id}/animelist?fields=list_status")

    # Step 2: Create an HTTP request object
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'  # Use SSL/TLS if the URL is HTTPS

    # Step 3: Create the GET request and set headers
    request = Net::HTTP::Get.new(uri.request_uri)
    request['X-MAL-CLIENT-ID'] = ENV['MAL_CLIENT_ID']  # Replace with your actual client ID

    # Step 4: Send the HTTP request
    response = http.request(request)

    # Step 5: Parse the JSON response
    data = JSON.parse(response.body)

    data["data"].map do |anime|
      arr = []
      arr.push(anime["node"]["id"])
      arr.push(anime["list_status"]["status"])
    end
  end

  def find_trailer(id)
    url = "https://myanimelist.net/anime/#{id}"
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML.parse(html_file)
    trailer = ""
    html_doc.search(".video-promotion a").each do |element|
      trailer = element.attribute("href").value
    end
    trailer
  end
end
