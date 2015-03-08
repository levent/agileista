require 'rails_helper'

RSpec.describe SprintMailer, type: :mailer do
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries = []
  end

  describe "#summary_email" do
    let!(:person) { create_person }
    let!(:project) { create_project(person) }
    let!(:sprint) { create_sprint(project) }
    let(:email) { ActionMailer::Base.deliveries.last }

    before do
      SprintMailer.summary_email(person, sprint).deliver_now
    end

    it "should send to person" do
      expect(email.to).to eq [person.email]
    end

    it "should send from agileista" do
      expect(email.from).to eq ['notifications@agileista.local']
    end

    it "should have a useful subject" do
      expect(email.subject).to eq "[#{project.name}] Daily Sprint Summary"
    end

    context "when no stories" do
      it "should send a relevant sprint summary (html)" do
        html_source = email.parts[1].body.raw_source
        expect(html_source).to include "There are no complete stories."
        expect(html_source).to include "There are no incomplete stories."
        expect(html_source).to include "There are no stories in progress."
      end

      it "should send a relevant sprint summary (plain text)" do
        plain_source = email.parts[0].body.raw_source
        expect(plain_source).to include "There are no complete stories."
        expect(plain_source).to include "There are no incomplete stories."
        expect(plain_source).to include "There are no stories in progress."
      end
    end

    context "when stories" do
      before do
        complete = create_user_story(project)
        incomplete = create_user_story(project)
        inprogress = create_user_story(project)
        allow(complete).to receive(:status) { 'complete' }
        allow(incomplete).to receive(:status) { 'incomplete' }
        allow(inprogress).to receive(:status) { 'inprogress' }
        allow(sprint).to receive(:user_stories) { [complete, incomplete, inprogress] }
        SprintMailer.summary_email(person, sprint).deliver_now
      end

      it "should send a relevant sprint summary (html)" do
        html_source = email.parts[1].body.raw_source
        sprint.user_stories.each do |us|
          expect(html_source).to include "#{us.definition}"
        end
      end

      it "should send a relevant sprint summary (plain text)" do
        plain_source = email.parts[0].body.raw_source
        sprint.user_stories.each do |us|
          expect(plain_source).to include "##{us.id} #{us.definition}"
        end
      end
    end
  end
end
