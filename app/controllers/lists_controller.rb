class ListsController < ApplicationController
  def show_watchlist
    @watching_anime = current_user.watchlist.bookmarks
    @seen_anime = current_user.seen_list.bookmarks
    filter_status
  end

  def show_liked
    @liked_lists = current_user.liked_list.bookmarks.all
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
