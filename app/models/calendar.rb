class Calendar < ActiveRecord::Base
	has_many :events
	belongs_to :country
	validates_presence_of :name
end
