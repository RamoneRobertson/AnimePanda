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
