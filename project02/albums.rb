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
		response = Rack::Response.new(request.path)
		response.finish
	end
	
	def render_404
		[404, {"Content-Type" => "text/plain"}, ["page not found"]]
	end	

end

Signal.trap('INT'){
	Rack::Handler::WEBrick.shutdown
}

Rack::Handler::WEBrick.run Album.new, :Port => 8080
