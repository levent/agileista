require 'rails_helper'

RSpec.describe ConsoleHelper, :type => :helper do

  describe "#show_account_holder" do
    before do
      @user = create_person
    end

    it "should say if none" do
      expect(show_account_holder(create_project)).to eq "NO ACCOUNT HOLDER"
    end

    it "should give info on scrum_master" do
      project = create_project(@user)
      expect(show_account_holder(project)).to eq "#{@user.name} (#{@user.email})"
    end

  end
end
