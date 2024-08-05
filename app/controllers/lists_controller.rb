class ListsController < ApplicationController
  def show_watchlist
    @anime_lists = current_user.list.first.bookmarks
    console
  end
end
