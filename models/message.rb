class Message < ActiveRecord::Base
	validates :body, presence: true
	validates :mail_to, presence: true
	validates :mail_from, presence: true
	validates :user_id, presence: true

	belongs_to :user
	has_one :organization
end