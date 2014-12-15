class Organization < ActiveRecord::Base
	validates :org_name, presence: true, uniqueness: true
	validates :email, presence: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }
	validates :phone, presence: true
	validates :address, presence: true
	validate :contact_name

	has_many :users, through: :messages
end