class ContactController < ApplicationController

    def new
    end

    def create
        ContactJob.perform_later params.permit(:message)[:message]
        flash[:thanks] = "Thanks for your message!"
        redirect_to action: "new"
    end
end
