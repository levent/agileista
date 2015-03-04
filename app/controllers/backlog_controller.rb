class BacklogController < AbstractSecurityController
  before_action :project_user_stories

  def index
    store_location
    @velocity = @project.average_velocity
    @uid = generate_hexdigest('backlog', @project.id)
    load_story_points
    respond_to do |format|
      format.html do
      end
      format.csv do
        render text: @user_stories.to_csv
      end
    end
  end

  def sort
    @user_stories.find(params[:user_story_id]).update_attribute(:backlog_order_position, params[:move_to])
    json = {
      notification: "Backlog reordered by #{current_person.name}",
      performed_by: current_person.name
    }
    uid = generate_hexdigest('backlog', @project.id)
    REDIS.publish "pubsub.#{uid}", json.to_json
    render json: {ok: true, velocity: @project.average_velocity}.to_json
  end

  def destroy_multiple
    if params[:user_stories] && params[:user_stories].any?
      @user_stories.where("ID IN (?)", params[:user_stories]).destroy_all
      flash[:notice] = "User stories #{params[:user_stories].join(', ')} deleted successfully"
    else
      flash[:error] = "No user stories deleted"
    end
    redirect_back_or(project_backlog_index_path(@project))
  end

  private

  def load_story_points
    @story_points = 0
    @user_stories.collect{|x| @story_points += x.story_points if x.story_points}
  end

  # excludes DONE
  def project_user_stories
    @user_stories = @project.user_stories.unassigned.rank(:backlog_order)
  end

end
