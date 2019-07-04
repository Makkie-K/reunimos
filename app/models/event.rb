class Event < ApplicationRecord
    validates :event_name, presence: true, length: { maximum: 50 }
    validates :description, presence: true, length: { maximum: 500}
    validates :event_date, presence: true
    validates :location, presence: true, length: { maximum: 255}

    geocoded_by :location
    after_validation :geocode, :if => :location_changed?
    #validates :latitude, presence: true
    has_many :rsvps, dependent: :destroy
end
