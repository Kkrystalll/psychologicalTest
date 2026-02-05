require 'line/bot'
require 'certifi'

ENV['SSL_CERT_FILE'] = Certifi.where

LINE_CLIENT = Line::Bot::Client.new do |config|
  config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
  config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
end