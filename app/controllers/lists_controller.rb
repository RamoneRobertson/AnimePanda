class ListsController < ApplicationController
  def show_watchlist
    chatgpt = OpenaiService.new
    @watching_anime = current_user.watchlist.bookmarks
    @seen_anime = current_user.seen_list.bookmarks
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

    @matching_anime_id.each do |anime_ids|
      animes_in_liked_list = @liked_lists.find{ |liked_anime| liked_anime.anime.id == anime_ids }
      if animes_in_liked_list.present?
        animes_in_liked_list.destroy
        redirect_to request.referer
      end
    end
  end

  private

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
