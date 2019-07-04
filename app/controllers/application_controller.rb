class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  # authorize_resource :class => false

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end

  # このアクションを追加
  def after_sign_in_path_for(resource)
   # "/user/#{current_user.id}"
    "/"
  end

  protected

  # 入力フォームからアカウント名情報をDBに保存するために追加
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :permission])
  end
end
