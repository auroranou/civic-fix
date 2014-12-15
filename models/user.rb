require "bcrypt"

class User < ActiveRecord::Base

	attr_accessor :password

	# validations
	validates :name, presence: true
	validates :email, presence: true, uniqueness: true
	validates :password, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }
	# validates :password_confirmation, presence: true

	# associations
	has_many :posts
	has_many :messages
	has_many :organizations, through: :messages

	# methods
	def authenticate(password)
		if BCrypt::Password.new(self.password) == password
			return self
		else
			return nil
		end
	end

	def encrypt_password
		if password.present?
			return self.password = BCrypt::Password.create(password)
		end
	end

end