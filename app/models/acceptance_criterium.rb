class AcceptanceCriterium < ActiveRecord::Base  
  belongs_to :user_story
  
  validates_presence_of :detail
end
