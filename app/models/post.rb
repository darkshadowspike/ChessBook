class Post < ApplicationRecord
  belongs_to :user
  #using a lambda with default scope to retrive all ways the latest
  default_scope -> { order(created_at: :desc)}
  validates :user_id, :content, presence: true
  validates :content, length: {maximum: 130}
end
