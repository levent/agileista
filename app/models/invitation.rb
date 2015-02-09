require 'invitations/management'

class Invitation < ActiveRecord::Base
  include Invitations::Management
  belongs_to :project

  validates :email, presence: true
  validates :project_id, presence: true
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
