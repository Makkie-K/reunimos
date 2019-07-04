class MailDeliveryTask
    def self.mail_confirmation
        events = Event.where("event_date >= ? AND event_date < ?", Date.tomorrow, Date.tomorrow+1)
        events.each do |e|
            Rsvp.where(event_id: e.id).each do |r|
                
                UserMailer.with(receiver: User.find(r.user_id), tomorrow_event: e).confirm_mail.deliver_now
            end
        end    
    end
end