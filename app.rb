require 'sinatra'
require 'sinatra/activerecord'
require 'pry'

require_relative './models/user.rb'
require_relative './models/post.rb'
require_relative './models/message.rb'
require_relative './models/organization.rb'

require_relative './config/environments.rb'

enable :sessions

helpers do
	def current_user
		@current_user || nil
	end

	def current_user?
		@current_user == nil ? false : true
	end
end

before do
	@errors ||= []
	# @current_user = User.find_by(id: session[:user])
end

get '/' do
	erb :index
end

get '/session/signup' do
	erb :signup
end

post '/session/signup' do
	@name = params[:name]
	@email = params[:email]
	@zipcode = params[:zipcode]
	@password = BCrypt::Password.create(params[:password_digest])

	user = User.create(name: @name, email: @email, password: @password, zipcode: @zipcode)

	if user.save
		session[:user] = {id: user.id, email: @email}
		redirect('/')
	else
		@user = user
		erb :sign_up
	end
end

get '/session/login' do
	erb :login
end

post '/session/login' do
	user = User.find_by(params[:email])

	if user && user.authenticate(params[:password])
		session[:user] = {id: user.id, email: @email}
		redirect('/')
	else
		@errors << "Invalid email or password. Please try again."
		erb :login
	end
end

get '/session/logout' do
	session.clear
	redirect('/')
end