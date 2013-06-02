class AboutController < ApplicationController
  before_filter :redirect_to_projects
  caches_page :index

  def index
  end

  private

  def redirect_to_projects
    redirect_to projects_path if person_signed_in? && request.path != "/about"
  end
end
