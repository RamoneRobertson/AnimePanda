class ListsController < ApplicationController
  def show_watchlist
    chatgpt = OpenaiService.new
    @watching_anime = current_user.watchlist.bookmarks
    @seen_anime = current_user.seen_list.bookmarks
    watchlist = current_user.lists.watchlist.first.animes.select(:id, :title).to_json
    @watchlist_chat = chatgpt.watchlist_chat(watchlist)
    filter_status
    # console

  end

  def update
    @bookmark_target.Bookmark.update(list_id: current_user.seen_list.id)
  end

  def show_liked
    @liked_lists = current_user.liked_list.bookmarks.all
  end

  private

  def filter_status
    case params[:status]
      when 'watching'
        @bookmarks = @watching_anime
      when 'completed'
        @bookmarks = @seen_anime
      else
        @bookmarks = @seen_anime + @watching_anime
      end
  end

  def hide_navbar
    @hide_navbar = true
  end

end
