class List < ApplicationRecord
  belongs_to :user
  # If the list is deleted the bookmarks get deleted too
  has_many :bookmarks, dependent: :destroy
  # The list has many anime from the bookmarks added to it
  has_many :animes, through: :bookmarks

  validates :list_type, presence: true
  # validates :list_type, uniqueness: true
  enum list_type: { watchlist: 0, seen: 1, recommendations: 2, liked: 3, session: 4}
end
