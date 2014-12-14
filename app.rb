require 'sinatra'
require 'sinatra/activerecord'

require_relative './models/user.rb'
require_relative './models/post.rb'
require_relative './models/message.rb'
require_relative './models/organization.rb'

require_relative './config/environments.rb'

get '/' do 
	erb :index
end