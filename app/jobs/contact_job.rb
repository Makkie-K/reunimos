class ContactJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Do something later
    ContactMailer.submission(message).deliver
  end
end
