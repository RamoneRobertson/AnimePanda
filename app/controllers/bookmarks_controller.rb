class BookmarksController < ApplicationController

  def create
    @bookmark = Bookmark.new(bookmarks_params)
  end

  private

  def bookmarks_params
    params.require(:bookmarks).permit(:preference, :watch_status, :anime_id, :list_id)
  end
end
