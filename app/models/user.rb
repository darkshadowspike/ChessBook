
class User < ApplicationRecord
	attr_accessor :activation_token, :remember_token
	#Has_secure_passwords Adds methods to set and authenticate  a password with  BCrypt password
	has_secure_password 
	before_save :downcase_email	
	before_create :create_activation_hash

	#validations of user attributes

	validates :first_name, :last_name,:gender, presence: true, length:{maximum: 20}
	validates :user_name, presence: true,  allow_nil: true, length: {maximum: 20}

	#only letter regex
	NAME_REGEX = /\A[a-zA-Z]+\z/
	validates :first_name, :last_name, format: {with: NAME_REGEX, message: "Only allows letters"}

	# simple email regex
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email ,length: {maximum: 250}, uniqueness: {case_sensitive: false}, format: {with: EMAIL_REGEX, message: "Only allows valid emails"}, presence: true
	
	#male or female regex
	GENDER_REGEX = /\A(fe)*male\z/i
	validates :gender, format: {with: GENDER_REGEX, message: "Should be either female or male" }
	validates :birthday, presence: true
	validate :birthdate_cannot_be_before_1900
	validates :password, presence: true,  allow_nil: true, length: {in: 6..15}

	has_many :posts, dependent: :destroy


	# method made for birthday validation

	def birthdate_cannot_be_before_1900
		if birthday && birthday < Date.parse('1899-12-31')
			errors.add(:birthday, "invalid date")
		end
	end

	#Sends activation email after creation

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end


	#returns token using SecureRandom module generator and url_sage base 64 to make a value usable in urls
	def self.new_token
		SecureRandom.urlsafe_base64
	end

	# returns hash digest froma string
 	
 	def self.digest(string)
 		BCrypt::Password.create(string)
 	end

	#verfies a string comparing it to a digest in the databse, returns t

	def authentic?(attribute, string)
		# uses send to call the attribute
		attr_digest = self.send("#{attribute}_digest")
		if attr_digest.nil?
			false
		else
			#creates a new instance of Bcrypt to use method is_password? in our attr_digest
			BCrypt::Password.new(attr_digest).is_password?(string)
		end
	end

	#update the columns of activation

	def activation 
		update_columns(activated: true, activated_at: Time.zone.now)
	end

	#creates a token as an instace variable u and saves the digest of that token in the atribute remember_token

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_token, User.digest(remember_token))
	end

	#deletes token

	def forget
		self.remember_token = nil 
		update_attribute(:remember_digest, nil)
	end
	

	private

	def downcase_email
		self.email = self.email.downcase
	end

	#creates activation token  and its digest and assign them like instace variables
	def create_activation_hash
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end
