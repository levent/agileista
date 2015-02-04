require 'rails_helper'

RSpec.describe CalculateBurnWorker, type: :model do
  before do
    @project = create_project
    @sprint = create_sprint(@project)
  end

  it "should create a burndown entry for the date and sprint" do
    CalculateBurnWorker.new.perform(Date.today, @sprint.id)
    burndown = @sprint.burndowns.last
    expect(burndown.created_on).to eq Date.today
    expect(burndown.hours_left).to eq 0
  end
end
