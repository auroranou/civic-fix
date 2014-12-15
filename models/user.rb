class User < ActiveRecord::Base

	attr_accessor :name, :email, :password, :zipcode

	validates_presence_of :password, :on => :create
	validates :name, presence: true
	validates :email, presence: true,
		uniqueness: { case_sensitive: false },
		format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
	validates :zipcode, presence: true,
		length: 5

	has_many :posts
	has_many :messages
	has_many :organizations, through: :messages

	def authenticat(password)
		if BCrypt::Password.new(self.password) == password
			return self
		else
			return nil
	end

end