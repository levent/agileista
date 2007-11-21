class AcceptanceCriterium < ActiveRecord::Base
  
  # acts_as_versioned
  
  belongs_to :user_story
  
  validates_presence_of :detail
end
