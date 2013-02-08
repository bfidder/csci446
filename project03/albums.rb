#!/usr/bin/env ruby
require 'rack'

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
		form = IO.binread("form.html")
		(1..100).each { |i| form += "<option value='#{i}'>#{i}</option>" }
		form += IO.binread("form_end.html")
		[200, {"Context-Type" => "text/html"}, [form]]
	end
	
	def render_list(request)
		highlight = request.GET["rank"]
		order = request.GET["order"]
		list = IO.binread("list.html")
		input = IO.readlines("top_100_albums.txt").collect { |x| x.chomp }
		albums = input.zip((1..100).to_a).collect { |album, rank| album.split(", ") << rank }
		list += "<p>sorted by"
		case order
		when "rank" then albums.sort_by! { |x| x[2] }; list += " rank</p>"
		when "name" then albums.sort_by! { |x| x[0] }; list += " name</p>"
		when "year" then albums.sort_by! { |x| x[1] }; list += " year</p>"
		end
		
		albums.each do |album|
			list += "<tr"
			list += " class='highlight'" if album[2] == highlight.to_i
			list += "><td>#{album[2]}</td><td>#{album[0]}</td><td>#{album[1]}</td></tr>"
		end	
		list += "</select>"
		list += "</body>"
		list += "</html>"
		[200, {"Context-Type" => "text/html"}, [list]]	
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
