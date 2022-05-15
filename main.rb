require 'sinatra'

configure do
  set :bind, '0.0.0.0'
end

get '/' do
  'Hello world!'
end

get '/halo_infinite' do
  'HALO Infinite'
end

get '/halo_2' do
  'HALO 2'
end