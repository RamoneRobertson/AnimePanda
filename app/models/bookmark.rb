class Bookmark < ApplicationRecord
  belongs_to :anime
  belongs_to :list
end
