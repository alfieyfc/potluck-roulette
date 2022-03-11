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
    @event = Event.find(params[:dish][:event_id])
    @dish = Dish.new(dish_params)
    h = {file: params[:attachment][:file], filename: DateTime.now().strftime("%y%m%d%H%M%s") + "-" + @dish.name + "-" + params[:attachment][:file].original_filename}

    @dish.img_url = ENV['AWS_S3_ENDPOINT'] + @event.event_date.strftime("%y%m%d%H%M%s")+"-"+@event.id.to_s + "/" + ERB::Util.url_encode(h[:filename])

    s3 = Aws::S3::Resource.new
    s3.bucket(@event.event_date.strftime("%y%m%d%H%M%s")+"-"+@event.id.to_s).object(h[:filename]).upload_file(h[:file])

    respond_to do |format|
      if @dish.save
        flash[:success] = "Dish was successfully created."
        format.html { redirect_to event_url(@event) }
      else
        flash[:danger] = "Dish was not created."
        format.html { redirect_to event_url(@event) }
      end
    end
  end

  # PATCH/PUT /dishes/1 or /dishes/1.json
  def update
    @event = Event.find(params[:dish][:event_id])
    respond_to do |format|
      if @dish.update(dish_params)
        flash[:success] = "Dish was successfully updated."
        format.html { redirect_to event_url(@event) }
      else
        flash[:danger] = "Dish was not updated."
        format.html { redirect_to event_url(@event) }
      end
    end
  end

  # DELETE /dishes/1 or /dishes/1.json
  def destroy

    # TODO: confirmation before deleting a dish.
    @event = Event.find(@dish.event_id)
    @dish.destroy
    filename = @dish.img_url.split('/'+@event.event_date.strftime("%y%m%d%H%M%s")+"-"+@event.id.to_s+'/').last(1)[0]

    s3 = Aws::S3::Client.new
    s3.delete_object(bucket: @event.event_date.strftime("%y%m%d%H%M%s")+"-"+@event.id.to_s, key: filename)

    respond_to do |format|
      flash[:warning] = "Dish was successfully deleted."
      format.html { redirect_to event_url(@dish.event_id) }
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
      params.require(:dish).permit(:name, :user_id, :event_id)
    end
    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:dish).permit(:event_id)
    end
end
