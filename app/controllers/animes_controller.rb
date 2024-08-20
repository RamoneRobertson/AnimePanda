require 'net/http'
require 'json'
require 'open-uri'

class AnimesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def recommendations
    chatgpt = OpenaiService.new
    @skip_panda = true
    # @hide_navbar = true
    @user = current_user
    seen_animes = @user.lists.seen.first.animes.select(:id, :title).to_json
    @animes = genrate_chatgpt_anime(seen_animes)
    @recommend_list = @user.lists.find_by(list_type: 'recommendations')
    reco_animes = @user.lists.recommendations.first.animes.select(:id, :title).to_json
    @reco_chat = chatgpt.reco_chat(seen_animes, reco_animes)
    @animes.each do |anime|
      new_bookmark = Bookmark.new(watch_status: :recommended, anime: anime, list: @recommend_list, preference: nil)
      new_bookmark.save
    end
  end

  def index
    chatgpt = OpenaiService.new
    @welcome_chat = chatgpt.home_chat
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.popularity}.reverse
    @random_popular = best_anime[0...50].sample(10)
    @top_anime = @animes.sort_by {|anime| anime.rating }.reverse[0..3]
  end

  def show
    chatgpt = OpenaiService.new
    @user = current_user
    @liked = @user.lists.find_by(list_type: 'liked')
    @anime = Anime.find(params[:id])
    @show_chat = chatgpt.show_chat(@anime.title)
    hide_panda
  end

  def genrate_chatgpt_anime(seen_animes)
    mal_service = MyanimelistService.new
    openai_service = OpenaiService.new
    @user = current_user
    recommended_animes = []

    prompt = <<~PROMPT
            Please respond in the following JSON format: {\"title\": \"\"}.
            Recommend Anime based on user's following seen anime below.
            #{seen_animes}
            Only include the english title of the anime
            PROMPT

    response = openai_service.recommend_anime(prompt)
    recommended_json = response.dig("content")
    recommended_data = JSON.parse(recommended_json)
    # puts recommended_data
    recommended_data["recommendations"].each do |anime|
      new_anime = Anime.search_by_title(anime["title"])
      if new_anime.empty?
        if mal_service.find_anime(anime["title"])["message"] == "invalid q"
          next
        else
          mal_id = mal_service.find_anime(anime["title"])["data"].first["node"]["id"]
          new_anime = import_anime(mal_id)
          recommended_animes.push(new_anime)
        end
      else
        recommended_animes.push(new_anime.first)
      end
    end

    recommended_animes
  end

  def import_anime(id)
    mal_service = MyanimelistService.new
    info = mal_service.call_anime(id)
    title = info["alternative_titles"]["en"]
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

    new_anime = Anime.new(title: title, picture_url: picture_url, start_date: start_date, synopsis: synopsis, rating: rating, rank: rank, episode_count: episode_count, popularity: popularity, studio: studio, mal_id: id, trailer: trailer)
    anime_genre_list = []
    genres.each do |genre|
      anime_genre_list.push(genre["name"])
    end
    new_anime.genre_list = anime_genre_list.join(",")
    new_anime.save
    new_anime
  end


  private

  def hide_navbar
    @hide_navbar = true
  end

  def hide_panda
    @hide_panda = true
    # raise
  end

  def bookmark_params
    params.require(:bookmark).permit(:id)
  end
end
