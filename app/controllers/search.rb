VacScheduler::App.controllers :search do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    country_id = 0
    @calendar = Calendar.where("country_id = ?", country_id)
    render "search/search"
  end

  get :calendar do
    country_id = 0
    if params["country"]
        country_id = params["country"]
    end
    @calendar = Calendar.where("country_id = ?", country_id)
    partial "search/calendar"
  end

  get :results do
    calendar_id = 0
    birthday = Date.today
    if params["birthday"].length > 0
      birthday = Date.parse(params["birthday"])
    end
    months = age_in_months(birthday)
    if params["calendar"]
        calendar_id = params["calendar"]
    end
    @events = Event.joins(:age)
        .where('ages.months >= ?', months)
        .where(:calendar_id => calendar_id)
        .order('ages.months')
    render "search/results"
  end

end
