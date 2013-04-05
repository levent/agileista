class AbstractSecurityController < ApplicationController
  cache_sweeper :sprint_audit_sweeper
  prepend_before_filter :authenticate_person!

  private

  def redirect_back_or(default)
    redirect_to(return_to || default)
    clear_return_to
  end

  def store_location
    if request.get?
      session[:return_to] = request.url
      session[:return_to] = "/backlog" if session[:return_to] == "/backlog.atom"
    end
  end

  def return_to
    session[:return_to] || params[:return_to]
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def hipchat_notify(message)
    hip_chat_integration = @project.try(:hip_chat_integration)
    if hip_chat_integration && hip_chat_integration.required_fields_present?
      Resque.enqueue(HipChatJob, @project.hip_chat_integration.token, @project.hip_chat_integration.room, message)
    end
  end
end
