# config/initializers/pusher.rb
require 'pusher'

Pusher.url = "https://dfa7ca9e4d986fdf804d:e0fc91f44de28b7e2484@api.pusherapp.com/apps/159148"
Pusher.logger = Rails.logger

Pusher.app_id = '159148'
Pusher.key = 'dfa7ca9e4d986fdf804d'
Pusher.secret = 'e0fc91f44de28b7e2484'

# app/controllers/hello_world_controller.rb
class HelloWorldController < ApplicationController
  def hello_world
    Pusher.trigger('test_channel', 'my_event', {
      message: 'hello world'
    })
  end
end