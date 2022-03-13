# frozen_string_literal: true

# #TODO: Documentation
class EventsController < ApplicationController
  before_action :set_event, only: %i[draw reset show edit update destroy join leave]
  before_action :create_room_id, only: %i[new]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show; end

  # POST /events/1/join
  def join
    respond_to do |format|
      if add_participant(current_user.id)
        format.html { redirect_to(event_url(@event)) }
        format.json { render(:show, status: :ok, location: @event) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  # POST /events/1/leave
  def leave
    remove_participant(current_user.id)
  end

  # GET /events/1/draw
  def draw
    ::Participation.find_by(user_id: params[:user_id], event_id: @event.id)
                   .update(
                     main_ingredient_id: Ingredient.order(Arel.sql('RANDOM()')).first.id,
                     cuisine_style_id: CuisineStyle.order(Arel.sql('RANDOM()')).first.id
                   )
    respond_to do |format|
      format.html { redirect_to(event_url(@event)) }
    end
  end

  # GET /events/1/reset?user_id=1&event_id=1
  def reset
    Participation.find_by(user_id: params[:user_id], event_id: @event.id)
                   .update(main_ingredient_id: nil, cuisine_style_id: nil)
    respond_to do |format|
      format.html { redirect_to(event_url(@event)) }
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if (@event.save)
        add_participant(current_user.id)
        format.html { redirect_to(event_url(@event)) }
        format.json { render(:show, status: :created, location: @event) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:success] = t('event.flash.update_succesful')
        format.html { redirect_to(event_url(@event)) }
        format.json { render(:show, status: :ok, location: @event) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    remove_dishes_upon_cancel_event
    @event.destroy
    respond_to do |format|
      flash[:warning] = t.('event.flash.cancel_successful')
      format.html { redirect_to(root_path) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:event_date, :title, :max_players, :owner_id, :room_id, :public)
  end

  # Only allow a list of trusted parameters through.
  def participation_params
    params.require(:event).permit(:owner_id)
  end

  def create_room_id
    loop do
      @new_room_id = SecureRandom.urlsafe_base64(4).upcase
      break unless Event.exists?(room_id: @new_room_id)
    end
  end

  def add_participant(user_id)
    if (Participation.where(event_id: @event.id).count < @event.max_players)
      Participation.new(user_id:, event_id: @event.id).save
      return flash['success'] = t('event.flash.join_successful')  if user_id != @event.owner_id
    else
      return flash['danger'] = t('event.flash.join_failed_max')
    end
    return flash['success'] = t('event.flash.create_successful')
  end

  def remove_participant(user_id)
    # TODO: confirmation before leaving/cancelling an event.

    Participation.find_by(user_id:, event_id: @event.id).destroy
    remove_dishes_upon_cancel_event(user_id)

    if user_id == @event.owner_id
      @event.destroy
      flash[:warning] = t('event.flash.cancel_successful', title: @event.title)
    else
      flash[:warning] = t('event.flash.leave_successful', title: @event.title, host: User.find(@event.owner_id).name)
    end

    respond_to do |format|
      format.html { redirect_to(root_path) }
    end
  end

  def remove_dishes_upon_cancel_event(user_id)
    s3 = Aws::S3::Client.new
    if user_id == @event.owner_id
      Dish.where(event_id: @event.id).each do |dish|
        bucket_name = ENV['AWS_S3_DISH_BUCKET']
        puts filename = dish.img_url.split("/#{bucket_name}/").last(1)[0]
        s3.delete_object(bucket: bucket_name, key: filename)
        dish.destroy
      end
    else
      Dish.where(event_id: @event.id, user_id:).each do |dish|
        bucket_name = ENV['AWS_S3_DISH_BUCKET']
        puts filename = dish.img_url.split("/#{bucket_name}/").last(1)[0]
        s3.delete_object(bucket: bucket_name, key: filename)
        dish.destroy
      end
    end
  end
end
