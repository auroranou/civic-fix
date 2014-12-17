class Post < ActiveRecord::Base

	validates :title, presence: true
	validates :description, presence: true
	validates :user_id, presence: true

	belongs_to :user

	def posted_by

	end

end
