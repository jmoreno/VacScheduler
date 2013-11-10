class Country < ActiveRecord::Base
	has_many :calendars
	validates_presence_of :name
end
