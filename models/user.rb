require 'bcrypt'

class User < ActiveRecord::Base

	attr_accessor :password

	before_save :encrypt_password

	validates_presence_of :password, :on => :create
	validates :name, presence: true
	validates :email, presence: true,
		format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
	validates :zipcode, presence: true

	has_many :posts
	has_many :messages
	has_many :organizations, through: :messages

	def authenticate(password)
		if BCrypt::Password.new(self.password_digest) == password
			return self
		else
			return nil
		end
	end

	def encrypt_password
		if password.present?
			return self.password_digest = BCrypt::Password.create(password)
		end
	end
	
end