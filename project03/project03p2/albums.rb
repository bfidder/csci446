#!/usr/bin/env ruby
require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get "/form" do
	erb :form
end

post "/list" do 
	@order = params[:order]
	@albums = Album.all(:order => [@order.to_sym])
	@highlight = params[:rank]
	erb :list
end	

