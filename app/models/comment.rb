class Comment < ApplicationRecord	
  belongs_to :post
  belongs_to :user
  default_scope -> { order( created_at: :asc)}


  validates :user_id, :post_id, :content, presence: true
  validates :content, length: {maximum: 130}

end
