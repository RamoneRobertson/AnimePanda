class ListsController < ApplicationController
  def show_watchlist
    @anime_lists = current_user.list.watchlist
    filter_status
    hide_navbar
  end

  private

  def filter_status
    case params[:status]
    when 'watching'
      @bookmarks = @anime_lists.watching
    when 'completed'
      @bookmarks = @anime_lists.completed
    when 'dropped'
      @bookmarks = @anime_lists.dropped
    else
      @bookmarks = @anime_lists.all
    end
  end

  def hide_navbar
    @hide_navbar = true
  end
end
