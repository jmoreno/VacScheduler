VacScheduler::Admin.controllers :vaccines do
  get :index do
    @title = "Vaccines"
    @vaccines = Vaccine.all
    render 'vaccines/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'vaccine')
    @vaccine = Vaccine.new
    render 'vaccines/new'
  end

  post :create do
    @vaccine = Vaccine.new(params[:vaccine])
    if @vaccine.save
      @title = pat(:create_title, :model => "vaccine #{@vaccine.id}")
      flash[:success] = pat(:create_success, :model => 'Vaccine')
      params[:save_and_continue] ? redirect(url(:vaccines, :index)) : redirect(url(:vaccines, :edit, :id => @vaccine.id))
    else
      @title = pat(:create_title, :model => 'vaccine')
      flash.now[:error] = pat(:create_error, :model => 'vaccine')
      render 'vaccines/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "vaccine #{params[:id]}")
    @vaccine = Vaccine.find(params[:id])
    if @vaccine
      render 'vaccines/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'vaccine', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "vaccine #{params[:id]}")
    @vaccine = Vaccine.find(params[:id])
    if @vaccine
      if @vaccine.update_attributes(params[:vaccine])
        flash[:success] = pat(:update_success, :model => 'Vaccine', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:vaccines, :index)) :
          redirect(url(:vaccines, :edit, :id => @vaccine.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'vaccine')
        render 'vaccines/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'vaccine', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Vaccines"
    vaccine = Vaccine.find(params[:id])
    if vaccine
      if vaccine.destroy
        flash[:success] = pat(:delete_success, :model => 'Vaccine', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'vaccine')
      end
      redirect url(:vaccines, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'vaccine', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Vaccines"
    unless params[:vaccine_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'vaccine')
      redirect(url(:vaccines, :index))
    end
    ids = params[:vaccine_ids].split(',').map(&:strip)
    vaccines = Vaccine.find(ids)
    
    if Vaccine.destroy vaccines
    
      flash[:success] = pat(:destroy_many_success, :model => 'Vaccines', :ids => "#{ids.to_sentence}")
    end
    redirect url(:vaccines, :index)
  end
end
