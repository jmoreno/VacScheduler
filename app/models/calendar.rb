class Calendar < ActiveRecord::Base
	belongs_to :country
	validates_presence_of :name
end
