# config.ru (run with rackup)
require 'rubygems'
require 'bundler'

Bundler.require

require './server'
run Sinatra::Application
