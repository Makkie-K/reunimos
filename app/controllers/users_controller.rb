class UsersController < ApplicationController
  load_and_authorize_resource
  def login
  end

  def create
  end

  def index
    @users = User.all
  end

  def update
    
    user = User.find_by(email: params[:email])
    return if update_check_admin(user)==false
    user.permission = params[:permission]
    user.save
    redirect_to users_index_path
    
   
  end
  private

  def update_check_admin(user)
    if user.permission == "admin"
      if User.where(permission:"admin").count <= 1
        flash[:danger] = 'Please set at least 1 admin.'
        redirect_to users_index_path and return false
      end
    end
  end
end
