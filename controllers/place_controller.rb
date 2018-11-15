require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/place')
also_reload('../models/*')

get '/find' do
  @places = Place.search(params[:pattern].downcase)
  @pattern = params[:pattern]
  @count = @places.length
  erb(:results)
end
