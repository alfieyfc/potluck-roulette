class DishesController < ApplicationController
  before_action :set_dish, only: %i[ show edit update destroy ]

  # GET /dishes or /dishes.json
  def index
    @dishes = Dish.all
    @dishes_user = DishesUser.all
  end

  # GET /dishes/1 or /dishes/1.json
  def show
  end

  # GET /dishes/new
  def new
    @dish = Dish.new
    @dishes_user = DishesUser.new
  end

  # GET /dishes/1/edit
  def edit
  end

  # POST /dishes or /dishes.json
  def create
    @dish = Dish.new(dish_params)
    respond_to do |format|
      if @dish.save
        format.html { redirect_to dish_url(@dish), notice: "Dish was successfully created." }
        format.json { render :show, status: :created, location: @dish }
        @dishes_user = DishesUser.new(dishes_user_params(@dish.id))
        @dishes_user.save
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dishes/1 or /dishes/1.json
  def update
    respond_to do |format|
      if @dish.update(dish_params)
        format.html { redirect_to dish_url(@dish), notice: "Dish was successfully updated." }
        format.json { render :show, status: :ok, location: @dish }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dishes/1 or /dishes/1.json
  def destroy
    @dishes_user = DishesUser.find_by(dish_id: @dish.id)
    @dish.destroy
    @dishes_user.destroy

    respond_to do |format|
      format.html { redirect_to dishes_url, notice: "Dish was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dish
      @dish = Dish.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dish_params
      params.require(:dish).permit(:name, :img_url)
    end

    def dishes_user_params(id)
      h = params.require(:dish).permit(:user_id)
      h["dish_id"] = id
      h
    end
end
