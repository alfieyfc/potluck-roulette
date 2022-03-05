class HomeController < ApplicationController
  def index
    @dishes = Dish.all
    @users = User.all
    @events = Event.all
  end
end
