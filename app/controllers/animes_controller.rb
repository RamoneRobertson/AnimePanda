require 'net/http'
require 'json'
require 'open-uri'

class AnimesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def recommendations
    current_user.liked_list.bookmarks.destroy_all
    chatgpt = OpenaiService.new
    @user = current_user
    seen_animes = @user.lists.seen.first.animes.select(:id, :title).to_json
    @animes = genrate_chatgpt_anime(seen_animes)

    @recommend_list = @user.lists.find_by(list_type: 'recommendations')
    reco_animes = @user.lists.recommendations.first.animes.select(:id, :title).to_json
    @reco_chat = chatgpt.reco_chat(seen_animes, reco_animes)

    @animes.each do |anime|
      new_bookmark = Bookmark.new(watch_status: :recommended, anime: anime, list: @recommend_list, preference: nil)
      new_bookmark.save if !new_bookmark.anime_id.nil?
    end
  end

  def like
    @anime = Anime.find(params[:id])
    swipe_session = session[:liked_anime_ids] = []
    swipe_session << @anime.id unless swipe_session.include?(@anime.id)
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
    mal_service = MyanimelistService.new
    chatgpt = OpenaiService.new
    @user = current_user
    @liked = @user.lists.find_by(list_type: 'liked')
    @anime = Anime.find(params[:id])
    @show_chat = chatgpt.show_chat(@anime.title)
    recommended = mal_service.call_mal_recos(@anime.mal_id)
    @reco_mal = []
    recommended[0..2].each do |anime|
      mal_id = anime["node"]["id"]
      if Anime.find_by(mal_id: mal_id).nil?
        new_anime = import_anime(mal_id)
      else
        new_anime = Anime.find_by(mal_id: mal_id)
      end
      @reco_mal.push(new_anime)
    end

    # Get random similar animes through genre
    @five_similar_animes = Anime.tagged_with(@anime.genre_list, any:true).sample(5)

    # Get Anime with most matching genres
    target_anime_id = @anime.id
    target_anime_genre = @anime.genre_list

    other_animes = Anime.where.not(id: target_anime_id)

    anime_genre_count = {}

    other_animes.each do |anime|
      other_anime_genre = anime.genre_list

      number_of_matching_genre = (target_anime_genre & other_anime_genre).size

      anime_genre_count[anime.id] = number_of_matching_genre
    end

    similar_anime_sorted = anime_genre_count.sort_by { |_, v| -v }.first(5).map(&:first)

    @similar_animes = Anime.where(id: similar_anime_sorted)

    # Other stuff
    hide_panda
  end

  def genrate_chatgpt_anime(seen_animes)
    mal_service = MyanimelistService.new
    openai_service = OpenaiService.new
    @user = current_user
    recommended_animes = []
    json_format = {"recommendations"=>[{"title"=>"Hunter x Hunter"}, {"title"=>"God Eater"}, {"title"=>"Attack on Titan"}, {"title"=>"Black Clover"}, {"title"=>"Parasyte: The Maxim"}]}

    prompt = <<~PROMPT
            Please respond in the following JSON format: #{json_format}.
            Recommend 5 Anime based on user's following seen anime below.
            #{seen_animes}
            Avoid recommending anime that you already recommended recently.
            Only include the english title of the anime.
            PROMPT

    response = openai_service.recommend_anime(prompt)
    recommended_json = response.dig("content")
    # checked parsed content
    begin
      recommended_data = JSON.parse(recommended_json)
    rescue JSON::ParserError => e
      puts "There was an error parsing the JSON: #{e.message}"
      recommended_data = {"recommendations"=>[{"title"=>"Hunter x Hunter"}, {"title"=>"God Eater"}, {"title"=>"Attack on Titan"}, {"title"=>"Black Clover"}, {"title"=>"Parasyte: The Maxim"}]}
    end
    recommended_data = {"recommendations"=>[{"title"=>"Hunter x Hunter"}, {"title"=>"God Eater"}, {"title"=>"Attack on Titan"}, {"title"=>"Black Clover"}, {"title"=>"Parasyte: The Maxim"}]} if  recommended_data["recommendations"].first.class != Hash || !recommended_data["recommendations"].first.key?("title")


    recommended_data["recommendations"].each do |anime|
      new_anime = Anime.search_by_title(anime["title"])
      if new_anime.empty?
        if mal_service.find_anime(anime["title"])["data"].empty?
          next
        else
          mal_id = mal_service.find_anime(anime["title"])["data"].first["node"]["id"]
          if Anime.find_by(mal_id: mal_id).nil?
            new_anime = import_anime(mal_id)
          else
            new_anime = Anime.find_by(mal_id: mal_id)
          end
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

  def clear_likes
    current_user.liked_list.bookmarks.destroy
  end

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
