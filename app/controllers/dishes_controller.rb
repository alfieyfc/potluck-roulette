class DishesController < ApplicationController
  prepend_before_action :set_dish, only: %i[ show edit update destroy ]

  # GET /dishes or /dishes.json
  def index
    @dishes = Dish.all
  end

  # GET /dishes/1 or /dishes/1.json
  def show
  end

  # GET /dishes/new
  def new
    @dish = Dish.new
    @event = Event.find(params[:event_id])
  end

  # GET /dishes/1/edit
  def edit
  end

  # POST /dishes or /dishes.json
  def create
    @dish = Dish.new(dish_params)
    get_event
    respond_to do |format|
      if @dish.save
        flash[:success] = "Dish was successfully created."
        format.html { redirect_to event_url(@event) }
        format.json { render :show, status: :created, location: @dish }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dishes/1 or /dishes/1.json
  def update
    get_event
    respond_to do |format|
      if @dish.update(dish_params)
        flash[:success] = "Dish was successfully updated."
        format.html { redirect_to event_url(@event) }
        format.json { render :show, status: :ok, location: @dish }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dishes/1 or /dishes/1.json
  def destroy
    @dish.destroy
    get_event
    respond_to do |format|
      flash[:warning] = "Dish was successfully deleted."
      format.html { redirect_to event_url(@event) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dish
      @dish = Dish.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def get_event
      @event = Event.find(@dish.event_id)
    end

    # Only allow a list of trusted parameters through.
    def dish_params
      params.require(:dish).permit(:name, :img_url, :user_id, :event_id)
    end
end
