class Bookmark < ApplicationRecord
  belongs_to :anime
  belongs_to :list
  # Must have a liked or disliked status, and watch status
  validates :watch_status, presence: true
  # In every list an anime cannot appear twice
  validates :anime, uniqueness: { scope: :list }, on: :create

  # Added three status on watch_status attribute
  enum watch_status: [ :watching, :completed, :dropped ]

  # Added two status on preferences attributes
  enum preference: [ :liked, :dislike ]
end
