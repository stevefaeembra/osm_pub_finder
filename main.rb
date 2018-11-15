require('sinatra')
require('sinatra/contrib/all')

require_relative('controllers/place_controller')

get '/' do
  erb( :search )
end
