class AnimesController < ApplicationController
  def index
    @animes = Anime.all
    best_anime = @animes.sort_by {|anime| anime.rating}.reverse
    @random_popular_three = best_anime.sample(3)
  end
end
