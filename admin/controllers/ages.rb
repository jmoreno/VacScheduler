VacScheduler::Admin.controllers :ages do
  get :index do
    @title = "Ages"
    @ages = Age.all
    render 'ages/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'age')
    @age = Age.new
    render 'ages/new'
  end

  post :create do
    @age = Age.new(params[:age])
    if @age.save
      @title = pat(:create_title, :model => "age #{@age.id}")
      flash[:success] = pat(:create_success, :model => 'Age')
      params[:save_and_continue] ? redirect(url(:ages, :index)) : redirect(url(:ages, :edit, :id => @age.id))
    else
      @title = pat(:create_title, :model => 'age')
      flash.now[:error] = pat(:create_error, :model => 'age')
      render 'ages/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "age #{params[:id]}")
    @age = Age.find(params[:id])
    if @age
      render 'ages/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'age', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "age #{params[:id]}")
    @age = Age.find(params[:id])
    if @age
      if @age.update_attributes(params[:age])
        flash[:success] = pat(:update_success, :model => 'Age', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:ages, :index)) :
          redirect(url(:ages, :edit, :id => @age.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'age')
        render 'ages/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'age', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Ages"
    age = Age.find(params[:id])
    if age
      if age.destroy
        flash[:success] = pat(:delete_success, :model => 'Age', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'age')
      end
      redirect url(:ages, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'age', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Ages"
    unless params[:age_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'age')
      redirect(url(:ages, :index))
    end
    ids = params[:age_ids].split(',').map(&:strip)
    ages = Age.find(ids)
    
    if Age.destroy ages
    
      flash[:success] = pat(:destroy_many_success, :model => 'Ages', :ids => "#{ids.to_sentence}")
    end
    redirect url(:ages, :index)
  end
end
