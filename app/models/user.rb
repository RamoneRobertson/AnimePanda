  class User < ApplicationRecord
  has_many :lists
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def watchlist
    lists.watchlist.first
  end

  def liked_list
    lists.liked.first
  end

  def seen_list
    lists.seen.first
  end

  def bookmarked_animes
    lists.bookmarks.animes
  end
end
