class HomeController < ApplicationController
  def index
    @dishes = Dish.all
    @users = User.all
  end
end
