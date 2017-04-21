# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'
require 'net/http'
require 'uri'
require 'json'

class MySlackBot < SlackBot
  # cool code goes here
  def message_respond(params, options = {})
    return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"
    
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    text = params[:text] ? params[:text] : ""

    if text.match(/岡山の天気/) then
      res = Net::HTTP.get(URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=330010'))
      res2 = JSON.parse(res)
      res3 = res2['description']['text']
      
      return {text: "#{user_name} #{res3}"}.merge(options).to_json
    end

    if text.match(/.*「.*」と言って.*/) then
       text_part = text.match(/.*「(.*)」と言って.*/)
       
      
      return {text: "#{user_name} #{text_part[1]}"}.merge(options).to_json
      
    end
    
    return {text: "#{user_name} Hi!"}.merge(options).to_json 
    
  end
  
end

slackbot = MySlackBot.new

set :environment, :production

get '/' do
  "SlackBot Server"
end

post '/slack' do
  content_type :json
  slackbot.message_respond(params, username: "Bot")
end

