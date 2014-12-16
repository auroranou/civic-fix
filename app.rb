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
	user = User.new(name: params[:name], email: params[:email], password: params[:password], zipcode: params[:zipcode])

	if user.save
		session[:user_id] = user.id
		redirect("/home")
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
		redirect("/home")
	else
		@errors << "Invalid email or password. Please try again."
		erb :login
	end
end

# user dashboard
get '/home' do
	@user_id = session[:user_id]
	@user_messages = Message.where(user_id: session[:user_id])
	@user_posts = Post.where(user_id: session[:user_id])
	erb :homepage
end

# messages
get '/message/new' do
	@actions = Organization.pluck(:action)
	erb :new_message
end

post '/message/new' do
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
	redirect("/home")
end

# posts
get '/post/new' do
	erb :new_post
end

post '/post/new' do
	post = Post.create(title: params[:title], description: params[:description], user_id: session[:user_id].to_i)
	redirect("/home")
end

get '/post/update/:post_id' do
	@post_id = params["post_id"]
	@post = Post.find_by(id: params["post_id"])
	erb :update_post
end

put '/post/update/:post_id' do
	@post = Post.find_by(id: params["post_id"])
	if @post.user_id == session[:user_id]
		update_post = Post.find_by(id: params["post_id"])
		update_post.title = params[:title]
		update_post.description = params[:description]
		update_post.save
		redirect('/home')
	else
		@errors << "You are not authorized to edit this post. Please sign in to try again."
		redirect('/')
	end
end

get '/post/delete/:post_id' do
end

delete '/post/delete/:post_id' do
end

# log out
get '/session/logout' do
	session.clear
	redirect('/')
end

# binding.pry