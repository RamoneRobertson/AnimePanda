class ListsController < ApplicationController
  def show_watchlist
    @user = current_user
    chatgpt = OpenaiService.new
    mal_service = MyanimelistService.new
    @watching_anime = current_user.watchlist.bookmarks
    @seen_anime = current_user.seen_list.bookmarks
    if @seen_anime.empty? && !@user.mal_username.nil?
      user_mal_info = mal_service.call_user(@user.mal_username)
      add_from_mal(@user, user_mal_info)
      @seen_anime = current_user.seen_list.bookmarks
    end
    watchlist = current_user.lists.watchlist.first.animes.select(:id, :title).to_json
    @watchlist_chat = chatgpt.watchlist_chat(watchlist)
    filter_status
    # raise
  end

  def show_liked
    @liked_lists = current_user.liked_list.bookmarks.all
    @watching_anime = current_user.watchlist.bookmarks

    # Remove anime in liked list if the anime is bookmarked
    @liked_array = []
    @watch_anime = []

    @watching_anime.each do |animes|
      @watch_anime << animes.anime.id
    end

    @liked_lists.each do |like|
      @liked_array << like.anime.id
    end

    @matching_anime_id = @liked_array & @watch_anime

    # # @matching_anime_id.each do |anime_ids|
    #   animes_in_liked_list = @liked_lists.find{ |liked_anime| liked_anime.anime.id == anime_ids }
    #   if animes_in_liked_list.present?
    #     animes_in_liked_list.destroy
    #     redirect_to request.referer
    #     break
    #   end
    # # end

    @liked_lists.where( anime_id: @matching_anime_id).destroy_all
    @liked_lists.reload
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
        # raise
      end

      if watch_status == "completed"
        list = user.lists.find_by(list_type: 'seen')
      elsif watch_status == "watching"
        list = user.lists.find_by(list_type: 'watchlist')
      else
        list = user.lists.find_by(list_type: 'liked')
      end
      new_bookmark = Bookmark.new(anime: anime, watch_status: watch_status)
      new_bookmark.list = list
      new_bookmark.save
    end
  end

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
    studio = info["studios"].empty? ? "" : info["studios"][0]["name"]
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

  def filter_status
    case params[:status]
      when 'watching'
        @bookmarks = @watching_anime
      when 'completed'
        @bookmarks = @seen_anime
      else
        @bookmarks = @seen_anime + @watching_anime
      end
  end

  def hide_navbar
    @hide_navbar = true
  end
end
