#!/usr/bin/env ruby
require 'rack'
require 'sqlite3'

class Album
  	def call(env)
		request = Rack::Request.new(env)
		case request.path
		when "/form" then render_form(request)
		when "/list" then render_list(request)
		when "/highlight.css" then render_highlight(request)
		else render_404
		end 
	end
	
	def render_form(request)
		response = Rack::Response.new
		response.write(ERB.new(File.read("form.html.erb")).result(binding))
		response.finish
	end
	
	def render_list(request)
		response = Rack::Response.new
		highlight = request.GET["rank"]
		order = request.GET["order"]
		db = SQLite3::Database.new( "albums.sqlite3.db" )
		rows = db.execute( "select * from albums ORDER BY #{order}" )
		list = ""
		rows.each do |row|
			list += "<tr"
			list += " class='highlight'" if row[0] == highlight.to_i
			list += "><td>#{row[0]}</td><td>#{row[1]}</td><td>#{row[2]}</td></tr>"
		end	
		response.write(ERB.new(File.read("list.html.erb")).result(binding))
		response.finish
	end
	
	def render_highlight(request)
		[200, {"Content-Type" => "text/css"}, [IO.binread("highlight.css")]]
	end
	
	def render_404
		[404, {"Content-Type" => "text/plain"}, ["page not found"]]
	end	

end

Signal.trap('INT'){
	Rack::Handler::WEBrick.shutdown
}

Rack::Handler::WEBrick.run Album.new, :Port => 8080
