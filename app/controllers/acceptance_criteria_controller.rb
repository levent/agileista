class AcceptanceCriteriaController < AbstractSecurityController
  
  before_filter :must_be_team_member
  before_filter :set_user_story
  before_filter :set_acceptance_criterion, :only => [:update, :destroy]
  
  def create
    # return false unless @user_story
    @acceptance_criterion = @user_story.acceptance_criteria.new(params[:acceptance_criterion])
    @acceptance_criterion.save
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render :partial => 'user_stories/acceptance_criteria'}
    end
  end
  
  def update
    # return false unless @user_story
    @acceptance_criterion.update_attribute(:detail, params[:value])
    render :text => @acceptance_criterion.detail
  end
  
  def destroy
    # return false unless @user_story
    @acceptance_criterion.destroy
    respond_to do |format|
      format.html {redirect_to :back}
      format.json {render :partial => 'user_stories/acceptance_criteria'}
    end
  end
  
  private
  
  def set_acceptance_criterion
    @acceptance_criterion = @user_story.acceptance_criteria.find(params[:id])
  end
  
end