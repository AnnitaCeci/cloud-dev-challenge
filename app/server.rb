require 'sinatra'
require 'rubygems'
require 'aws-record'
require 'active_model'
require 'sinatra/base'
require_relative "models/landpage_lead.rb"
require_relative "controllers/landpage_lead_controller.rb"
require_relative "models/contact_message.rb"
require_relative "controllers/contact_messages_controller.rb"


before do
  if (! request.body.read.empty? and request.body.size > 0)
    request.body.rewind
    @params = Sinatra::IndifferentHash.new
    @params.merge!(JSON.parse(request.body.read))
  end
end

##################################
# For the index page
##################################
get '/' do
  erb :index
end

get '/landpage' do
  erb :landpage
end


##################################
# For the API
##################################

get '/api/lead' do
  content_type :json
  items = LandpageLeadController.list
end

post '/api/lead' do
  content_type :json
  item = LandpageLeadController.create(params)
  item.to_h.to_json
end

get '/api/contact_messages' do
  content_type :json
  if params[:email]
    messages = ContactMessagesController.get_all(params[:email])
  else
    items = ContactMessagesController.list
  end
end

post '/api/contact_messages' do
  content_type :json
  item = ContactMessagesController.create(params)
  item.to_h.to_json
end

get '/api/contact_messages/:id' do |id|
  content_type :json
  message =ContactMessagesController.get(id)
end



