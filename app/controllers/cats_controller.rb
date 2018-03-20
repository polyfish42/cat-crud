require_relative 'app_controller'
require_relative '../models/cat'

class CatsController < ControllerBase
  protect_from_forgery

  def index
    @cats = Cat.all

    render :index
  end

  def new
    @cat = Cat.new

    render :new
  end

  def create
    @cat = Cat.attributes(params["cat"])
    if @cat.save
      flash[:notice] = "Saved cat successively"
      redirect_to "/cats"
    else
      flash.now[:errors] = "There was an error saving that cat"
      render :new
    end
  end
end
