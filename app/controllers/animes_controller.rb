class AnimesController < ApplicationController
  def index
    @animes = Anime.all
  end
end
