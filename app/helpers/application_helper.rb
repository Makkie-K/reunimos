module ApplicationHelper
    def getRsvpMembers e_id
        rsvps = Rsvp.where(event_id: e_id)
        members = []
        rsvps.each do |r|
            members.push(User.find(r.user_id))
        end
        return members
    end

    def rsvpCheck e_id
        Rsvp.exists?(event_id: e_id, user_id: current_user.id)
    end

end
