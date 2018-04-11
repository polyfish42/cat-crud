require 'rack'
require_relative '../lib/controller_base/router'
require_relative '../lib/controller_base/static'
require_relative '../app/controllers/cats_controller'
require_relative '../lib/model_base/db_connection'

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/cats/(?<id>\\d+)/edit$"), CatsController, :edit
  post Regexp.new("^/cats$"), CatsController, :create
  post Regexp.new("^/cats/(?<id>\\d+)/delete"), CatsController, :destroy
  post Regexp.new("^/cats/(?<id>\\d+)"), CatsController, :update
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
