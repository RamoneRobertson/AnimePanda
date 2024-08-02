class List < ApplicationRecord
  belongs_to :user
  # If the list is deleted the bookmarks get deleted too
  has_many :bookmarks, dependent: :destroy
  # The list has many anime from the bookmarks added to it
  has_many :anime, through: :bookmarks

  validates :type, presence: true
  validates :type, uniqueness: true
end
