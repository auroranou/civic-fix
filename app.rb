require 'sinatra'
require 'sinatra/activerecord'
# require 'pry'

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
  # @current_user = User.find_by(id: session[:user][:id])
end

get '/' do 
	@posts = Post.all
	erb :index
end

get '/signup' do
	erb :signup
end

post '/signup' do
  user = User.new(name: params[:name], email: params[:email], password: params[:password])
  if user.save
    session[:user] = {id: user.id, email: user.email}
    redirect('/home/#{session[:user][:id]}')
  else
    @user = user
    erb :signup
  end
end

get '/login' do
	erb :login
end

post '/login' do
	user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
		session[:user] = {id: user.id, email: user.email}
    redirect('/home/#{session[:user][:id]}')
  else
    @errors << "Invalid email or password. Try again!"
    erb :login
  end
end

get '/home/:user_id' do
	@user_id = session[:user][:id]
	@user_messages = Message.find_by(users_id: session[:user][:id])
	@user_posts = Post.find_by(users_id: session[:user][:id])
	erb :homepage
end

get '/new_message/:user_id' do
	erb :new_message
end

post '/new_message/:user_id' do
end

get '/new_post/:user_id' do
	erb :new_post
end

post '/new_post/:user_id' do
	@user_id = session[:user][:id]

end

get '/logout' do 
	session.clear
	redirect('/')
end

# binding.pry