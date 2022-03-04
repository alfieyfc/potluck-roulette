class HomeController < ApplicationController
  def index
    @dishes = Dish.all
    @dishes_users = DishesUser.all
    @users = User.all
  end
end
