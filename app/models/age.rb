class Age < ActiveRecord::Base
	validates_presence_of :short_name
	validates_presence_of :name
	validates_presence_of :months
end
