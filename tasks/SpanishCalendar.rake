namespace :SpanishCalendar do
	desc "import data from files to database"
	task :import => :environment do
		$ages = ['NB', '1m', '2m', '4m', '6m', '12m', '15m', '18m', '2y', '3y', '4y', '6y', '10y', '11y', '12y', '13y', '14y', '16y']
		$vaccines = ['DTPa', 'HA', 'HB', 'Hib', 'MenC', 'SRP', 'Td ', 'Tdpa', 'Var', 'VNC', 'VPH', 'VPI']
		$calendar = ""

		Country.delete_all
		Calendar.delete_all
		Event.delete_all

		$country = Country.find_or_create_by_name("Spain")
		 
		fichero = File.open('./tasks/Vacunas20130726.csv', "r") 
		 
		fichero.each { |file|  
			rowIn = file.split(';')
			if rowIn[0] != '' && rowIn[0] != '-'
				$calendar = Calendar.find_or_create_by_name(rowIn[0])
				$calendar.country = $country
				$calendar.save!
			end  
			rowIn.each_with_index.map { |field, index|
				if index > 1 && field != '' && field != '-' && field != $\
					$age = Age.find_by_short_name($ages[index - 2])

					$vaccines.each { |vaccine_short_name|
						if field.match(/#{vaccine_short_name}/)
			
							$vaccine = Vaccine.find_by_short_name(vaccine_short_name)

							event = Event.create()
							event.calendar = $calendar
							event.age = $age
							event.vaccine = $vaccine
							event.notes = field
							event.save!

						end
					}
				end  
			}
		}
	end
end

namespace :Vaccines do
	desc "import data from files to database"
	task :import => :environment do

		Vaccine.delete_all

		fichero = File.open('./tasks/vacunas.csv', "r") 
		 
		fichero.each { |file|  
			rowIn = file.split(';')
			vaccine = Vaccine.create()
			vaccine.short_name = rowIn[0]
			vaccine.name = rowIn[1]
			vaccine.save!
		}
	end
end

namespace :Ages do
	desc "import data from files to database"
	task :import => :environment do

		Age.delete_all

		fichero = File.open('./tasks/edades.csv', "r") 
		 
		fichero.each { |file|  
			rowIn = file.split(';')
			age = Age.create()
			age.short_name = rowIn[0]
			age.months = rowIn[1]
			age.name = rowIn[2]
			age.save!
		}
	end
end