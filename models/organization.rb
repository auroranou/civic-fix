class Organization < ActiveRecord::Base

	validates :org_name, presence: true
	validates :email, presence: true,
		format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
	validates :address, presence: true
	validates :phone, presence: true
	validate :contact_name

	has_many :messages
	has_many :users, through: :messages

end