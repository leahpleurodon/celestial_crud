  
require 'sinatra'
require_relative 'db_config'   
require_relative 'models/galaxy'
require_relative 'models/planet'
require_relative 'models/moon'
require_relative 'models/user'
enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end
  def logged_in?
    !!current_user
  end

end

get '/' do
  @galaxies = Galaxy.where(featured: true)
  @planets = Planet.where(featured: true)
  @moons = Moon.where(featured: true)
  erb :index
end

# -------get/index

get '/planets' do
  @planets = Planet.all
  erb :"planets/index"
end

get '/moons' do
  @moons = Moon.all
  erb :"moons/index"
end

get '/galaxies' do
  @galaxies = Galaxy.all
  erb :"galaxies/index"
end

# -------get/show

get '/planet/:id' do
  @planet = Planet.find(params[:id])
  erb :"planets/show"
end
get '/galaxy/:id' do
  @galaxy = Galaxy.find(params[:id])
  erb :"galaxies/show"
end

get '/moon/:id' do
  @moon = Moon.find(params[:id])
  erb :"moons/show"
end

# -------get/edit form

get '/moon/:id/edit' do
  if logged_in?
    @moon = Moon.find(params[:id])
    @planets = Planet.all
    erb :"moons/edit"
  else
    redirect "/moon/#{params[:id]}"
  end
end

get '/planet/:id/edit' do
  if logged_in?
    @planet = Planet.find(params[:id])
    @galaxies = Galaxy.all
    erb :"planets/edit"
  else
    redirect "/planet/#{params[:id]}"
  end
end

get '/galaxy/:id/edit' do
  if logged_in?
  @galaxy = Galaxy.find(params[:id])
  erb :"galaxies/edit"
  else
    redirect "/galaxy/#{params[:id]}"
  end
end

# -------put/edit

put '/planet/:id' do
  if logged_in?
    planet = Planet.find(params[:id])
    planet.name = params[:name]
    planet.photo_url = params[:photo_url]
    planet.featured = params[:featured]
    planet.blurb = params[:blurb]
    planet.galaxy_id = params[:galaxy_id]
    planet.save
  end
    redirect "/planet/#{params[:id]}"
end

put '/moon/:id' do
  if logged_in?
    moon = Moon.find(params[:id])
    moon.name = params[:name]
    moon.photo_url = params[:photo_url]
    moon.featured = params[:featured]
    moon.blurb = params[:blurb]
    moon.planet_id = params[:planet_id]
    moon.save
  end
  redirect "/moon/#{params[:id]}"
end

put '/galaxy/:id' do
  if logged_in?
    galaxy = Galaxy.find(params[:id])
    galaxy.name = params[:name]
    galaxy.photo_url = params[:photo_url]
    galaxy.featured = params[:featured]
    galaxy.blurb = params[:blurb]
    galaxy.save
  end
  redirect "/galaxy/#{params[:id]}"
end

# -------post/new

post '/planet' do
  if logged_in?
    planet = Planet.new
    planet.name = params[:name]
    planet.photo_url = params[:photo_url]
    planet.blurb = params[:blurb]
    planet.featured = false
    planet.galaxy_id = params[:galaxy_id]
    planet.save
  end
  redirect "/planets"
end

post '/moon' do
  if logged_in?
    moon = Moon.new
    moon.name = params[:name]
    moon.photo_url = params[:photo_url]
    moon.blurb = params[:blurb]
    moon.featured = false
    moon.planet_id = params[:planet_id]
    moon.save
  end
  redirect "/moons"
end

post '/galaxy' do
  if logged_in?
    galaxy = Galaxy.new
    galaxy.name = params[:name]
    galaxy.photo_url = params[:photo_url]
    galaxy.blurb = params[:blurb]
    galaxy.features = false
    galaxy.save
  end
  redirect "/galaxies"
end

# -------get/new form

get '/moons/new' do
  if logged_in?
    @planets = Planet.all
    erb :"moons/new"
  else
    redirect '/moons'
  end
end

get '/planets/new' do
  if logged_in?
    @galaxies = Galaxy.all
    erb :"planet/new"
  else
    redirect '/planets'
  end
end

get '/galaxies/new' do
  if logged_in?
    erb :"galaxies/new"
  else
    redirect 'galaxies'
  end
end

# -------sessions

get '/session' do
  erb :login
end

post '/session' do
  #grab email and pass from params
  #find user 
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    #authenticate user with pass
    #create new session
    #redirect to something
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  #delete the session
  session[:user_id] = nil
  redirect '/session'
end
