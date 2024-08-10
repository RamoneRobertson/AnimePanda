class ListsController < ApplicationController
  def show_watchlist
    @animes_lists = current_user.watchlist.bookmarks
    filter_status
    hide_navbar
  end

  def show_liked
    @liked_lists = current_user.liked_list.bookmarks
    hide_navbar
  end

  private

  def filter_status
    case params[:status]
      when 'watching'
        @bookmarks = @animes_lists.watching
      when 'completed'
        @bookmarks = @animes_lists.completed
      when 'dropped'
        @bookmarks = @animes_lists.dropped
      else
        @bookmarks = @animes_lists.all
      end
  end

  def hide_navbar
    @hide_navbar = true
  end
end
