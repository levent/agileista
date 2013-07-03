require 'invitations/management'

class Invitation < ActiveRecord::Base
  include Invitations::Management
  belongs_to :project

  validates_presence_of :email
  validates_presence_of :project_id
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
