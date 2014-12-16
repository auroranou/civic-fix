require 'sinatra'
require 'sinatra/activerecord'
require 'mail'
require 'pry'

require_relative './models/user.rb'
require_relative './models/post.rb'
require_relative './models/message.rb'
require_relative './models/organization.rb'
require_relative './models/mail.rb'

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
	@current_user = User.find_by(id: session[:user_id])
end

get '/' do
	@posts = Post.all
	erb :index
end

# user sign up
get '/session/signup' do
	erb :signup
end

post '/session/signup' do
	@name = params[:name]
	@email = params[:email]
	@zipcode = params[:zipcode]
	@password = params[:password]

	user = User.new(name: @name, email: @email, password: @password, zipcode: @zipcode)

	if user.save
		session[:user_id] = user.id
		redirect("/home/#{session[:user_id]}")
	else
		@user = user
		erb :signup
	end
end

# user log in
get '/session/login' do
	erb :login
end

post '/session/login' do
	user = User.find_by(email: params[:email])

	if user && user.authenticate(params[:password])
		session[:user_id] = user.id
		redirect("/home/#{session[:user_id]}")
	else
		@errors << "Invalid email or password. Please try again."
		erb :login
	end
end

# user dashboard
get '/home/:user_id' do
	params["user_id"] = session[:user_id]
	@user_id = session[:user_id]

	@user_messages = Message.where(user_id: session[:user_id])
	@user_posts = Post.where(user_id: session[:user_id])
	erb :homepage
end

# messages
get '/new_message/:user_id' do
	params["user_id"] = session[:user_id]

	@actions = Organization.pluck(:action)
	erb :new_message
end

post '/new_message/:user_id' do
	@target_org = Organization.find_by(action: params[:action])

	# Mail.new(
	# 	to: 'auroranou@gmail.com',
	# 	from: params[:mail_from],
	# 	subject: params[:subject],
	# 	body: params[:body]
	# ).deliver!

	message = Message.create(
		mail_to: @target_org.email,
		mail_from: params[:mail_from], 
		subject: params[:subject], 
		body: params[:body], 
		user_id: session[:user_id]
	)	

	redirect("/home/#{session[:user_id]}")
end

# posts
get '/new_post/:user_id' do
	params["user_id"] = session[:user_id]
	erb :new_post
end

post '/new_post/:user_id' do
	@post_title = params[:title]
	@post_desc = params[:description]
	@user_id = session[:user_id].to_i

	post = Post.create(title: @post_title, description: @post_desc, user_id: @user_id)
	redirect("/home/#{session[:user_id]}")
end

get '/update/:post_id' do
	@post_id = params["post_id"]
	@post = Post.find_by(id: params["post_id"])
	erb :update_post
end

put '/update/:post_id' do
	if @post.user_id == session[:user_id]
		updated_title = params[:title]
		updated_description = params[:description]
		post_id = params["post_id"]

		@post.title = @updated_title
		@post.description = @updated_description
		@post.save
	else
		@errors << "You are not authorized to edit this post. Please sign in to try again."
		redirect('/')
	end
end

get '/delete/:post_id' do
end

delete '/delete/:post_id' do
end

# log out
get '/session/logout' do
	session.clear
	redirect('/')
end

binding.pry