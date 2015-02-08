class ChatIntegration < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :project
  validates_presence_of :project_id

  def required_fields_present?
    raise NotImplementedError, "required_fields_present? is not implemented"
  end
end
