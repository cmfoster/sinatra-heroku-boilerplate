# -*- encoding: utf-8 -*-
require 'bundler'
Bundler.require
require 'sinatra/base'
require 'sinatra/content_for'
require 'yaml'

$PREFS = YAML.load_file('./config/prefs.yml') || {}

class MyApp < Sinatra::Base
  configure do
    set :s3_config, "http://#{$PREFS['s3_bucket']}.s3.amazonaws.com#{$PREFS['s3_path']}" if $PREFS.has_key?("s3_bucket") && $PREFS.has_key?("s3_path")
    set :google_analytics_id, "#{$PREFS['google_analytics_id']}" if $PREFS.has_key?("google_analytics_id")
  end
  before do
    @s3_prefix = settings.development? ? "" : settings.s3_config if settings.respond_to?("s3_config")
  end
  get '/' do
    erb :index
  end
end