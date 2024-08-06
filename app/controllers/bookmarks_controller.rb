class BookmarksController < ApplicationController

  def create
    @user = current_user
    @watchlist = @user.list.find_by(list_type: 'watchlist')
    @seenlist = @user.list.find_by(list_type: 'seen')
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.watch_status = "watching"
      @bookmark.list = @watchlist
    else
      @bookmark.list = @seenlist
    end

    @bookmark.save
  end

  def bookmark_params
    params.require(:bookmark).permit(:anime_id, :watch_status)
  end
end
