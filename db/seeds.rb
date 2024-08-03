# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'net/http'
require 'json'
require 'uri'


User.destroy_all
Anime.destroy_all
List.destroy_all
Bookmark.destroy_all

# Get 10 Animes from https://api.myanimelist.net/v2/anime/ranking?ranking_type=all&limit=10
# Get Anime info
# Create Anime

# Create user - jkinami
# Create user watchlist

def call_animes
# Step 1: Define the API endpoint
  url = 'https://api.myanimelist.net/v2/anime/ranking?ranking_type=all&limit=10'
  uri = URI(url)

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
  data["data"]
end

def anime_info(id)
  # Step 1: Define the API endpoint
  url = "https://api.myanimelist.net/v2/anime/#{id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics"

  uri = URI(url)

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
  # puts JSON.pretty_generate(data)
  # puts data["start_date"]
  # puts data["synopsis"]
  # puts data["mean"]
end



call_animes.each do |anime|
  mal_id = anime["node"]["id"]
  title = anime["node"]["title"]
  picture_url = anime["node"]["main_picture"]["large"]
  rank = anime["ranking"]["rank"].to_i

  info = anime_info(mal_id)
  start_date = info["start_date"]
  synopsis = info["synopsis"]
  rating = info["mean"]
  episode_count = info["num_episodes"]
  popularity = info["popularity"]

  new_anime = Anime.new(title: title, picture_url: picture_url, start_date: start_date, synopsis: synopsis, rating: rating, rank: rank, episode_count: episode_count, popularity: popularity)
  new_anime.save
end

puts "There is a total of #{Anime.count} animes in the database"
