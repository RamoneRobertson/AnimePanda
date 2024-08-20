include PgSearch::Model

class Anime < ApplicationRecord
  pg_search_scope :search_by_title,
  against: [ :title ],
  using: {
    tsearch: { prefix: true } # <-- now `superman batm` will return something!
  }


  has_many :bookmarks
  # An anime can be in multiple lists (watchlist, liked, disliked ect...)
  # belongs_to :list, through: :bookmarks

  # An anime must have a title and synopsis
  validates :title, :synopsis, presence: true
  # An anime cannot have the same title or synopsis
  validates :title, :synopsis, uniqueness: true

  # rank, popularity and episode count must be a numerical integer value
  validates :rank, :popularity, :episode_count, numericality: { only_integer: true }

  ActsAsTaggableOn.force_lowercase = true
  acts_as_taggable_on :tags
  acts_as_taggable_on :genres

  # def self.ransackable_associations(auth_object = nil)
  #   ["base_tags", "bookmarks", "genre_taggings", "genres", "tag_taggings", "taggings", "tags"]
  # end

  # def self.ransackable_attributes(auth_object = nil)
  #   ["created_at", "end_date", "episode_count", "id", "id_value", "mal_id", "picture_url", "popularity", "rank", "rating", "start_date", "studio", "synopsis", "title", "trailer", "updated_at"]
  # end

end
