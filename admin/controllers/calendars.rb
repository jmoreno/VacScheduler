VacScheduler::Admin.controllers :calendars do
  get :index do
    @title = "Calendars"
    @calendars = Calendar.all
    render 'calendars/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'calendar')
    @calendar = Calendar.new
    render 'calendars/new'
  end

  post :create do
    @calendar = Calendar.new(params[:calendar])
    if @calendar.save
      @title = pat(:create_title, :model => "calendar #{@calendar.id}")
      flash[:success] = pat(:create_success, :model => 'Calendar')
      params[:save_and_continue] ? redirect(url(:calendars, :index)) : redirect(url(:calendars, :edit, :id => @calendar.id))
    else
      @title = pat(:create_title, :model => 'calendar')
      flash.now[:error] = pat(:create_error, :model => 'calendar')
      render 'calendars/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "calendar #{params[:id]}")
    @calendar = Calendar.find(params[:id])
    if @calendar
      render 'calendars/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'calendar', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "calendar #{params[:id]}")
    @calendar = Calendar.find(params[:id])
    if @calendar
      if @calendar.update_attributes(params[:calendar])
        flash[:success] = pat(:update_success, :model => 'Calendar', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:calendars, :index)) :
          redirect(url(:calendars, :edit, :id => @calendar.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'calendar')
        render 'calendars/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'calendar', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Calendars"
    calendar = Calendar.find(params[:id])
    if calendar
      if calendar.destroy
        flash[:success] = pat(:delete_success, :model => 'Calendar', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'calendar')
      end
      redirect url(:calendars, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'calendar', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Calendars"
    unless params[:calendar_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'calendar')
      redirect(url(:calendars, :index))
    end
    ids = params[:calendar_ids].split(',').map(&:strip)
    calendars = Calendar.find(ids)
    
    if Calendar.destroy calendars
    
      flash[:success] = pat(:destroy_many_success, :model => 'Calendars', :ids => "#{ids.to_sentence}")
    end
    redirect url(:calendars, :index)
  end
end
