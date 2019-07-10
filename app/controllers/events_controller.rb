class EventsController < ApplicationController
  load_and_authorize_resource
  def top
    @events = Event.all
  end

  def show  
    @event = Event.find(params[:id])
    id = @event[:creator_id]
    @creator = User.find(id)
    show_set_json
    
  end

  def create
    # This action is to display an event create page.
  end

  def new
    eventdate = DateTime.parse(params[:date].to_s+ ' ' + params[:time].to_s).to_s(:db) if (params[:date]!= "" && params[:time] != "") # .to_s(:db)で秒情報まで取得
    
    @event = Event.new(event_name: params[:event_name], description: params[:description], event_date: eventdate, location: params[:location], creator_id: current_user.id )
      #event[:creator_id]= current_user.id
      if @event.save 
        redirect_to events_show_path(@event.id)
      else
        render 'create' and return# This 'return' is to end this method.
      end

  end

  def rsvp_create
    if current_user.id != Event.find(params[:event_id]).creator_id
      rsvp = Rsvp.new(event_id: params[:event_id], user_id: current_user.id)
      rsvp.save
      UserMailer.with(user: current_user, event_id: params[:event_id]).rsvp_email.deliver_now
      redirect_to(events_show_path(params[:event_id]))
    end
  end

  def delete 
    event = Event.find(params[:id])
    receivers = []
    Rsvp.where(event_id: params[:id]).each do |r|
      # puts "********************** delete ***********************"
      # puts r.user_id
      receivers.push(User.find(r.user_id))
    end
    delete_event_destroy(event, receivers)
    
  end

  def edit
    @event = Event.find(params[:id])
    #puts @event[:event_date]
    @date = @event[:event_date].strftime("%Y-%m-%d")
    @time = @event[:event_date].strftime("%H:%M")
    #puts @date
    
  end

  def update
    event_updated = Event.find(params[:id])
    @date = event_updated[:event_date].strftime("%Y-%m-%d")
    @time = event_updated[:event_date].strftime("%H:%M")
    update_change_event(event_updated)
    update_event_save(event_updated)  
  end

  private

  def show_set_json
    if (@event[:latitude]!=nil &&@event[:longitude] != nil)
      respond_to do |format|
        format.html
        format.json do 
          render json:  { type: 'Feature', geometry: { type: 'Point', coordinates: [@event.latitude, @event.longitude] }, properties: { name: @event.event_name, location: @event.location }}
        end
      end
    end
  end

  def delete_event_destroy(event, receivers)
    if event.destroy
      #puts "****************** deleted ************************" 
      receivers.each do |rece|
        #puts rece.email
        UserMailer.with(receiver: rece, cancelled_event: event).delete_confirm_mail.deliver_now
    
      end
      
      redirect_to(root_path)
    else
      redirect_to(events_show_path(params[:id]))
    end
  end

  def update_change_event(event_updated)
    event_updated[:event_name] = params[:event_name]
    event_updated[:description] = params[:description]
    
    dateTime = DateTime.parse(params[:date] + ' ' + params[:time]).to_s(:db) if params[:date]!= "" && params[:time] != ""
    event_updated[:event_date] = dateTime
    event_updated[:location] = params[:location]
  end

  def update_event_save(event_updated)
    if event_updated.save 
      flash[:success] = 'The event has been successfully updated.'
      redirect_to(events_show_path(event_updated.id))
    else
      render 'edit' and return
    end
  end
end
