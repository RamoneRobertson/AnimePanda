class BookmarksController < ApplicationController

  def create
    # @user = current_user
    #check if added in recommended list
      # raise
      # if @user.lists.recommendations[0].animes.find_by_id(bookmark_params["anime_id"]).nil?
        @bookmark = Bookmark.new(bookmark_params)
        update_list(@bookmark)
        @bookmark.save
      # else
      #   @bookmark = @user.lists.recommendations[0].bookmarks.find_by(bookmark_params["anime_id"])
      #   update_to_watching(@bookmark)
      #   update_list(@bookmark)
      #   @bookmark.save
      # end
  end


  # def update_to_watching(bookmark)
  #   bookmark.watch_status = "watching"
  # end

  def update_list(bookmark)
    @user = current_user
    if @bookmark.preference == "liked"
      @bookmark.list = @user.lists.find_by(list_type: 'liked')
    else
      if @bookmark.watch_status == "watching"
        @bookmark.list = @user.lists.find_by(list_type: 'watchlist')
      elsif @bookmark.watch_status == "completed"
        @bookmark.list = @user.lists.find_by(list_type: 'seen')
      elsif @bookmark.watch_status == "recommended"
        @bookmark.list = @user.lists.find_by(list_type: 'recommendations')
      else
        @bookmark.list = @user.lists.find_by(list_type: 'dropped')
      end
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

  def bookmark_params
    params.require(:bookmark).permit(:anime_id, :watch_status, :id, :preference)
  end
end
