class Vaccine < ActiveRecord::Base
	has_many :events
	validates_presence_of :short_name
	validates_presence_of :name
end
