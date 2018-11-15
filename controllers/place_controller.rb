require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/place')
also_reload('../models/*')

get '/find' do
  @places = Place.search(params[:pattern])
  erb(:results)
end
