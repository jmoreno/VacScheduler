# Helper methods defined here can be accessed in any controller or view in the application

VacScheduler::Vacscheduler.helpers do
  # def simple_helper_method
  #  ...
  # end
  def age_in_months(birthday)
  	today = Date.today
  	(today.year - birthday.year) * 12 + today.month - birthday.month - (today.day >= birthday.day ? 0 : 1)
  end
end
