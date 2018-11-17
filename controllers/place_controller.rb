require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/place')
also_reload('../models/*')

get '/find' do
  # find places matching name pattern
  @places = Place.search(params[:pattern].downcase)
  @pattern = params[:pattern]
  @count = @places.length
  erb(:results)
end

get '/find_pub' do
  # find pub matching name pattern
  @places = Place.search_pub(params[:pattern].downcase)
  @pattern = params[:pattern]
  @count = @places.length
  erb(:pubs_by_name)
end

get '/neighbours/:id' do
  # find places within a certain distance
  @place = Place.find(params[:id])
  @placename = @place.name
  @places = @place.find_nearby_places()
  @count = @places.length
  erb(:neighbours)
end

get '/pubs/:id' do
  # find pubs within a certain distance of a location
  @place = Place.find(params[:id])
  @placename = @place.name
  @places = @place.find_pubs()
  @count = @places.length
  erb(:pubs)
end
