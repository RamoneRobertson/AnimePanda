class BookmarksController < ApplicationController
  def create
    # @user = current_user
    #check if added in recommended list
      # raise
      # if @user.lists.recommendations[0].animes.find_by_id(bookmark_params["anime_id"]).nil?
        @bookmark = Bookmark.new(bookmark_params)
        update_list(@bookmark)
        @bookmark.save
        @anime = Anime.find(bookmark_params[:anime_id])
        if @bookmark.list.list_type == 'watchlist'
          flash[:notice] = "Anime is added to your watchlist"
          # raise
          if params[:home]
            redirect_to root_path
          else
            redirect_to anime_path(@anime)
          end
          # redirect_to anime_path(@anime) unless params[:home] == "true"
        end
      # else
      #   @bookmark = @user.lists.recommendations[0].bookmarks.find_by(bookmark_params["anime_id"])
      #   update_to_watching(@bookmark)
      #   update_list(@bookmark)
      #   @bookmark.save
      # end

  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.delete
  end


  def update
    @bookmark_target = Bookmark.find(params[:id])
    @list = @bookmark_target.list
     if @bookmark_target.update(watch_status: 1, list_id:  current_user.lists.seen[0].id)
      redirect_to request.referer, notice: 'Marked as seen'
     else
      redirect_to request.referer, notice: 'Error, failed to mark as seen'
    end
  end

  def update_list(bookmark)
    @user = current_user
    if @bookmark.watch_status == "watching"
      @bookmark.list = @user.lists.find_by(list_type: 'watchlist')
    elsif @bookmark.watch_status == "completed"
      @bookmark.list = @user.lists.find_by(list_type: 'seen')
    elsif @bookmark.watch_status == "recommended"
      @bookmark.list = @user.lists.find_by(list_type: 'recommendations')
    elsif @bookmark.watch_status == "like"
      @bookmark.list = @user.lists.find_by(list_type: 'liked')
    elsif @bookmark.watch_status == "session"
      @bookmark.list = @user.lists.find_by(list_type: 'session')
    else
      @bookmark.list = @user.lists.find_by(list_type: 'dropped')
    end
  end

  # def add_preference
  #   @recommend_list = @user.lists.find_by(list_type: 'recommendations')
  #   @bookmark = Bookmark.find(bookmark_params[:id])
  #   @bookmark.preference = bookmark_params[:preference]
  #   @bookmark.watch_status = bookmark_params[:watch_status]
  #   update_list(bookmark_params)
  #   @bookmark.save
  #   # if @recommend_list.empty?

  #   # end
  # end
  private

  def bookmark_params
    params.require(:bookmark).permit(:anime_id, :watch_status, :id, :preference)
  end

end
