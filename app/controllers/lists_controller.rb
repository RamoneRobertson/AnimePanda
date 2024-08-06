class ListsController < ApplicationController
  def show_watchlist
    @anime_lists = current_user.list.first.bookmarks
    filter_status
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
end
