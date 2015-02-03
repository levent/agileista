class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :ensure_domain
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    projects_path
  end

  def ensure_domain
    main_domain = 'app.agileista.com'
    redirect_to "https://#{main_domain}" if request.env['HTTP_HOST'] != main_domain && Rails.env.production?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
