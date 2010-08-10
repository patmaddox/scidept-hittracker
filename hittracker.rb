require 'sinatra'
require 'sinatra/sequel'
require 'json'

if ENV['RACK_ENV'] == 'development'
  set :database, 'sqlite://foo.db'
end

migration "create hits table" do
  database.create_table :hits do
    primary_key :id
    timestamp :created_at
    text :content
  end
end

class Hit < Sequel::Model; end

get '/hits' do
  database[:hits].all.to_json
end

post '/' do
  if params[:hit]
    database[:hits].insert(:created_at => Time.now, :content => params[:hit])
    "OK"
  else
    "missing hit param"
  end
end