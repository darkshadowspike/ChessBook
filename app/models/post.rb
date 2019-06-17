class Post < ApplicationRecord
  belongs_to :user
  #using a lambda with default scope to retrive all ways the latest
  default_scope -> { order(created_at: :desc)}
  validates :user_id, :content, presence: true
  validates :content, length: {maximum: 130}
  validate :media_attached
  has_one_attached :media

  def media_attached
  	if self.media.attached?
	  	unless (media.content_type =~ /image.+/im || media.content_type =~ /video\/(mp4|webm|ogg)/im) && media.byte_size.to_f/1000000 <= 110
	  		errors.add(:media, "invalid file type")
	  	end
  	end
  end

end
