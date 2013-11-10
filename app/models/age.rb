class Age < ActiveRecord::Base
	has_many :events
	validates_presence_of :short_name
	validates_presence_of :name
	validates_presence_of :months
end
