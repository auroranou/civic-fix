class Organization < ActiveRecord::Base
	validates :org_name, presence: true, uniqueness: true
	validates :email, presence: true
	validates :phone, presence: true
	validates :address, presence: true
	validate :contact_name

	has_many :users, through: :messages
end