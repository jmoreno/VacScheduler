class Event < ActiveRecord::Base
	belongs_to :calendar
	belongs_to :age
	belongs_to :vaccine
end
