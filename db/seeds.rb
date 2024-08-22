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

List.destroy_all
User.destroy_all
Anime.destroy_all
Bookmark.destroy_all

new_user = User.new(email: "panda@anime.com", mal_username: "jkinami", password: "seed1234")
new_user.save

new_seen_list = List.new(list_type: :seen)
new_seen_list.user = new_user
new_seen_list.save

new_reco_list = List.new(list_type: :recommendations)
new_reco_list.user = new_user
new_reco_list.save

new_liked_list = List.new(list_type: :liked)
new_liked_list.user = new_user
new_liked_list.save

new_watch_list = List.new()
new_watch_list.user = new_user
new_watch_list.save

mal_service = MyanimelistService.new
top_rank_data =  mal_service.call_top_rank
popular_data = mal_service.call_popular
user_mal_info = mal_service.call_user(new_user.mal_username)

def add_anime(id)
  mal_service = MyanimelistService.new
  info = mal_service.call_anime(id)
  info["alternative_titles"]["en"] == "" ? title = info["title"] : title = info["alternative_titles"]["en"]
  picture_url = info["main_picture"]["large"]
  start_date = info["start_date"]
  synopsis = info["synopsis"]
  rating = info["mean"]
  episode_count = info["num_episodes"]
  popularity = info["popularity"]
  studio = info["studios"][0]["name"]
  rank = info["rank"].to_i
  trailer = mal_service.find_trailer(id)
  genres = info["genres"]

  new_anime = Anime.new(title: title, picture_url: picture_url, start_date: start_date, synopsis: synopsis, rating: rating, rank: rank, episode_count: episode_count, popularity: popularity, studio: studio, trailer: trailer, mal_id: id)
  puts "---------- #{new_anime.title}(#{id}) ----------"
  anime_genre_list = []
  genres.each do |genre|
    puts "genre tag: #{genre["name"]}"
    anime_genre_list.push(genre["name"])
  end
  new_anime.genre_list = anime_genre_list.join(",")
  new_anime.save
  new_anime
end

def add_from_mal(user, mal_info)
  mal_info.each do |node|
    id = node[0]
    anime = ""
    watch_status = node[1] == "plan_to_watch" ? "like" : node[1]

    list = ""

    if Anime.exists?(mal_id: id)
      anime = Anime.find_by(mal_id: id)
    else
      anime = add_anime(id)
    end

    if watch_status == "completed"
      list = user.lists.find_by(list_type: 'seen')
    elsif watch_status == "watching"
      list = user.lists.find_by(list_type: 'watchlist')
    end
    new_bookmark = Bookmark.new(anime: anime, watch_status: watch_status)
    new_bookmark.list = list
    new_bookmark.save
  end
end

puts "----------Adding Top #{top_rank_data.count} Ranked Animes----------"
top_rank_data.each do |anime|
  add_anime(anime["node"]["id"])
end
puts "----------Adding Top #{popular_data.count} Popular Animes----------"
popular_data.each do |anime|
  if Anime.exists?(mal_id: anime["node"]["id"])
    anime = Anime.find_by(mal_id: anime["node"]["id"])
  else
    add_anime(anime["node"]["id"])
  end
end
puts "----------Adding User Seen Animes----------"
add_from_mal(new_user, user_mal_info)

puts "There is a total of #{Anime.count} animes in the database"
puts "There is a total of #{User.count} users in the database"
puts "There is a total of #{List.count} lists in the database"
puts "There is a total of #{Bookmark.count} bookmarks in the database"
# puts JSON.pretty_generate(user_info)
# puts user_info["data"]
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
