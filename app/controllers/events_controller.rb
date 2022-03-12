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
        flash[:success] = 'Event was successfully updated.'
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
      flash[:warning] = 'Event was successfully destroyed.'
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
      return flash['success'] = 'You successfully joined.' if user_id != @event.owner_id
    else
      return flash['danger'] = 'Event exceeded maximum player count.'
    end
    return flash['success'] = 'Event was successfully created.'
  end

  def remove_participant(user_id)
    # TODO: confirmation before leaving/cancelling an event.

    Participation.find_by(user_id:, event_id: @event.id).destroy

    if user_id == @event.owner_id
      @event.destroy
      remove_dishes_upon_cancel_event
      msg = "The event \"#{@event.title}\" was cancelled."
    else
      msg = "You have left the event \"#{@event.title}\" hosted by #{User.find(@event.owner_id).name}."
    end

    respond_to do |format|
      flash[:warning] = msg
      format.html { redirect_to(root_path) }
    end
  end

  def remove_dishes_upon_cancel_event
    s3 = Aws::S3::Client.new
    Dish.where(event_id: @event.id).each do |dish|
      filename = dish.img_url.split("/#{ENV['AWS_S3_DISH_BUCKET']}/").last(1)[0]
      s3.delete_object(bucket: ::ENV['AWS_S3_DISH_BUCKET'], key: filename)
      dish.destroy
    end
  end
end
