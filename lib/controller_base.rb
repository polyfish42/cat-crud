require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  def self.before_actions
    @before_actions ||= []
  end

  def self.before_action(callback)
    before_actions << callback
  end

  def self.inherited(child)
    before_actions.each {|c| child.before_actions << c}
  end

  def self.protect_from_forgery
    before_action :protect_from_forgery
  end

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params
    @already_built_response = false
  end

  def form_authenticity_token
    @token ||= SecureRandom.urlsafe_base64
    @res.set_cookie("authenticity_token", path: '/', value: @token)
    @token
  end

  def protect_from_forgery
    unless @req.get?
      check_authenticity_token
    end
  end

  def check_authenticity_token
    unless @params['authenticity_token'] && @params['authenticity_token'] == @req.cookies['authenticity_token']
      raise "Invalid authenticity token"
    end
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response == true
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Double render error"
    end

    @res['Location'] = url
    @res.status = 302
    session.store_session(@res)
    flash.store_flash(@res)

    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Double render error"
    end

    @res.write(content)
    @res['Content-Type'] = content_type
    session.store_session(@res)
    flash.store_flash(@res)

    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    template = ERB.new(File.read(path)).result(binding)

    render_content(template, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.class.before_actions.each {|callback| send(callback)}
    self.send(name)
    render name unless already_built_response?
  end
end
