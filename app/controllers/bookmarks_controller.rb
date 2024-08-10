class BookmarksController < ApplicationController

  def create
    @user = current_user
    @watchlist = @user.lists.find_by(list_type: 'watchlist')
    @liked = @user.lists.find_by(list_type: 'liked')
    @seenlist = @user.list.find_by(list_type: 'seen')
    @recommend_list = @user.list.find_by(list_type: 'recommendations')
    @dropped_list = @user.list.find_by(list_type: 'dropped')
    @bookmark = Bookmark.new(bookmark_params)
    if @bookmark.watch_status = "watching"
      @bookmark.list = @watchlist
    elsif @bookmark.watch_status = "completed"
      @bookmark.list = @seenlist
    elsif @bookmark.watch_status = "liked"
      @boomark.list = @liked
    elsif @bookmark.watch_status = "recommended"
      @bookmark.list = @recommend_list
    else
      @bookmark.list = @dropped_list
    end

    @bookmark.save
  end

  def update
    @recommend_list = current_user.lists.find_by(list_type: 'recommendations')
    @likes = current_user.lists.find_by(list_type: 'liked')
    @bookmarks = @recommend_list.bookmarks
    @bookmark = Bookmark.find(params[:id])
    @bookmark.update(bookmark_params)

    if @bookmark.preference = "liked"
      @likes.push(@bookmark)
    end

    # if @recommend_list.nil?
    #   redirect_to root_path
    # end

    respond_to do |format|
      format.html { redirect_to recommendations_animes_path}
      format.text { render :recommendations }
    end
  end

  def bookmark_params
    params.require(:bookmark).permit(:anime_id, :watch_status, :preference)
  end
end
