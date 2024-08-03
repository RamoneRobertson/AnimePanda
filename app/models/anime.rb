class Anime < ApplicationRecord
  has_many :bookmarks
  # An anime can be in multiple lists (watchlist, liked, disliked ect...)
  has_many :list, through: :bookmarks

  # An anime must have a title and synopsis
  validates :title, :synopsis, presence: true
  # An anime cannot have the same title or synopsis
  validates :title, :synopsis, uniqueness: true

  # rank, popularity and episode count must be a numerical integer value
  validates :rank, :popularity, :episode_count, numericality: { only_integer: true }
end
