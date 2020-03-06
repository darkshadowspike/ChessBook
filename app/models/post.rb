class Post < ApplicationRecord
  belongs_to :user
  #using a lambda with default scope to retrive in descendent order
  default_scope -> { order( created_at: :desc)}

  validates :user_id, :content, presence: true
  validates :content, length: {maximum: 360}
  validate :media_attached

  has_many :comments
  has_one_attached :media

  def media_attached
  	if self.media.attached?
	  	unless (media.content_type =~ /image.+/im || media.content_type =~ /video\/(mp4|webm|ogg)/im) && media.byte_size.to_f/1000000 <= 110
	  		errors.add(:media, "invalid file type")
	  	end
  	end
  end

  def viewing
    unless viewed?
      update_attributes(viewed: true)
    end
  end

  def first_four_comments
    return Comment.where("post_id = :post_id", post_id: self.id).limit(4).includes(:user)
  end

  #returns all the friends post
  def self.user_feed(user, user_posts = true)
    active_ids = "SELECT friend_pasive_id FROM relationships WHERE friend_active_id = :user_id AND accepted = true"
    pasive_ids = "SELECT friend_active_id FROM relationships WHERE friend_pasive_id = :user_id AND accepted = true"
    #sql for the post using both previous ids and the users id, user eager loading  for users and  the media attached , improving perfomance avoiding multiple querys
    if user_posts 
      return Post.where("user_id IN (#{active_ids}) OR user_id IN (#{pasive_ids}) OR user_id = :user_id", user_id: user.id).includes(:user, media_attachment: :blob)
    else
      return Post.where("user_id IN (#{active_ids}) OR user_id IN (#{pasive_ids}) ", user_id: user.id).includes(:user, media_attachment: :blob)
    end
  end

  def self.photo_only(user)
    return Post.joins(:media_attachment).where("user_id = :user_id", user_id: user.id).includes(:user)
  end



end
