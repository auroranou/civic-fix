class Message < ActiveRecord::Base

	validates :mail_to, presence: true
	validates :mail_from, presence: true
	validates :subject,	presence: true
	validates :body, presence: true
	validates :user_id, presence: true

	belong_to :user
	has_one :organization
end