class Project::OverviewController < ApplicationController
  before_filter :must_be_logged_in
  before_filter :project_must_exist
  
  def show
  end
  
end
