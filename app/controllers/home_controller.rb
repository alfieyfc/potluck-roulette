class HomeController < ApplicationController
  def index
    @dishes = Dish.all
  end
end
