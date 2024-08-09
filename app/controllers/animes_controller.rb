class AnimesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def recommendations
    @user = current_user
    @animes = Anime.first(5)
    @recommend_list = @user.list.find_by(list_type: 'recommendations')
    @animes.each do |anime|
      new_bookmark = Bookmark.new(watch_status: :recommended, anime: anime, list: @recommend_list)
      new_bookmark.save
    end
  end

  def index
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.rating}.reverse
    @random_popular_three = best_anime[0..5].sample(3)
  end

  def show
    @anime = Anime.find(params[:id])
  end

  private
  def bookmark_params
    params.require(:bookmark).permit(:id)
  end
end
