class AcceptanceCriteriaController < AbstractSecurityController
  before_filter :set_user_story
  before_filter :set_ac

  def update
    @ac.update_attribute(:done, params["acceptance_criterium_#{@ac.id}"][:done])
  end

  private

  def set_ac
    @ac = @user_story.acceptance_criteria.find(params[:id])
  end
end
