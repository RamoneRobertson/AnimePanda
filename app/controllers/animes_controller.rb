require 'net/http'
require 'json'
require 'open-uri'

class AnimesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def recommendations
    @hide_navbar = true
    @user = current_user
    params["genre"].nil? == true ? genres = "not set" : genres = params["genre"]
    current_user.liked_list.bookmarks.destroy_all
    chatgpt = OpenaiService.new
    seen_animes = @user.lists.seen.first.animes.select(:id, :title).to_json
    @animes = genrate_chatgpt_anime(seen_animes, genres)
    @user.lists.session.first.bookmarks.destroy_all
    @session_list = @user.lists.find_by(list_type: 'session')
    @reco_comments = []
    @animes.each do |anime|
      new_bookmark = Bookmark.new(watch_status: :session, anime: anime, list: @session_list, preference: nil)
      new_bookmark.save if !new_bookmark.anime_id.nil?
      @reco_comments << chatgpt.per_reco_chat(seen_animes, anime)
    end

    @load_comment = @reco_comments.slice(0, 1).first
    regex = /recommended\s([^.!?]*?[\w\s'!-.]*?)(?=\sbecause|\sas|\sdue\s|\sfor\s|[.?])/i;
    match = @load_comment.match(regex)
    title = match ? match[1].strip : nil
    # title = match[1]

    if(title)
      @highlighted_comment = [@load_comment.gsub(title, "<span class=\"highlight\">#{title}</span>")]
    end
  end

  def index
    chatgpt = OpenaiService.new
    @welcome_chat = chatgpt.home_chat
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.popularity}.reverse
    @random_popular = best_anime[0...50].sample(10)
    @top_anime = @animes.sort_by {|anime| anime.rating }.reverse[0..3]

    if params[:query].present?
      # @searched_animes = @animes.where("title ILIKE ?", "%#{params[:query]}%")
      @searched_animes = Anime.search_by_title(params[:query])
    end

    respond_to do |format|
      format.html
      format.text {
        render partial: "components/popular_anime_card",
        locals: { random_popular: @searched_animes },
        formats: [:html]
      }
    end

    @genre_array = ["Shounen", "Slice of Life", "Comedy", "Seinen", "Romance",
      "Sci-fi", "Sports", "Suspense"]
    # @genre_array.shuffle!
  end

  def show
    mal_service = MyanimelistService.new
    chatgpt = OpenaiService.new
    @user = current_user
    @liked = @user.lists.find_by(list_type: 'liked')
    @anime = Anime.find(params[:id])
    @show_chat = chatgpt.show_chat(@anime.title)
    @recommended = mal_service.call_mal_recos(@anime.mal_id)
    @reco_mal = []
    @recommended[0..2].each do |anime|
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
    # hide_panda
  end

  def genrate_chatgpt_anime(seen_animes, genres)
    mal_service = MyanimelistService.new
    openai_service = OpenaiService.new
    @user = current_user
    recommended_animes = []
    json_format = {"recommendations"=>[{"title"=>"Hunter x Hunter"}, {"title"=>"God Eater"}, {"title"=>"Attack on Titan"}, {"title"=>"Black Clover"}, {"title"=>"Parasyte: The Maxim"}]}

    prompt = <<~PROMPT
            Please respond in the following JSON format: #{json_format}.
            Recommend 5 Anime based on user's following seen anime below.
            #{seen_animes}
            if the user set the genres below, recommend animes that have the same genres.
            genres: #{genres}
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
    info["alternative_titles"]["en"] == "" ? title = info["title"] : title = info["alternative_titles"]["en"]
    picture_url = info["main_picture"]["large"]
    start_date = info["start_date"]
    synopsis = info["synopsis"]
    rating = info["mean"]
    episode_count = info["num_episodes"]
    popularity = info["popularity"]
    studio = info["studios"].empty? ? "" : info["studios"][0]["name"]
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
