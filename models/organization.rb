class Organization < ActiveRecord::Base
	validates :org_name, presence: true
	validates :email, presence: true
	validates :phone
	validates :address
	validates :contact_name

	has_many :users, through: :messages
end