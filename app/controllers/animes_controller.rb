class AnimesController < ApplicationController
  def recommendations
    # if there is a prompt from chatgpt
    # Get the 5 anime from the params
    @user = current_user
    @animes = Anime.first(5)
    @likes = []
    @recommend_list = @user.lists.find_by(list_type: 'recommendations')
    # If the user swip
    @animes.each do |anime|
      new_bookmark = Bookmark.new(watch_status: :recommended, anime: anime, list: @recommend_list)
      new_bookmark.save
    end
  end
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.popularity}.reverse
    @random_popular_three = best_anime[0..5].sample(3)
    @top_anime = @animes.sort_by {|anime| anime.rating }.reverse[0..3]
  end

  def show
    @anime = Anime.find(params[:id])
    hide_navbar
    hide_panda
  end

  private

  def hide_navbar
    @hide_navbar = true
  end

  def hide_panda
    @hide_panda = true
  end
end
