class ListsController < ApplicationController
  def show_watchlist
    chatgpt = OpenaiService.new
    @watching_anime = current_user.watchlist.bookmarks
    @seen_anime = current_user.seen_list.bookmarks
    watchlist = current_user.lists.watchlist.first.animes.select(:id, :title).to_json
    @watchlist_chat = chatgpt.watchlist_chat(watchlist)
    filter_status
    hide_navbar
  end

  def show_liked
    @liked_lists = current_user.liked_list.bookmarks
  end

  private

  def filter_status
    case params[:status]
      when 'watching'
        @bookmarks = @watching_anime
      when 'completed'
        @bookmarks = @seen_anime
      else
        @bookmarks = Bookmark.all
      end
  end

  def hide_navbar
    @hide_navbar = true
  end
end
