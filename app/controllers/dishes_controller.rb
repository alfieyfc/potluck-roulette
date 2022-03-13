# frozen_string_literal: true

# #TODO: Documentation
class DishesController < ApplicationController
  prepend_before_action :set_dish, only: %i[show edit update destroy]

  # GET /dishes or /dishes.json
  def index
    @dishes = ::Dish.all
  end

  # GET /dishes/1 or /dishes/1.json
  # TODO: show full image & description (new field)
  def show; end

  # GET /dishes/new
  def new
    @dish = Dish.new
    @event = Event.find(params[:event_id])
  end

  # GET /dishes/1/edit
  def edit; end

  # POST /dishes or /dishes.json
  def create
    @event = Event.find(params[:dish][:event_id])
    @dish = Dish.new(dish_params)
    file = params[:attachment][:file]
    filename = "#{Time.now.strftime('%y%m%d%H%M%s')}-#{@dish.name}-#{params[:attachment][:file].original_filename}"
    bucket_name = ENV['AWS_S3_DISH_BUCKET']
    if ENV['RAILS_ENV'] == "development"
      folder_name = bucket_name
      file_key = filename
    else
      folder_name = "#{@event.event_date.strftime('%y%m%d%H%M%s')}-#{@event.id}"
      file_key = "#{folder_name}/#{filename}"
    end

    object_uri = "#{bucket_name}/#{file_key}"

    @dish.img_url = "#{ENV['AWS_S3_ENDPOINT']}#{ERB::Util.url_encode(object_uri)}"

    obj = Aws::S3::Resource.new.bucket(folder_name).object(filename)
    obj.upload_file(file)
    obj.copy_from({acl: 'public-read', content_type: 'image/jpeg', metadata_directive: 'REPLACE', copy_source: object_uri})

    respond_to do |format|
      if @dish.save
        flash[:success] = 'Dish was successfully created.'
      else
        flash[:danger] = 'Dish was not created.'
      end
      format.html { redirect_to(event_url(@event)) }
    end
  end

  # PATCH/PUT /dishes/1 or /dishes/1.json
  def update
    # TODO: Update S3 image file if uploaded new file
    @event = Event.find(params[:dish][:event_id])
    respond_to do |format|
      if @dish.update(dish_params)
        flash[:success] = 'Dish was successfully updated.'
      else
        flash[:danger] = 'Dish was not updated.'
      end
      format.html { redirect_to(event_url(@event)) }
    end
  end

  # DELETE /dishes/1 or /dishes/1.json
  def destroy
    # TODO: confirmation before deleting a dish.
    @event = Event.find(@dish.event_id)

    puts bucket_name = ENV['AWS_S3_DISH_BUCKET']
    puts file_key = @dish.img_url.split("#{bucket_name}%2F").last(1)[0]
    puts s3 = Aws::S3::Client.new
    puts s3.delete_object(bucket: bucket_name, key: file_key)

    @dish.destroy

    respond_to do |format|
      flash[:warning] = 'Dish was successfully deleted.'
      format.html { redirect_to(event_url(@dish.event_id)) }
      format.json { head(:no_content) }
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
