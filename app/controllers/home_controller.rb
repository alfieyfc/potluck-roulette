# frozen_string_literal: true

# #TODO: Documentation
class HomeController < ApplicationController
  # #TODO: Documentation
  def index
    @dishes = Dish.all
  end
end
