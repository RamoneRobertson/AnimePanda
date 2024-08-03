class ListsController < ApplicationController
  def show_watchlist
    @bookmark = Bookmark.first
    @anime_lists = @bookmark.list.anime
  end
end
