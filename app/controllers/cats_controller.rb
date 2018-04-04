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
    @cat = Cat.new
    @cat.instance_variable_set('@attributes', params["cat"])

    if @cat.save
      flash[:notice] = "Saved cat successfully"
      redirect_to "/cats"
    else
      flash.now[:errors] = "There was an error saving that cat."
      render :new
    end
  end

  def show
    @cat = Cat.find(params["id"])

    render :show
  end

  def edit
    @cat = Cat.find(params["id"])

    render :new
  end

  def update
    @cat = Cat.find(params["id"])
    @cat.name = params["cat"]["name"]
    @cat.owner_id = params["cat"]["owner"]
    
    if @cat.save
      flash[:notice] = "Cat updated successfully."
      redirect_to "/cats"
    else
      flash.now[:errors] = "There was an error updating the cat."
      render :new
    end
  end

  def destroy
    @cat = Cat.find(params["id"])
    @cat.delete
    redirect_to "/cats"
  end
end
