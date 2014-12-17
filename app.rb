require 'sinatra'
require 'sinatra/activerecord'
require 'mail'
# require 'pry'

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
	@posts = Post.all.order(created_at: :desc)
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
	@user_messages = Message.where(user_id: session[:user_id]).order(created_at: :desc)
	@user_posts = Post.where(user_id: session[:user_id]).order(created_at: :desc)
	erb :homepage
end

# messages
get '/message/new' do
	@actions = Organization.order(:action).pluck(:action)
	erb :new_message
end

post '/message/new' do
	@target_org = Organization.find_by(action: params[:action])

	Mail.new(
		to: 'auroranou@gmail.com',
		from: params[:mail_from],
		subject: params[:subject],
		body: params[:body]
	).deliver!

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

patch '/post/update/:post_id' do
	@post = Post.find_by(id: params["post_id"])
	if @post.user_id == session[:user_id]
		@post.title = "#{@post.title} - UPDATED"
		@post.description = params[:description]
		@post.save
		redirect('/home')
	else
		@errors << "You are not authorized to edit this post. Please sign in to try again."
		redirect('/')
	end
end

get '/post/delete/:post_id' do
	@post_id = params["post_id"]
	@post = Post.find_by(id: params["post_id"])
	erb :delete_post
end

delete '/post/delete/:post_id' do
	@post = Post.find_by(id: params["post_id"])
	if @post.user_id == session[:user_id]
		@post.delete
		redirect('/home')
	else
		@errors << "You are not authorized to delete this post. Please sign in to try again."
		redirect('/')
	end
end

# log out
get '/session/logout' do
	session.clear
	redirect('/')
end

# manage user account
get '/manage' do
	erb :delete_user
end

delete '/manage' do
	if @current_user && params[:delete]
		@current_user.destroy
	else
		@errors << "You are not authorized to make changes to this account. Please sign in to try again."
	end
	redirect('/')
end

# about and contact
get '/about' do
	erb :about
end

post '/about' do
	Mail.new(
		to: 'auroranou@gmail.com',
		from: params[:mail_from],
		subject: params[:subject],
		body: params[:body]
	).deliver!
end

