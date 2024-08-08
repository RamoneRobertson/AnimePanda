class BookmarksController < ApplicationController

  def create
    @user = current_user
    @watchlist = @user.lists.find_by(list_type: 'watchlist')
    @seenlist = @user.lists.find_by(list_type: 'seen')
    @recommend_list = @user.lists.find_by(list_type: 'recommendations')
    @dropped_list = @user.lists.find_by(list_type: 'dropped')
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.watch_status = "watching"
      @bookmark.list = @watchlist
    elsif @bookmark.watch_status = "completed"
      @bookmark.list = @seenlist
    elsif @bookmark.watch_status = "recommended"
      @bookmark.list = @recommend_list
    else
      @bookmark.list = @dropped_list
    end

    @bookmark.save
  end

  def bookmark_params
    params.require(:bookmark).permit(:anime_id, :watch_status)
  end
end
