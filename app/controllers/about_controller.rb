class AboutController < ApplicationController
  def index
    redirect_to projects_path if person_signed_in? && request.path != "/about"
  end
end
