require 'rubygems'
require 'sinatra'
require 'configuration'

class Openid
	FILE_NAME = Dir.pwd + '/tmp/' + 'current_openid.txt'

	def self.current
		if File.exists?(FILE_NAME)
			id = get_id_of_current_openid
		else
			write_default_id_to_file
			id = 0
		end

		Configuration.openids.size > id ? Configuration.openids[id] : Configuration.openids.last
	end

	def self.change_current(id)
		write_id_to_file(id) if id =~ /\d+/
	end

	private
	
	def self.get_id_of_current_openid
		file = File.open(FILE_NAME, 'r')
		id = file.gets
		file.close
		id.to_i
	end

	def self.write_default_id_to_file
		default_id = 0
		File.open(FILE_NAME, 'w') {|file| file.write(default_id) }
	end

	def self.write_id_to_file(id)
		File.open(FILE_NAME, 'w') {|file| file.write(id) }
	end
end

get '/' do
	if Configuration.openids.size > 0
		@openid = Openid.current
		erb :index
	else
		erb :no_openids
	end
end

get '/change' do
	redirect '/' if Configuration.openids.size <= 1
	@current_openid = Openid.current
	@openids = Configuration.openids
	erb :change
end

post '/change' do
	Openid.change_current(params[:openid_id])

	redirect '/'
end
