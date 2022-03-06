class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy join leave]

  before_action :create_room_id, only: %i[ new ]


  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    @users = User.all
    @participations = Participation.all
  end

  # POST /events/1/join
  def join
    add_participant(current_user.id, @event.id)
  end

  # POST /events/1/leave
  def leave
    remove_participant(current_user.id, @event.id)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        add_participant(current_user.id, @event.id)
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
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
      break unless Event.exists?(:room_id => @new_room_id)
    end
  end

  def add_participant(user_id, event_id)
    @participation = Participation.new(user_id: user_id, event_id: event_id)

    respond_to do |format|
      if @participation.save
        if current_user.id != @event.owner_id
          format.html { redirect_to event_url(@event), notice: "You successfully joined." }
          format.json { render :show, status: :created, location: @event }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_participant(user_id, event_id)
    if user_id == @event.owner_id
      @event.destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      Participation.find_by(user_id: user_id, event_id: event_id).destroy
      respond_to do |format|
        format.html { redirect_to events_url, notice: "You have left an event." }
        format.json { head :no_content }
      end
    end
  end

end
