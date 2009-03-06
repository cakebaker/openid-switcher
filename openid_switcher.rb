require 'rubygems'
require 'sinatra'

FILE_NAME = Dir.pwd + '/tmp/' + 'current_openid.txt'

get '/' do
    if File.exists?(FILE_NAME)
	file = File.open(FILE_NAME, 'r')
	selected_id = file.gets
	file.close
    else
	selected_id = '0'
	file = File.new(FILE_NAME, 'w')
	file.putc(selected_id)
	file.close
    end
    
    @openid = openids[selected_id.to_i]
    erb :index
end

get '/change' do
    @openids = openids
    erb :change
end

post '/change' do
    if File.exists?(FILE_NAME)
	file = File.open(FILE_NAME, 'r')
	selected_id = file.gets.to_i
	file.close
	
	if selected_id == openids.count - 1
	    selected_id = '0'
	else
	    selected_id = (selected_id + 1).to_s
	end
    else
	selected_id = 0;
    end

    file = File.open(FILE_NAME, 'w+')
    file.putc(selected_id)
    file.close
    
    redirect '/'
end

def openids
    [{:server => 'http://www.myopenid.com/server', :openid => 'http://dh.myopenid.com'},
     {:server => 'http://pip.verisignlabs.com/server', :openid => 'http://dho.pip.verisignlabs.com'}]
end