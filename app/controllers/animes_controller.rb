class AnimesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.rating}.reverse
    @random_popular_three = best_anime[0..5].sample(3)
  end
end
