class UserMailer < ApplicationMailer
    default from: 'appdevelopment6619@gmail.com'

    def welcome_email
        @user = params[:user]
        @url  = 'http://localhost:3000/login'
        mail(to: @user.email, subject: 'Welcome to Reunimos')
    end

    def rsvp_email
        @user = params[:user]
        @event = Event.find(params[:event_id])
        creator = User.find(@event.creator_id)
        mail(to: creator.email, subject: '[RSVP]' + @event.event_name)
    end

    def confirm_mail
        @event = params[:tomorrow_event]
        @user = params[:receiver]
        mail(to: @user.email, subject: '[Reunimos Information for the event]' + @event.event_name )
    end

    def delete_confirm_mail
        @event = params[:cancelled_event]
        @user = params[:receiver]
        # puts '***************************** delete_confirm_mail ***************'
        # puts @event.event_name
        # puts @user.email
        mail(to: @user.email, subject: '[Reunimos Notification of the cancelled event]' + @event.event_name )
    end
end
