class AnimesController < ApplicationController
  def recommendations
    # if there is a prompt from chatgpt
    # Get the 5 anime from the params
    @animes = Anime.first(5)
    @likes = []
    # If the user swip
  end
  def index
    @animes = Anime.all
  end
end
